module View.Messages exposing (view)

import Content
import ContentChoices
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import GameData exposing (CheckboxData, GameData, filterMessages)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Set exposing (Set)
import View.ChoiceButtons


view : GameData -> Dict String Content.MessageData -> Html Msg
view gamedata messagesDict =
    ul [ class "message-list p-0" ]
        (Dict.values
            (filterMessages messagesDict gamedata.choices)
            |> List.map (renderMessageAndPrompt gamedata.choices gamedata.checkboxSet gamedata.teamName)
        )


renderMessageAndPrompt : List String -> CheckboxData -> String -> Content.MessageData -> Html Msg
renderMessageAndPrompt choices checkboxes team message =
    li []
        [ div [ class "typing-indicator" ] [ span [] [ text "" ], span [] [ text "" ], span [] [ text "" ] ]
        , renderMessage message.author message.content
        , renderPrompt message choices checkboxes team
        ]


renderMessage : String -> String -> Html Msg
renderMessage from message =
    div
        [ class "message al w-75 float-left mt-3 ml-3 py-2" ]
        [ div [ class "mx-3" ]
            [ p [ class "message-from m-0" ]
                [ text from ]
            , Markdown.toHtml [ class "card-text" ] message
            ]
        ]


renderPrompt : Content.MessageData -> List String -> CheckboxData -> String -> Html Msg
renderPrompt message choices checkboxes team =
    if List.length message.choices > 0 then
        div
            [ class "message player w-75 float-right mt-3 mr-3 py-2" ]
            [ div [ class "mx-3" ]
                [ p [ class "message-from m-0" ]
                    [ text (t FromPlayerTeam ++ team) ]

                -- we might have some player text in the future?
                , let
                    playerMessage =
                        case message.playerMessage of
                            Nothing ->
                                div [] []

                            Just playerMessageText ->
                                Markdown.toHtml [ class "playerMessageText" ] playerMessageText
                  in
                  playerMessage
                , -- Lovely hack for multi choice messages (only choose-1-2-3 for now)
                  if message.basename == "choose-1-2-3" then
                    View.ChoiceButtons.renderCheckboxes
                        (List.map View.ChoiceButtons.choiceStringsToButtons message.choices)
                        checkboxes
                        (ContentChoices.getChoiceChosen choices message)

                  else
                    div []
                        (View.ChoiceButtons.renderButtons
                            (List.map View.ChoiceButtons.choiceStringsToButtons message.choices)
                            (ContentChoices.getChoiceChosen choices message)
                        )
                ]
            ]

    else
        text ""
