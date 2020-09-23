module View.Document exposing (list, single)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Heroicons.Outline exposing (arrowLeft)
import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))


iconSize : Int
iconSize =
    24


single : Int -> Html Msg
single documentId =
    div [ class "document" ]
        [ h2 [] [ text "Single Document" ]
        , img [ src "/images/documents/BIOBANK BD.jpg", class "img-fluid p-md-1" ] []
        , p [] [ text ("Document body" ++ String.fromInt documentId) ]
        , a [ href (Route.toString Documents), class "btn btn-primary" ]
            [ arrowLeft []
            , text (t NavDocumentsBackTo)
            ]
        ]


list : Html Msg
list =
    ul []
        [ li [] [ a [ href (Route.toString (Document 1)) ] [ text "Document number 1" ] ]
        , li [] [ a [ href (Route.toString (Document 2)) ] [ text "Document number 2" ] ]
        ]
