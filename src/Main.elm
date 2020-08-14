module Main exposing (main)

import Browser
import Html exposing (Html)


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = viewDocument
        }


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}
    , Cmd.none
    )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( {}
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Vector App", body = [ view model ] }


view : Model -> Html Msg
view model =
    Html.div [] [ Html.text "Hej" ]
