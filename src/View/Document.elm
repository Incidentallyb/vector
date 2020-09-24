module View.Document exposing (list, single)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Heroicons.Outline exposing (arrowLeft)
import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Dict exposing (Dict)
import Content 
import Markdown


iconSize : Int
iconSize =
    24


single : Maybe Content.DocumentData -> Html Msg
single maybeContent =
    case maybeContent of 
        Nothing -> 
            text "document not found"
        Just document -> 
            div [ class "document" ]
                [ img [ src ("/images/documents/" ++ document.image), class "img-fluid p-md-1" ] []
                , p [] [ Markdown.toHtml [class "content"] document.content ]
                , a [ href (Route.toString Documents), class "btn btn-primary" ]
                    [ arrowLeft []
                    , text (t NavDocumentsBackTo)
                    ]
                ]

list : Dict String Content.DocumentData -> Html Msg
list documentDict =
    div [ class "card-columns" ] 
        (List.map listItem (Dict.values documentDict))
        


listItem : Content.DocumentData -> Html Msg
listItem content =
    div [ class "card" ]
        [ div [ class "card-body" ]
            [ div [ class "card-title" ] [ h1 [ ] [ text content.basename ]
                , img [ src ("/images/documents/" ++ content.image), class "img-fluid p-md-1" ] []
            ]
            , div [ class "card-text" ]
                [ a [ class "btn btn-primary", href (Route.toString (Document content.basename)) ] [ text "View Document" ]
                ]
            ]
        ]
