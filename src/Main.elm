module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (href)
import Task
import Url
import Url.Parser as Parser exposing (Parser, map, oneOf, s, top)



-- MODEL


type alias Model =
    { key : Browser.Navigation.Key
    , page : Route
    }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        maybeRoute =
            routeFromUrl url
    in
    -- If not a valid route, default to Desktop
    ( { key = key, page = Maybe.withDefault Desktop maybeRoute }, Cmd.none )



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | NoOp


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
                    Maybe.withDefault Desktop (routeFromUrl url)
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
            div []
                [ renderHeading "Desktop"
                , renderNavLinks
                ]

        Document ->
            div []
                [ renderHeading "Documents"
                , renderNavLinks
                ]

        Email ->
            div []
                [ renderHeading "Emails"
                , renderNavLinks
                ]

        Message ->
            div []
                [ renderHeading "Messages"
                , renderNavLinks
                ]

        Tweet ->
            div []
                [ renderHeading "Tweets"
                , renderNavLinks
                ]


renderHeading : String -> Html Msg
renderHeading title =
    h1 [] [ text title ]


renderNavLinks : Html Msg
renderNavLinks =
    ul []
        [ li [] [ a [ href "document" ] [ text "documents" ] ]
        , li [] [ a [ href "email" ] [ text "emails" ] ]
        , li [] [ a [ href "message" ] [ text "messages" ] ]
        , li [] [ a [ href "tweet" ] [ text "tweets" ] ]
        ]



--ROUTING


type Route
    = Desktop
    | Document
    | Email
    | Message
    | Tweet


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Parser.map Desktop Parser.top
        , Parser.map Document (Parser.s "document")
        , Parser.map Email (Parser.s "email")
        , Parser.map Message (Parser.s "message")
        , Parser.map Tweet (Parser.s "tweet")
        ]


routeFromUrl : Url.Url -> Maybe Route
routeFromUrl url =
    { url | path = url.path }
        |> Parser.parse routeParser


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
