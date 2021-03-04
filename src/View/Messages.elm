module View.Messages exposing (view)

import Content
import ContentChoices exposing (triggeredByChoicesGetMatches)
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict
import GameData exposing (CheckboxData, GameData, ScoreType(..), filterMessages)
import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Set
import View.ChoiceButtons


view : GameData -> Content.Datastore -> Html Msg
view gamedata datastore =
    ul [ class "message-list p-0" ]
        (Dict.values
            (filterMessages datastore.messages gamedata.choices)
            |> List.map (renderMessageAndPrompt gamedata datastore)
        )


renderMessageAndPrompt : GameData -> Content.Datastore -> Content.MessageData -> Html Msg
renderMessageAndPrompt gamedata datastore message =
    let
        actualTriggers =
            String.split "|" (Maybe.withDefault "" (List.head (triggeredByChoicesGetMatches gamedata.choices message.triggered_by)))

        triggeredBy =
            String.join "|" actualTriggers

        haveWeSeenThisBefore =
            Set.member triggeredBy gamedata.choicesVisited

        triggerDepth =
            String.fromInt (List.length (filterChoiceString actualTriggers))
    in
    -- Add the trigger depth so we can hide scores if they come up more than once.
    -- add already-seen so we can avoid showing typing animations on subsequent page loads of the same page.
    li
        [ classList
            [ ( "triggers-" ++ triggerDepth, isScoreTime actualTriggers )
            , ( "already-seen", haveWeSeenThisBefore )
            , ( "not-seen", not haveWeSeenThisBefore )
            ]
        ]
        [ if not haveWeSeenThisBefore then
            div [ class "typing-indicator" ] [ span [] [ text "" ], span [] [ text "" ], span [] [ text "" ] ]

          else
            text ""
        , if isScoreTime actualTriggers then
            renderScore "AL" actualTriggers gamedata.teamName datastore

          else
            text ""
        , renderMessage message.author message.content
        , renderPrompt message gamedata.choices gamedata.checkboxSet gamedata.teamName
        ]


renderScore : String -> List String -> String -> Content.Datastore -> Html Msg
renderScore from triggers team datastore =
    let
        previousChoices =
            List.reverse (Maybe.withDefault [] (List.Extra.init triggers))

        latestChoice =
            Maybe.withDefault "" (List.Extra.last triggers)
    in
    div
        [ class "score message al w-75 float-left mt-3 ml-3 py-2" ]
        [ div [ class "mx-3" ]
            (List.repeat 10 (div [ class "confetti" ] [])
                ++ [ p [ class "message-from m-0" ] [ text from ]
                   , p [] [ text (t WellDone ++ team) ]
                   , p [] [ text (t Results) ]
                   , div [ class "results" ]
                        [ div [ class "success" ] [ h3 [] [ text "Success" ], text (String.fromInt (GameData.updateScore Success datastore previousChoices latestChoice) ++ "%") ]
                        , div [ class "economic" ] [ h3 [] [ text "Economic" ], text (String.fromInt (GameData.updateScore Economic datastore previousChoices latestChoice) ++ "m remaining") ]
                        , div [ class "harm" ] [ h3 [] [ text "Harm" ], text (String.fromInt (GameData.updateScore Harm datastore previousChoices latestChoice)) ]
                        ]
                   ]
            )
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


{-| Determines if the a score should be displayed in the messages
based on the length of the player's choice string.
-}
isScoreTime : List String -> Bool
isScoreTime triggers =
    if List.length (filterChoiceString triggers) == 2 || List.length (filterChoiceString triggers) == 4 || List.length (filterChoiceString triggers) == 5 then
        True

    else
        False


{-| Helper function to filter a string of choices for any
words that don't contributes to a unique path.
-}
filterChoiceString : List String -> List String
filterChoiceString input =
    let
        genericWords =
            [ "init", "start", "step", "change" ]
    in
    List.filter (\item -> not (List.member item genericWords)) input
