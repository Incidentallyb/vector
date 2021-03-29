module View.EndInfo exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))


view : Html Msg
view =
    div [ class "intro container-fluid" ]
        [ div [ class "row my-4" ]
            [ h1 [ class "d-block mx-auto" ]
                [ text (t EndInfoHeader)
                ]
            ]
        , div [ class "row my-4" ]
            [ p [] [ Markdown.toHtml [] (t EndInfoParagraph1) ]
            , p [] [ text (t EndInfoParagraph2) ]
            , p [] [ Markdown.toHtml [] (t EndInfoParagraph3) ]
            , p [] [ text (t EndInfoParagraph4) ]
            ]
        ]
