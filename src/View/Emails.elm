module View.Emails exposing (list, single)

import Content
import ContentChoices
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import GameData exposing (GameData, filterEmails)
import Heroicons.Outline exposing (arrowLeft)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden)
import Html.Events exposing (onClick)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Set
import String
import View.ChoiceButtons


type alias EmailWithRead =
    { triggered_by : List String
    , author : String
    , subject : String
    , preview : String
    , content : String
    , image : Maybe Content.ImageData
    , basename : String
    , read : Bool
    }


single : GameData -> Maybe Content.EmailData -> Html Msg
single gamedata maybeContent =
    case maybeContent of
        Nothing ->
            text (t ItemNotFound)

        Just email ->
            let
                choiceList =
                    case email.choices of
                        Nothing ->
                            []

                        Just choices ->
                            choices
            in
            article [ class "email p-3" ]
                [ p [ class "date" ] [ text (t EmailDummySentTime) ]
                , h2 [] [ text email.subject ]
                , div [ class "d-flex align-items-center" ]
                    [ div [ class ("email-icon " ++ generateCssString email.author), ariaHidden True ]
                        [ text (String.left 1 email.author)
                        ]
                    , div [ class "ml-3" ] [ text email.author ]
                    ]
                , div [ class "mt-3" ] [ Markdown.toHtml [ class "content" ] email.content ]
                , renderImage email
                , if List.length choiceList > 0 then
                    div [ class "button-choices" ]
                        (div [ class "quick-reply" ] [ text (t EmailQuickReply) ]
                            :: View.ChoiceButtons.renderButtons
                                (List.map View.ChoiceButtons.choiceStringsToButtons choiceList)
                                (ContentChoices.getChoiceChosenEmail gamedata.choices email)
                        )

                  else
                    text ""
                , a [ href (Route.toString Emails), class "btn btn-primary" ]
                    [ arrowLeft []
                    , text (t NavEmailsBackTo)
                    ]
                ]


list : GameData -> Dict String Content.EmailData -> Set.Set String -> Html Msg
list gamedata emailDict visitedSet =
    ul [ class "email-list" ]
        (List.map listItem (List.reverse (addReadStatus (Dict.values (filterEmails emailDict gamedata.choices)) visitedSet)))


addReadStatus : List Content.EmailData -> Set.Set String -> List EmailWithRead
addReadStatus emailData visitedSet =
    List.map
        (\email ->
            let
                readStatus =
                    Set.member ("/emails/" ++ email.basename) visitedSet
            in
            { triggered_by = email.triggered_by
            , author = email.author
            , subject = email.subject
            , preview = email.preview
            , content = email.content
            , image = email.image
            , basename = email.basename
            , read = readStatus
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

renderImage : Content.EmailData -> Html Msg
renderImage email =
  case email.image of
    Nothing ->
      text ""
    Just image ->
      img [src (image.src), alt (image.alt) ][]


generateCssString : String.String -> String.String
generateCssString name =
    String.toLower (String.concat (String.words name))
