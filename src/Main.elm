port module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Content
import ContentChoices exposing (choiceStepsList)
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
import Video
import View.Desktop
import View.Documents
import View.Emails
import View.EndInfo exposing (view)
import View.Intro exposing (view)
import View.Landing exposing (view)
import View.Messages exposing (view)
import View.PathChecker
import View.Social



-- MODEL


type alias Model =
    { key : Browser.Navigation.Key
    , page : Route
    , data : Content.Datastore
    , gameData : GameData
    , visited : Set.Set String
    , isFirstVisit : Bool
    , requestedWatchAgain : Bool
    , activeIntroVideo : Video.Video
    , notifications : NotificationCount
    , socialInput : String
    }


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        maybeRoute =
            Route.fromUrl url

        datastore =
            Content.datastoreDictDecoder flags
    in
    -- If not a valid route, default to Landing
    ( { key = key
      , page = Maybe.withDefault Landing maybeRoute
      , data = datastore
      , gameData = GameData.init
      , visited = Set.empty
      , isFirstVisit = True
      , requestedWatchAgain = False
      , activeIntroVideo = Video.Intro1
      , notifications = GameData.notificationsInit
      , socialInput = ""
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
                    -- If not a valid Route, default to Landing
                    Maybe.withDefault Landing (Route.fromUrl url)

                newVisits =
                    Set.insert (Route.toString newRoute) model.visited

                isFirstVisit =
                    not (Set.member (Route.toString newRoute) model.visited)

                newGameData =
                    model.gameData

                newChoicesVisited =
                    -- whenever the route changes, store the choice
                    -- ONLY IF WE WERE ON MESSAGES to start with
                    case model.page of
                        Messages ->
                            Set.fromList (choiceStepsList model.gameData.choices)

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
                    { updatedListViewNotifications | emails = Dict.size (filterEmails model.data.emails model.gameData.choices model.gameData.teamName) - Set.size (Set.filter (\item -> String.contains "/emails/" item) newVisits) }

                updatedSingleViewNotifications2 =
                    { updatedSingleViewNotifications | documents = Dict.size (filterDocuments model.data.documents model.gameData.choices) - Set.size (Set.filter (\item -> String.contains "/documents/" item) newVisits) }

                resetViewport =
                    case newRoute of
                        Messages ->
                            resetViewportDesktopBottom

                        _ ->
                            resetViewportTop
            in
            ( { model
                | page = newRoute
                , visited = newVisits
                , isFirstVisit = isFirstVisit
                , requestedWatchAgain = False
                , activeIntroVideo = Video.Intro1
                , gameData = updatedGameData
                , notifications = updatedSingleViewNotifications2
              }
            , resetViewport
            )

        WatchDocumentVideoClicked ->
            ( { model | requestedWatchAgain = True }, Cmd.none )

        WatchIntroVideoClicked video ->
            ( { model
                | activeIntroVideo = video

                -- If Your assignment video is watched mark the doc as read
                , visited = Set.insert "/documents/your-assignment" model.visited
              }
            , Cmd.none
            )

        ChoiceButtonClicked choice ->
            let
                --debug =
                --   Debug.log "NEWSCORE" (Debug.toString (GameData.updateEconomicScore model.data model.gameData choice))
                newChoicesVisited =
                    -- whenever the route changes, store the choice
                    -- ONLY IF WE WERE ON MESSAGES to start with
                    case model.page of
                        Messages ->
                            Set.fromList (choiceStepsList model.gameData.choices)

                        _ ->
                            model.gameData.choicesVisited

                newGameData =
                    { choices = choice :: model.gameData.choices
                    , choicesVisited = newChoicesVisited
                    , checkboxSet = model.gameData.checkboxSet
                    , teamName = model.gameData.teamName
                    , scoreSuccess = GameData.updateScore Success model.data model.gameData.socialsPosted model.gameData.choices choice
                    , scoreEconomic = GameData.updateScore Economic model.data model.gameData.socialsPosted model.gameData.choices choice
                    , scoreHarm = GameData.updateScore Harm model.data model.gameData.socialsPosted model.gameData.choices choice
                    , socialsPosted = model.gameData.socialsPosted
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
                    , messagesNeedAttention =
                        GameData.unactionedMessageChoices model.data.messages newGameData.choices
                    , emailsNeedAttention =
                        GameData.unactionedEmailChoices model.data.emails newGameData.choices model.gameData.teamName
                    , documents =
                        model.notifications.documents
                            + (Dict.size (filterDocuments model.data.documents newGameData.choices) - Dict.size (filterDocuments model.data.documents model.gameData.choices))
                    , emails =
                        model.notifications.emails
                            + (Dict.size (filterEmails model.data.emails newGameData.choices model.gameData.teamName) - Dict.size (filterEmails model.data.emails model.gameData.choices model.gameData.teamName))
                    , social =
                        -- Not passing in tweets posted, should not matter for count.
                        model.notifications.social
                            + (Dict.size (filterSocials model.data.social newGameData.choices Dict.empty) - Dict.size (filterSocials model.data.social model.gameData.choices Dict.empty))
                    }

                -- If we just clicked a choice in an email, redirect to list
                pageAfterClick =
                    case model.page of
                        Email _ ->
                            Emails

                        _ ->
                            model.page
            in
            case choice of
                "send" ->
                    ( { model | page = EndInfo, gameData = GameData.init, notifications = newNotifications }, Cmd.none )

                "replay" ->
                    ( { model | page = Intro, gameData = GameData.init, notifications = GameData.notificationsInit }, Cmd.none )

                _ ->
                    ( { model | page = pageAfterClick, gameData = newGameData, notifications = newNotifications }, Cmd.none )

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
                    , socialsPosted = model.gameData.socialsPosted
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
                    , socialsPosted = model.gameData.socialsPosted
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
                    , socialsPosted = model.gameData.socialsPosted
                    }
            in
            ( { model | gameData = newGameData }, Cmd.none )

        SocialInputAdded text ->
            ( { model | socialInput = text }, Cmd.none )

        PostSocial lastSocialKey socialText ->
            let
                -- LastSocial = grab the most recent social key
                -- Generate socialData
                -- Add to socialsPosted
                -- In View.Social intersperse tweets after lastSocialKey
                teamName =
                    model.gameData.teamName

                socialCount =
                    Dict.size model.gameData.socialsPosted

                newSocial =
                    { triggered_by = []
                    , author = teamName
                    , handle = "@" ++ teamName
                    , image = Nothing
                    , content = socialText

                    -- Key by count social it follows & count of social posts
                    , basename = lastSocialKey ++ String.fromInt socialCount
                    , numComments = 0
                    , numRetweets = 0
                    , numLoves = 0
                    }

                newGameData =
                    { choices = model.gameData.choices
                    , choicesVisited = model.gameData.choicesVisited
                    , checkboxSet = model.gameData.checkboxSet
                    , teamName = model.gameData.teamName
                    , scoreSuccess = model.gameData.scoreSuccess
                    , scoreEconomic = model.gameData.scoreEconomic
                    , scoreHarm = model.gameData.scoreHarm
                    , socialsPosted = Dict.insert newSocial.basename newSocial model.gameData.socialsPosted
                    }
            in
            ( { model | socialInput = "", gameData = newGameData }, Cmd.none )

        PathCheckerMsg subMsg ->
            case model.page of
                PathChecker _ ->
                    updatePathChecker model (View.PathChecker.update subMsg)

                _ ->
                    ( model, Cmd.none )

        CookieAccepted ->
            ( model, enableAnalytics True )

        NoOp ->
            ( model, Cmd.none )


port enableAnalytics : Bool -> Cmd msg


updatePathChecker : Model -> ( View.PathChecker.Model, Cmd View.PathChecker.Msg ) -> ( Model, Cmd Msg )
updatePathChecker model ( pathChecker, cmds ) =
    ( { model | page = Route.PathChecker pathChecker }
    , Cmd.map PathCheckerMsg cmds
    )



--VIEW


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = t (titleKeyFromPage model.page), body = [ view model ] }


