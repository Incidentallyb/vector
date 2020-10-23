module View.Documents exposing (list, single)

import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import GameData exposing (GameData, filterDocuments)
import Heroicons.Outline exposing (arrowLeft)
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Set

type alias DocumentWithRead =
    { triggered_by : List String
    , image : String
    , preview : String
    , content : String
    , basename : String
    , read : Bool
    }


imagePath : String
imagePath =
    "/images/documents/"


single : Maybe Content.DocumentData -> Html Msg
single maybeContent =
    case maybeContent of
        Nothing ->
            text (t ItemNotFound)

        Just document ->
            div [ class "document" ]
                [ img [ src (imagePath ++ document.image), class "img-fluid p-md-1" ] []
                , p [] [ Markdown.toHtml [ class "content" ] document.content ]
                , a [ href (Route.toString Documents), class "btn btn-primary" ]
                    [ arrowLeft []
                    , text (t NavDocumentsBackTo)
                    ]
                ]


list :  GameData -> Dict String Content.DocumentData -> Set.Set String -> Html Msg
list gamedata documentDict visitedSet =
    div [ class "card-columns" ]
        (List.map listItem (addReadStatus (Dict.values (filterDocuments documentDict gamedata.choices)) visitedSet))


addReadStatus : List Content.DocumentData -> Set.Set String -> List DocumentWithRead
addReadStatus documentData visitedSet =
    List.map
        (\document ->
            let
                readStatus =
                    Set.member ("/documents/" ++ document.basename) visitedSet
            in
            { triggered_by = document.triggered_by
            , image = document.image
            , preview = document.preview
            , content = document.content
            , basename = document.basename
            , read = readStatus
            }
        )
        documentData

listItem : DocumentWithRead -> Html Msg
listItem content =
    div [ class "card" ]
        [ div [ class "card-body" ]
            [ div [ class "card-title" ]
                [ h1 [] [ text content.basename ]
                , img [ src (imagePath ++ content.image), class "img-fluid p-md-1" ] []
                ]
            , div [ class "card-text" ]
                [ a [ class "btn btn-primary", href (Route.toString (Document content.basename)) ] [ text (t ViewDocument) ]
                ]
            ]
        ]
