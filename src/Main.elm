module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Navigation
import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (href)
import Task
import Url
import Url.Parser as Parser exposing ((</>), Parser, int, map, oneOf, s, top)



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

        Documents ->
            div []
                [ renderHeading "Documents"
                , renderNavLinks
                , renderDocumentList
                ]

        Document id ->
            div []
                [ renderHeading "Single Document"
                , renderNavLinks
                , renderDocument id
                ]

        Emails ->
            div []
                [ renderHeading "Emails"
                , renderNavLinks
                , renderEmailList
                ]

        Email id ->
            div []
                [ renderHeading "Single Email"
                , renderNavLinks
                , renderEmail id
                ]

        Messages ->
            div []
                [ renderHeading "Messages"
                , renderNavLinks
                ]

        Tweets ->
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
        [ li [] [ a [ href "/documents" ] [ text "documents" ] ]
        , li [] [ a [ href "/emails" ] [ text "emails" ] ]
        , li [] [ a [ href "/messages" ] [ text "messages" ] ]
        , li [] [ a [ href "/tweets" ] [ text "tweets" ] ]
        ]


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



--ROUTING


type Route
    = Desktop
    | Documents
    | Document Int
    | Emails
    | Email Int
    | Messages
    | Tweets


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Desktop top
        , map Documents (s "documents")
        , map Document (s "documents" </> int)
        , map Emails (s "emails")
        , map Email (s "emails" </> int)
        , map Messages (s "messages")
        , map Tweets (s "tweets")
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
