module View.Intro exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode exposing (..)
import Message exposing (Msg(..))


view : Html Msg
view =
    div [ class "mt-3" ]
        [ h1 [] [ text "Vector" ]
        , iframe
            [ width 560
            , height 315
            , src "https://www.youtube.com/embed/mRRMSFHPWJU"
            , attribute "frameborder" "0"
            , attribute "allowfullscreen" "true"
            , attribute "gyroscope" "true"
            ]
            []
        ]
