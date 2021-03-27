module View.Documents exposing (list, single)

import Content exposing (ImageData)
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
    , title : String
    , subtitle : Maybe String
    , image : Maybe ImageData
    , numberUsed : Maybe String
    , cost : Maybe String
    , success : Maybe String
    , harm : Maybe String
    , pros : Maybe (List String)
    , cons : Maybe (List String)
    , preview : String
    , content : String
    , basename : String
    , read : Bool
    }


renderImage : Content.DocumentData -> Html Msg
renderImage document =
    case document.image of
        Nothing ->
            text ""

        Just image ->
            img [ src (t UploadPath ++ image.src), alt image.alt, class "col-md-6" ] []


renderSubtitle : Maybe String -> Html Msg
renderSubtitle maybeSubtitle =
    case maybeSubtitle of
        Just subtitle ->
            h2 [] [ text subtitle ]

        Nothing ->
            text ""


renderInfo : String -> String -> Maybe String -> String -> Html Msg
renderInfo label symbol data extra =
    case data of
        Nothing ->
            text ""

        Just value ->
            li [ class "info-list-item" ]
                [ div [ class "info-label" ] [ text label ]
                , div [ class "symbol" ] [ text symbol ]
                , div [ class "value" ] [ text (value ++ extra) ]
                ]


renderListItem : String -> Html Msg
renderListItem login =
    li [] [ text login ]


renderList : String -> Maybe (List String) -> Html Msg
renderList listTitle listContent =
    case listContent of
        Nothing ->
            text ""

        Just content ->
            section [ class "col-md-6" ]
                [ h2 [] [ text listTitle ]
                , ul []
                    (List.map renderListItem content)
                ]


single : Maybe Content.DocumentData -> Html Msg
single maybeContent =
    case maybeContent of
        Nothing ->
            text (t ItemNotFound)

        Just document ->
            div [ class "document card" ]
                [ div [ class "card-body" ]
                    [ h1 []
                        [ text document.title ]
                    , renderSubtitle document.subtitle
                    , div
                        [ class "row" ]
                        [ renderImage document
                        , ul [ class "col-md-6" ]
                            [ renderInfo "Cost" "£" document.cost "M"
                            , renderInfo "Success" "%" document.success ""
                            , renderInfo "Harm" "!" document.harm ""
                            ]
                        , renderList "Pros" document.pros
                        , renderList "Cons" document.cons
                        ]
                    ]
                , div [ class "card-footer" ]
                    [ p [] [ Markdown.toHtml [ class "content" ] document.content ]
                    , a [ href (Route.toString Documents), class "btn btn-primary" ]
                        [ arrowLeft []
                        , text (t NavDocumentsBackTo)
                        ]
                    ]
                ]


list : GameData -> Dict String Content.DocumentData -> Set.Set String -> Html Msg
list gamedata documentDict visitedSet =
    div [ class "row documents" ]
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
            , title = document.title
            , subtitle = document.subtitle
            , image = document.image
            , numberUsed = document.numberUsed
            , cost = document.cost
            , success = document.success
            , harm = document.harm
            , pros = document.pros
            , cons = document.cons
            , preview = document.preview
            , content = document.content
            , basename = document.basename
            , read = readStatus
            }
        )
        documentData


renderCardImage : DocumentWithRead -> Html Msg
renderCardImage document =
    case document.image of
        Nothing ->
            text ""

        Just image ->
            img [ src (t UploadPath ++ image.src), alt image.alt, class "card-icon card-img-top" ] []


listItem : DocumentWithRead -> Html Msg
listItem content =
    div [ class "col-6 col-lg-4" ]
        [ a [ class "card", href (Route.toString (Document content.basename)) ]
            [ div [ classList [ ( "read", content.read ) ] ]
                [ span [ class "badge new" ] [ text (t New) ]
                , renderCardImage content
                , h2 [ class "card-title" ] [ text content.title ]
                ]
            ]
        ]
