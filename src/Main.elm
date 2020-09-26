module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict
import Html exposing (Html, div, h1, text)
import Json.Decode
import Message exposing (Msg(..))
import Route exposing (Route(..))
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
    , choices : List String
    }


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        maybeRoute =
            Route.fromUrl url

        datastore =
            Content.datastoreDictDecoder flags

        choiceData =
            []
    in
    -- If not a valid route, default to Desktop
    ( { key = key, page = Maybe.withDefault Intro maybeRoute, data = datastore, choices = choiceData }, Cmd.none )



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
            in
            ( { model | page = newRoute }, resetViewportTop )

        ChoiceButtonClicked choice ->
            ( { model | choices = choice :: model.choices }, Cmd.none )

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
            View.Desktop.view model.page

        Documents ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Documents.list model.data.documents
                    ]
                ]

        Document id ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Documents.single (Dict.get id model.data.documents)
                    ]
                ]

        Emails ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Emails.list model.data.emails
                    ]
                ]

        Email id ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Emails.single (Dict.get id model.data.emails)
                    ]
                ]

        Messages ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Messages.view
                    ]
                ]

        Social ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Social.view
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
