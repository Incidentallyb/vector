module View.Intro exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))


view : Html Msg
view =
    div [ class "intro container-fluid" ]
        [ div [ class "row my-4" ]
            [ h1 [ class "d-block mx-auto" ] [ text (t SiteTitle) ]
            ]
        , div [ class "row my-4" ]
            [ iframe
                [ class "d-block mx-auto"
                , width 560
                , height 315
                , src (t IntroVideo)
                , attribute "frameborder" "0"
                , attribute "allowfullscreen" "true"
                , attribute "gyroscope" "true"
                ]
                []
            ]
        , div [ class "row my-4" ]
            [ a [ class "btn btn-primary btn-lg mx-auto", href (Route.toString Route.Desktop) ] [ text (t StartNewGame) ]
            ]
        ]
