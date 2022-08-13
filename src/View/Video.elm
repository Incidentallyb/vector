module View.Video exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> Html msg
view videoSrc =
    iframe
        [ class "d-block mx-auto"
        , width 560
        , height 315
        , src videoSrc
        , attribute "frameborder" "0"
        , attribute "allowfullscreen" "true"
        , attribute "gyroscope" "true"
        ]
        []
