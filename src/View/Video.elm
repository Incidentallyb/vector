module View.Video exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> Html msg
view videoSrc =
    div [ class "video-container" ]
        [ iframe
            [ class "d-block mx-auto video"
            , src videoSrc
            , attribute "frameborder" "0"
            , attribute "allowfullscreen" "true"
            , attribute "gyroscope" "true"
            ]
            []
        ]
