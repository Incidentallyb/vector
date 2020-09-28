module View.Emails exposing (list, single)

import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import GameData exposing (GameData, filterEmails)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import String


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
                    [ div [ class ("email-icon " ++ email.author), ariaHidden True ]
                        [ text (String.left 1 email.author)
                        ]
                    , div [ class "ml-3" ] [ text email.author ]
                    ]
                , div [ class "mt-3" ] [ Markdown.toHtml [ class "content" ] email.content ]
                ]


list : GameData -> Dict String Content.EmailData -> Html Msg
list gamedata emailDict =
    ul [ class "email-list" ]
        (List.map listItem (Dict.values (filterEmails emailDict gamedata.choices)))


listItem : Content.EmailData -> Html msg
listItem email =
    li
        [ class "email-list-item" ]
        [ a [ class "text-body", href (Route.toString (Email email.basename)) ]
            [ div [ class ("email-icon " ++ email.author), ariaHidden True ]
                [ text (String.left 1 email.author)
                ]
            , div [ class "email-info ml-3" ]
                [ p [ class "m-0 author" ] [ text email.author ]
                , p [ class "m-0" ] [ text email.preview ]
                ]
            ]
        ]
