module View.Document exposing (list, single)

import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))


single : Int -> Html Msg
single documentId =
    div []
        [ text ("Document body" ++ String.fromInt documentId)
        ]


list : Html Msg
list =
    ul []
        [ li [] [ a [ href (Route.toString (Document 1)) ] [ text "Document number 1" ] ]
        , li [] [ a [ href (Route.toString (Document 2)) ] [ text "Document number 2" ] ]
        ]
