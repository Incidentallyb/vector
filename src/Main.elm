module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (href)
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Task
import Url
import View.Desktop



-- MODEL


type alias Model =
    { key : Browser.Navigation.Key
    , page : Route
    }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        maybeRoute =
            Route.fromUrl url
    in
    -- If not a valid route, default to Desktop
    ( { key = key, page = Maybe.withDefault Desktop maybeRoute }, Cmd.none )



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
    { title = "Vector App", body = [ view model ] }


view : Model -> Html Msg
view model =
    case model.page of
        Desktop ->
            View.Desktop.view

        Documents ->
            div []
                [ View.Desktop.renderWrapperWithNav [ 
                        renderHeading "Documents"
                        , renderDocumentList 
                    ]
                ]

        Document id ->
            div []
                [ View.Desktop.renderWrapperWithNav [ 
                    renderHeading "Single Document"
                    , renderDocument id 
                    ]
                ]

        Emails ->
            div []
                [ View.Desktop.renderWrapperWithNav [
                    renderHeading "Emails"
                    , renderEmailList 
                    ]
                ]

        Email id ->
            div []
                [ View.Desktop.renderWrapperWithNav [ 
                    renderHeading "Single Email"
                    , renderEmail id 
                    ]
                ]

        Messages ->
            div []
                [ View.Desktop.renderWrapperWithNav [ 
                    renderHeading "Messages"
                    ] 
                ]

        Tweets ->
            div []
                [ View.Desktop.renderWrapperWithNav [ 
                    renderHeading "Tweets"
                    ] 
                ]


renderHeading : String -> Html Msg
renderHeading title =
    h1 [] [ text title ]


renderDocumentList : Html Msg
renderDocumentList =
    ul []
        [ li [] [ a [ href "/documents/1" ] [ text "Document number 1" ] ]
        , li [] [ a [ href "/documents/2" ] [ text "Document number 2" ] ]
        ]


renderDocument : Int -> Html Msg
renderDocument id =
    div [] [ text ("Document with id: " ++ String.fromInt id) ]


renderEmailList : Html Msg
renderEmailList =
    ul []
        [ li [] [ a [ href "/emails/1" ] [ text "Email number 1" ] ]
        , li [] [ a [ href "/emails/2" ] [ text "Email number 2" ] ]
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
    ()


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
