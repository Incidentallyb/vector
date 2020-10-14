module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict
import GameData exposing (GameData, NotificationCount, ScoreType(..), filterEmails, filterMessages, filterSocials, init)
import Html exposing (Html, div)
import Json.Decode
import Message exposing (Msg(..))
import Route exposing (Route(..), toString)
import Set
import Task
import Url
import View.Desktop
import View.Documents
import View.Emails
import View.Intro exposing (view)
import View.Messages exposing (view)
import View.Social



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
      , notifications = { messages = 1, documents = 0, emails = 0, social = 0 }
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

                currentNotifications =
                    model.notifications

                -- If we visit a route that automatically "reads" content, set the notifications to 0
                updatedListViewNotifications =
                    case newRoute of
                        Messages ->
                            { currentNotifications | messages = 0 }

                        Documents ->
                            { currentNotifications | documents = 0 }

                        Social ->
                            { currentNotifications | social = 0 }

                        _ ->
                            currentNotifications

                -- For any route change, check which manually readable content needs notifications
                -- We'll probably move this calc to the Desktop view and remove from model
                updatedSingleViewNotifications =
                    { updatedListViewNotifications | emails = Dict.size (filterEmails model.data.emails model.gameData.choices) - Set.size (Set.filter (\item -> String.contains "/emails/" item) newVisits) }
            in
            ( { model | page = newRoute, visited = newVisits, notifications = updatedSingleViewNotifications }, resetViewportTop )

        ChoiceButtonClicked choice ->
            let
                --debug =
                --   Debug.log "NEWSCORE" (Debug.toString (GameData.updateEconomicScore model.data model.gameData choice))
                newGameData =
                    { choices = choice :: model.gameData.choices
                    , teamName = model.gameData.teamName
                    , scoreSuccess = GameData.updateScore Success model.data model.gameData choice
                    , scoreEconomic = GameData.updateScore Economic model.data model.gameData choice
                    , scoreHarm = GameData.updateScore Harm model.data model.gameData choice
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
                    , documents = model.notifications.documents
                    , emails =
                        model.notifications.emails
                            + (Dict.size (filterEmails model.data.emails newGameData.choices) - Dict.size (filterEmails model.data.emails model.gameData.choices))
                    , social = model.notifications.social + (Dict.size (filterSocials model.data.social newGameData.choices) - Dict.size (filterSocials model.data.social model.gameData.choices))
                    }
            in
            ( { model | gameData = newGameData, notifications = newNotifications }, Cmd.none )

        TeamChosen teamName ->
            let
                newGameData =
                    { choices = [ "init" ]
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
                    [ View.Documents.list model.data.documents
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
                    [ View.Messages.view model.gameData model.data.messages
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



-- SUBSCRIPTIONS & FLAGS


subscriptions : Model -> Sub Msg
subscriptions model =
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
