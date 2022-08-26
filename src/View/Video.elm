module View.Video exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Video exposing (embedUrlFromIdString)


view : String -> Html msg
view videoId =
    div [ class "video-container" ]
        [ iframe
            [ class "d-block mx-auto video"
            , src (embedUrlFromIdString videoId)
            , attribute "frameborder" "0"
            , attribute "allowfullscreen" "true"
            , attribute "gyroscope" "true"
            ]
            []
        ]
