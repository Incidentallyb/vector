module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict
import GameData exposing (GameData, NotificationCount, ScoreType(..), filterDocuments, filterEmails, filterMessages, filterSocials, init)
import Html exposing (Html, div)
import Json.Decode
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Set
import Task
import Url
import View.Desktop
import View.Documents
import View.Emails
import View.Intro exposing (view)
import View.Messages exposing (view)
import View.Social
import Route



-- MODEL


type alias Model =
    { key : Browser.Navigation.Key
    , page : Route
    , data : Content.Datastore
    , gameData : GameData
    , visited : Set.Set String
    , notifications : NotificationCount
    }


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        maybeRoute =
            Route.fromUrl url

        datastore =
            Content.datastoreDictDecoder flags
    in
    -- If not a valid route, default to Desktop
    ( { key = key
      , page = Maybe.withDefault Intro maybeRoute
      , data = datastore
      , gameData = GameData.init
      , visited = Set.empty
      , notifications = { messages = 1, documents = 1, emails = 0, social = 0 }
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Browser.Navigation.load href
                    )

        UrlChanged url ->
            let
                newRoute =
                    -- If not a valid Route, default to Intro
                    Maybe.withDefault Intro (Route.fromUrl url)

                newVisits =
                    Set.insert (Route.toString newRoute) model.visited
                newGameData = 
                   model.gameData 

                newChoicesVisited =
                    -- whenever the route changes, store the choice 
                    -- ONLY IF WE WERE ON MESSAGES to start with
                    case model.page of
                        Messages ->
                            Set.insert (String.join "|" (List.reverse model.gameData.choices)) newGameData.choicesVisited
                        _ ->
                            newGameData.choicesVisited
                    
                updatedGameData = 
                   { newGameData | choicesVisited = newChoicesVisited }
                   
                currentNotifications =
                    model.notifications

                -- If we visit a route that automatically "reads" content, set the notifications to 0
                updatedListViewNotifications =
                    case newRoute of
                        Messages ->
                            { currentNotifications | messages = 0 }

                        Social ->
                            { currentNotifications | social = 0 }

                        _ ->
                            currentNotifications

                -- For any route change, check which manually readable content needs notifications
                -- We'll probably move this calc to the Desktop view and remove from model
                updatedSingleViewNotifications =
                    { updatedListViewNotifications | emails = Dict.size (filterEmails model.data.emails model.gameData.choices) - Set.size (Set.filter (\item -> String.contains "/emails/" item) newVisits) }

                updatedSingleViewNotifications2 =
                    { updatedSingleViewNotifications | documents = Dict.size (filterDocuments model.data.documents model.gameData.choices) - Set.size (Set.filter (\item -> String.contains "/documents/" item) newVisits) }
            
                cmdToSend = 
                  case newRoute of
                        Messages ->
                            resetViewportDesktopBottom
                        _ -> 
                            resetViewportTop

            in
            ( { model | page = newRoute, visited = newVisits, gameData = updatedGameData, notifications = updatedSingleViewNotifications2 }, cmdToSend )

        ChoiceButtonClicked choice ->
            let
                --debug =
                --   Debug.log "NEWSCORE" (Debug.toString (GameData.updateEconomicScore model.data model.gameData choice))
                newGameData =
                    { choices = choice :: model.gameData.choices
                    , choicesVisited = model.gameData.choicesVisited
                    , checkboxSet = model.gameData.checkboxSet
                    , teamName = model.gameData.teamName
                    , scoreSuccess = GameData.updateScore Success model.data model.gameData.choices choice
                    , scoreEconomic = GameData.updateScore Economic model.data model.gameData.choices choice
                    , scoreHarm = GameData.updateScore Harm model.data model.gameData.choices choice
                    }

                -- Take the current notifications and add the number of items filtered by the new choice
                -- Hopefully this will be handled in the view and if we need to post msg to update
                newNotifications =
                    { messages =
                        if model.page == Messages then
                            0

                        else
                            model.notifications.messages
                                + (Dict.size (filterMessages model.data.messages newGameData.choices) - Dict.size (filterMessages model.data.messages model.gameData.choices))
                    , documents =
                        model.notifications.documents
                            + (Dict.size (filterDocuments model.data.documents newGameData.choices) - Dict.size (filterDocuments model.data.documents model.gameData.choices))
                    , emails =
                        model.notifications.emails
                            + (Dict.size (filterEmails model.data.emails newGameData.choices) - Dict.size (filterEmails model.data.emails model.gameData.choices))
                    , social =
                        model.notifications.social
                            + (Dict.size (filterSocials model.data.social newGameData.choices) - Dict.size (filterSocials model.data.social model.gameData.choices))
                    }
            in
            ( { model | gameData = newGameData, notifications = newNotifications }, Cmd.none )

        CheckboxClicked value ->
            let
                selected =
                    if model.gameData.checkboxSet.submitted then
                        -- Do Nothing we've already submitted these.
                        model.gameData.checkboxSet.selected

                    else if Set.member value model.gameData.checkboxSet.selected then
                        -- Uncheck it
                        Set.remove value model.gameData.checkboxSet.selected

                    else if
                        -- We might want to add hint message to uncheck another choice
                        -- Right now we only have one checkbox set that allows max 2 choices
                        Set.size model.gameData.checkboxSet.selected < 2
                    then
                        if value == "donothing" then
                            -- remove any previously ticked
                            Set.fromList [ value ]

                        else
                            -- Add it and remove "donothing" if it was there
                            Set.insert value (Set.remove "donothing" model.gameData.checkboxSet.selected)

                    else
                        -- Do nothing. We already have 2 choices.
                        model.gameData.checkboxSet.selected

                -- Nothing is a special case. It should cause others to unset / not be available.
                newGameData =
                    { choices = model.gameData.choices
                    , choicesVisited = model.gameData.choicesVisited
                    , checkboxSet = { selected = selected, submitted = model.gameData.checkboxSet.submitted }
                    , teamName = model.gameData.teamName
                    , scoreSuccess = model.gameData.scoreSuccess
                    , scoreEconomic = model.gameData.scoreEconomic
                    , scoreHarm = model.gameData.scoreHarm
                    }
            in
            ( { model | gameData = newGameData }, Cmd.none )

        CheckboxesSubmitted choice ->
            let
                noneSelected =
                    Set.size model.gameData.checkboxSet.selected == 0

                newGameData =
                    { choices = model.gameData.choices

                    -- Right now we only have one. Later we might pass an id.
                    , choicesVisited = model.gameData.choicesVisited
                    , checkboxSet = { selected = model.gameData.checkboxSet.selected, submitted = True }
                    , teamName = model.gameData.teamName
                    , scoreSuccess = model.gameData.scoreSuccess
                    , scoreEconomic = model.gameData.scoreEconomic
                    , scoreHarm = model.gameData.scoreHarm
                    }
            in
            if noneSelected then
                -- Do nothing
                ( model, Cmd.none )

            else
                ( { model | gameData = newGameData }
                  -- Hack to chain an update.
                , Task.perform (always (ChoiceButtonClicked choice)) (Task.succeed ())
                )

        TeamChosen teamName ->
            let
                newGameData =
                    { choices = [ "init" ]
                    , choicesVisited = model.gameData.choicesVisited
                    , checkboxSet = model.gameData.checkboxSet
                    , teamName = teamName
                    , scoreSuccess = model.gameData.scoreSuccess
                    , scoreEconomic = model.gameData.scoreEconomic
                    , scoreHarm = model.gameData.scoreHarm
                    }
            in
            ( { model | gameData = newGameData }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



--VIEW


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = t SiteTitle, body = [ view model ] }


view : Model -> Html Msg
view model =
    case model.page of
        Desktop ->
            View.Desktop.view model.gameData model.page model.notifications

        Documents ->
            div []
                [ View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Documents.list model.gameData model.data.documents model.visited
                    ]
                ]

        Document id ->
            div []
                [ View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Documents.single (Dict.get id model.data.documents)
                    ]
                ]

        Emails ->
            div []
                [ View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Emails.list model.gameData model.data.emails model.visited
                    ]
                ]

        Email id ->
            div []
                [ View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Emails.single model.gameData (Dict.get id model.data.emails)
                    ]
                ]

        Messages ->
            div []
                [ View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Messages.view model.gameData model.data
                    ]
                ]

        Social ->
            div []
                [ View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Social.view model.gameData model.data.social
                    ]
                ]

        Intro ->
            div []
                [ View.Intro.view
                ]


resetViewportTop : Cmd Msg
resetViewportTop =
    Task.perform (\_ -> NoOp) (Browser.Dom.setViewport 0 0)

resetViewportDesktopBottom : Cmd Msg
resetViewportDesktopBottom = 
    Browser.Dom.getViewportOf "desktop"
        |> Task.andThen (\info -> Browser.Dom.setViewportOf "desktop" 0 info.scene.height)
        |> Task.attempt (\_ -> NoOp)


-- SUBSCRIPTIONS & FLAGS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


type alias Flags =
    Json.Decode.Value


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = viewDocument
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
