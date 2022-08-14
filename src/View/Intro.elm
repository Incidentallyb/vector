module View.Intro exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))
import View.Video


view : Html Msg
view =
    div [ class "intro container-fluid" ]
        [ div [ class "row my-4" ]
            [ h1 [ class "d-block mx-auto px-4 text-center" ] [ text (t SiteTitle) ]
            ]
        , div [ class "intro-video" ] [ View.Video.view (t IntroVideo1) ]
        , div [ class "row my-4" ]
            [ a [ class "btn btn-primary btn-lg mx-auto", href (Route.toString Route.Desktop) ] [ text (t StartNewGame) ]
            ]
        ]
