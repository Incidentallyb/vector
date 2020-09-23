module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Debug
import Dict exposing (Dict)
import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (href)
import Http
import Json.Decode exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Task
import Url
import View.Desktop



-- MODEL


type alias Model =
    { key : Browser.Navigation.Key
    , page : Route
    , data : Dict String MessageData
    }


type alias MessageData =
    { triggered_by : List String
    , author : String
    , choices : List String
    , preview : String
    , content : String
    , basename : String
    }


messageDictDecoder : Json.Decode.Decoder (Dict String MessageData)
messageDictDecoder =
    Json.Decode.dict
        (map6 MessageData
            (field "triggered_by" (list string))
            (field "author" string)
            (field "choices" (list string))
            (field "preview" string)
            (field "content" string)
            (field "basename" string)
        )


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        maybeRoute =
            Route.fromUrl url

        data =
            flags
                |> Json.Decode.decodeValue messageDictDecoder
                |> Result.withDefault Dict.empty
    in
    -- If not a valid route, default to Desktop
    ( { key = key, page = Maybe.withDefault Desktop maybeRoute, data = data }, Cmd.none )



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
                    [ renderDocumentList
                    ]
                ]

        Document id ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ renderDocument id
                    ]
                ]

        Emails ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ renderEmailList
                    ]
                ]

        Email id ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ renderEmail id
                    ]
                ]

        Messages ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ renderHeading "Messages"
                    ]
                ]

        Social ->
            div []
                [ View.Desktop.renderWrapperWithNav model.page
                    [ renderHeading "Social"
                    ]
                ]


renderHeading : String -> Html Msg
renderHeading title =
    h1 [] [ text title ]


renderDocumentList : Html Msg
renderDocumentList =
    ul []
        [ li [] [ a [ href (Route.toString (Document 1)) ] [ text "Document number 1" ] ]
        , li [] [ a [ href (Route.toString (Document 2)) ] [ text "Document number 2" ] ]
        ]


renderDocument : Int -> Html Msg
renderDocument id =
    div [] [ text ("Document with id: " ++ String.fromInt id) ]


renderEmailList : Html Msg
renderEmailList =
    ul []
        [ li [] [ a [ href (Route.toString (Email 1)) ] [ text "Email number 1" ] ]
        , li [] [ a [ href (Route.toString (Email 2)) ] [ text "Email number 2" ] ]
        ]


renderEmail : Int -> Html Msg
renderEmail id =
    div [] [ text ("Email with id: " ++ String.fromInt id) ]


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
