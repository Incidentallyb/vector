module View.Video exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Video exposing (embedUrlFromIdString)


view : { id : String, title : String } -> Html msg
view { id, title } =
    div [ class "video-container" ]
        [ iframe
            [ class "d-block mx-auto video"
            , src (embedUrlFromIdString id)
            , attribute "frameborder" "0"
            , attribute "allowfullscreen" "true"
            , attribute "gyroscope" "true"
            , attribute "allow" "autoplay"
            , attribute "title" title
            ]
            []
        ]
