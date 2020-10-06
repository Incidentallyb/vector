module View.Emails exposing (list, single)

import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Set
import String


type alias EmailWithRead =
    { triggered_by : List String
    , author : String
    , subject : String
    , preview : String
    , content : String
    , basename : String
    , read : Bool
    }


single : Maybe Content.EmailData -> Html Msg
single maybeContent =
    case maybeContent of
        Nothing ->
            text (t ItemNotFound)

        Just email ->
            article [ class "email p-3" ]
                [ p [ class "date" ] [ text (t EmailDummySentTime) ]
                , h2 [] [ text "EMAIL_SUBJECT_TODO" ]
                , div [ class "d-flex align-items-center" ]
                    [ div [ class ("email-icon " ++ generateCssString email.author), ariaHidden True ]
                        [ text (String.left 1 email.author)
                        ]
                    , div [ class "ml-3" ] [ text email.author ]
                    ]
                , div [ class "mt-3" ] [ Markdown.toHtml [ class "content" ] email.content ]
                ]


list : Dict String Content.EmailData -> Set.Set String -> Html Msg
list emailDict visitedSet =
    ul [ class "email-list" ]
        (List.map listItem (addReadStatus (Dict.values emailDict) visitedSet))


addReadStatus : List Content.EmailData -> Set.Set String -> List EmailWithRead
addReadStatus emailData visitedSet =
    List.map
        (\email ->
            if Set.member ("/emails/" ++ email.basename) visitedSet then
                { triggered_by = email.triggered_by
                , author = email.author
                , subject = email.subject
                , preview = email.preview
                , content = email.content
                , basename = email.basename
                , read = True
                }

            else
                { triggered_by = email.triggered_by
                , author = email.author
                , subject = email.subject
                , preview = email.preview
                , content = email.content
                , basename = email.basename
                , read = False
                }
        )
        emailData


listItem : EmailWithRead -> Html msg
listItem email =
    li
        [ class "email-list-item", classList [ ( "read", email.read ) ] ]
        [ a [ class "text-body", href (Route.toString (Email email.basename)) ]
            [ div [ class ("email-icon " ++ generateCssString email.author), ariaHidden True ]
                [ text (String.left 1 email.author)
                ]
            , div [ class "email-info ml-3" ]
                [ p [ class "m-0 author" ] [ text email.author ]
                , p [ class "m-0 subject" ] [ text email.subject ]
                , p [ class "m-0" ] [ text email.preview ]
                ]
            ]
        ]


generateCssString : String.String -> String.String
generateCssString name =
    String.toLower (String.concat (String.words name))