titleKeyFromPage : Route -> Key
titleKeyFromPage page =
    case page of
        Desktop ->
            DesktopTitle

        Documents ->
            DocumentsTitle

        Document id ->
            DocumentTitle id

        Emails ->
            EmailsTitle

        Email id ->
            EmailTitle id

        Messages ->
            MessagesTitle

        Social ->
            SocialTitle

        Intro ->
            IntroTitle

        EndInfo ->
            EndInfoTitle

        Landing ->
            LandingTitle

        PathChecker _ ->
            PathCheckerTitle


view : Model -> Html Msg
view model =
    case model.page of
        Desktop ->
            View.Desktop.view model.gameData model.page model.notifications

        Documents ->
            div []
                [ View.Desktop.renderTopNavigation model.gameData.teamName
                , View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Documents.list model.gameData model.data.documents model.visited
                    ]
                ]

        Document id ->
            div []
                [ View.Desktop.renderTopNavigation model.gameData.teamName
                , View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Documents.single
                        (Dict.get id model.data.documents)
                        { isFirstVisit = model.isFirstVisit
                        , hasRequestedWatch = model.requestedWatchAgain
                        }
                    ]
                ]

        Emails ->
            div []
                [ View.Desktop.renderTopNavigation model.gameData.teamName
                , View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Emails.list model.gameData model.data.emails model.visited
                    ]
                ]

        Email id ->
            div []
                [ View.Desktop.renderTopNavigation model.gameData.teamName
                , View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Emails.single model.gameData (Dict.get id model.data.emails)
                    ]
                ]

        Messages ->
            div []
                [ View.Desktop.renderTopNavigation model.gameData.teamName
                , View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Messages.view model.gameData model.data
                    ]
                ]

        Social ->
            div []
                [ View.Desktop.renderTopNavigation model.gameData.teamName
                , View.Desktop.renderWrapperWithNav model.gameData
                    model.page
                    model.notifications
                    [ View.Social.view model.socialInput model.gameData model.data.social
                    ]
                ]

        Intro ->
            div []
                [ View.Intro.view model.activeIntroVideo
                ]

        Landing ->
            div []
                [ View.Landing.view
                ]

        EndInfo ->
            div []
                [ View.EndInfo.view
                ]

        PathChecker pathChecker ->
            div []
                [ Html.map PathCheckerMsg (View.PathChecker.view pathChecker model.data) ]


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
