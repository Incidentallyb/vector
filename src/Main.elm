module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (href)
import Json.Decode exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Task
import Url
import View.Desktop
import View.Document
import View.Email exposing (view)
import View.Emails exposing (view)
import View.Messages exposing (view)
import View.Social



-- MODEL


type alias Datastore =
    { messages : Dict String Content.MessageData
    , documents : Dict String Content.DocumentData
    }


type alias Model =
    { key : Browser.Navigation.Key
    , page : Route
    , data : Datastore
    }

flagsDictDecoder : Json.Decode.Decoder Datastore 
flagsDictDecoder = 
    map2 Datastore (field "messages" Content.messageDictDecoder) (field "documents" Content.documentDictDecoder)


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        maybeRoute =
            Route.fromUrl url

        datastore = case  Json.Decode.decodeValue flagsDictDecoder flags of
                Ok goodMessages ->
                    goodMessages

                Err _ ->
                    { messages = Dict.empty, documents = Dict.empty }
{- to debug the above
                    let
                        debugger =
                            Debug.log "Json Decode Error" (Debug.toString dataError)
                    in                
-}
    in
    -- If not a valid route, default to Desktop
    ( { key = key, page = Maybe.withDefault Desktop maybeRoute, data = datastore }, Cmd.none )



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
                    -- If not a valid Route, default to Desktop
                    Maybe.withDefault Desktop (Route.fromUrl url)
            in
            ( { model | page = newRoute }, resetViewportTop )

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
                    [ View.Document.list
                    ]
                ]

        Document id ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Document.single id
                    ]
                ]

        Emails ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Emails.view
                    ]
                ]

        Email id ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ View.Email.view id
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


renderHeading : String -> Html Msg
renderHeading title =
    h1 [] [ text title ]


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
