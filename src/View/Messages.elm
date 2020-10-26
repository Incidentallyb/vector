module View.Messages exposing (view)

import Content
import ContentChoices
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import GameData exposing (CheckboxData, GameData, displayScoreNow, filterMessages)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Set exposing (Set)
import View.ChoiceButtons


view : GameData -> Content.Datastore -> Html Msg
view gamedata messagesDict =
    ul [ class "message-list p-0" ]
        (Dict.values
            (filterMessages messagesDict.messages gamedata.choices)
            |> List.map (renderMessageAndPrompt gamedata gamedata.choices gamedata.checkboxSet gamedata.teamName)
        )


renderMessageAndPrompt : GameData -> List String -> CheckboxData -> String -> Content.MessageData -> Html Msg
renderMessageAndPrompt gamedata choices checkboxes team message =
    let
        dummy =
            Debug.log "Triggered by:" message.triggered_by

        triggerList =
            Maybe.withDefault "" (List.head message.triggered_by)
    in
    li []
        [ div [ class "typing-indicator" ] [ span [] [ text "" ], span [] [ text "" ], span [] [ text "" ] ]
        , if isScoreTime triggerList then
            renderScore "AL" gamedata triggerList team

          else
            text ""
        , renderMessage message.author message.content
        , renderPrompt message choices checkboxes team
        ]


renderScore : String -> GameData -> String -> String -> Html Msg
renderScore from currentGameData triggers team =
    let
        triggerDepth =
            String.fromInt (List.length (filterChoiceString triggers))
    in
    div
        [ class ("message al w-75 float-left mt-3 ml-3 py-2 triggers-" ++ triggerDepth) ]
        [ div [ class "mx-3" ]
            [ p [ class "message-from m-0" ] [ text from ]
            , p [] [ text (t WellDone ++ team) ]
            , p [] [ text (t Results) ]
            , p [] [ text ("Success: " ++ String.fromInt currentGameData.scoreSuccess ++ "%") ]
            , p [] [ text ("Economic: £" ++ String.fromInt currentGameData.scoreEconomic ++ ",000,000 remaining") ]
            , p [] [ text ("Harm: " ++ String.fromInt currentGameData.scoreHarm) ]
            ]
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
                , let
                    playerMessage =
                        case message.playerMessage of
                            Nothing ->
                                text ""

                            Just playerMessageText ->
                                Markdown.toHtml [ class "playerMessageText" ] playerMessageText
                  in
                  playerMessage
                , -- Lovely hack for multi choice messages (only choose-1-2-3 for now)
                  if message.basename == "choose-1-2-3" then
                    View.ChoiceButtons.renderCheckboxes
                        (List.map View.ChoiceButtons.choiceStringsToButtons message.choices)
                        checkboxes

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


isScoreTime : String -> Bool
isScoreTime triggers =
    let
        debugFilteredList =
            Debug.log "Filtered list: " filterChoiceString triggers
    in
    if List.length (filterChoiceString triggers) == 2 || List.length (filterChoiceString triggers) == 4 || List.length (filterChoiceString triggers) == 5 then
        True

    else
        False


filterChoiceString : String -> List String
filterChoiceString input =
    let
        genericWords =
            [ "init", "start", "step", "change" ]
    in
    List.filter (\item -> not (List.member item genericWords)) (String.split "|" input)
