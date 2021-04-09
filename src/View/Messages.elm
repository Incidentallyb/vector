module View.Messages exposing (view)

import Content
import ContentChoices exposing (triggeredByChoicesGetMatches)
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict
import GameData exposing (CheckboxData, GameData, ScoreType(..), filterMessages)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaLive)
import List.Extra
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Set
import View.ChoiceButtons


view : GameData -> Content.Datastore -> Html Msg
view gamedata datastore =
    ul [ class "message-list p-0", ariaLive "polite" ]
        (Dict.values
            (filterMessages datastore.messages gamedata.choices)
            |> List.map (renderMessageAndPrompt gamedata datastore)
        )


triggerIsScore : List String -> String -> Bool
triggerIsScore choiceList messageName =
    let
        scoresTriggered =
            List.length (List.filter (\choice -> choice == "score") choiceList)
    in
    case scoresTriggered of
        1 ->
            messageName == "z-score-1"

        2 ->
            messageName == "z-score-1" || messageName == "z-score-2"

        3 ->
            messageName
                == "z-score-1"
                || messageName
                == "z-score-2"
                || messageName
                == "z-score-3"

        _ ->
            False


lastTriggerIsThisScore : List String -> String -> Bool
lastTriggerIsThisScore choiceList messageName =
    let
        scoresTriggered =
            List.length (List.filter (\choice -> choice == "score") choiceList)
    in
    case scoresTriggered of
        1 ->
            messageName == "z-score-1"

        2 ->
            messageName == "z-score-2"

        3 ->
            messageName == "z-score-3"

        _ ->
            False


renderMessageAndPrompt : GameData -> Content.Datastore -> Content.MessageData -> Html Msg
renderMessageAndPrompt gamedata datastore message =
    let
        actualTriggers =
            String.split "|" (Maybe.withDefault "" (List.head (triggeredByChoicesGetMatches gamedata.choices message.triggered_by)))

        triggeredBy =
            String.join "|" actualTriggers

        haveWeSeenThisBefore =
            Set.member triggeredBy gamedata.choicesVisited
                || triggeredByScore

        triggeredByScore =
            lastTriggerIsThisScore gamedata.choices message.basename

        readyForScore =
            triggerIsScore gamedata.choices message.basename
    in
    -- add already-seen so we can avoid showing typing animations on subsequent page loads of the same page.
    li
        [ classList
            [ ( "already-seen", haveWeSeenThisBefore )
            , ( "not-seen", not haveWeSeenThisBefore )
            , ( "latest-score", triggeredByScore )
            ]
        , ariaLive "polite"
        ]
        [ if not haveWeSeenThisBefore then
            div [ class "typing-indicator" ] [ span [] [ text "" ], span [] [ text "" ], span [] [ text "" ] ]

          else
            text ""
        , renderMessage message.author message.content
        , renderPrompt message gamedata.choices gamedata.checkboxSet gamedata.teamName
        , if readyForScore then
            renderScore "AL" triggeredByScore actualTriggers gamedata.teamName datastore gamedata.socialsPosted

          else
            text ""
        ]


renderScore : String -> Bool -> List String -> String -> Content.Datastore -> Dict.Dict String Content.SocialData -> Html Msg
renderScore from isLatestScore triggers team datastore socialPosts =
    let
        previousChoices =
            List.reverse (Maybe.withDefault [] (List.Extra.init triggers))

        latestChoice =
            Maybe.withDefault "" (List.Extra.last triggers)
    in
    div
        [ classList
            [ ( "score message al w-75 float-left mt-3 ml-3 py-2", True )
            , ( "latest-score", isLatestScore )
            ]
        ]
        [ div [ class "mx-3" ]
            (if isLatestScore then
                List.repeat 10 (div [ class "confetti" ] [])
                    ++ [ p [ class "message-from m-0" ] [ text from ]
                       , p [] [ text (t WellDone ++ team) ]
                       , p [] [ text (t Results) ]
                       , div [ class "results" ]
                            [ div [ class "success" ] [ h3 [] [ text "Success" ], text (String.fromInt (GameData.updateScore Success datastore socialPosts previousChoices latestChoice) ++ "%") ]
                            , div [ class "economic" ] [ h3 [] [ text "Economic" ], text (String.fromInt (GameData.updateScore Economic datastore socialPosts previousChoices latestChoice) ++ "m remaining") ]
                            , div [ class "harm" ] [ h3 [] [ text "Harm" ], text (String.fromInt (GameData.updateScore Harm datastore socialPosts previousChoices latestChoice)) ]
                            ]
                       ]

             else
                [ p [ class "message-from m-0" ] [ text from ]
                , p [] [ text (t WellDone ++ team) ]
                , p [] [ text (t Results) ]
                , div [ class "results" ]
                    [ div [ class "success" ] [ h3 [] [ text "Success" ], text (String.fromInt (GameData.updateScore Success datastore socialPosts previousChoices latestChoice) ++ "%") ]
                    , div [ class "economic" ] [ h3 [] [ text "Economic" ], text (String.fromInt (GameData.updateScore Economic datastore socialPosts previousChoices latestChoice) ++ "m remaining") ]
                    , div [ class "harm" ] [ h3 [] [ text "Harm" ], text (String.fromInt (GameData.updateScore Harm datastore socialPosts previousChoices latestChoice)) ]
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


open : String -> Attribute msg
open value =
    attribute "open" value


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
                  div []
                    [ -- If there is more than one option to choose, it's an important decision
                      if List.length message.choices > 1 && message.basename /= "end" then
                        -- Lovely hack for checkbox messages (only choose-1-2-3 for now)
                        if message.basename == "choose-1-2-3" then
                            div []
                                [ View.ChoiceButtons.renderCheckboxes
                                    (List.map View.ChoiceButtons.choiceStringsToButtons message.choices)
                                    checkboxes
                                ]

                        else
                            details
                                [ if ContentChoices.getChoiceChosen choices message /= "" then
                                    open ""

                                  else
                                    Html.Attributes.class ""
                                ]
                                [ summary
                                    []
                                    [ span [] [ text (t ReadyToReply) ]
                                    ]
                                , div []
                                    [ playerMessage
                                    , div []
                                        (View.ChoiceButtons.renderButtons
                                            (List.map View.ChoiceButtons.choiceStringsToButtons message.choices)
                                            (ContentChoices.getChoiceChosen choices message)
                                        )
                                    ]
                                ]

                      else
                        -- Otherwise, a single option confirmation
                        div []
                            [ playerMessage
                            , div []
                                (View.ChoiceButtons.renderButtons
                                    (List.map View.ChoiceButtons.choiceStringsToButtons message.choices)
                                    (ContentChoices.getChoiceChosen choices message)
                                )
                            ]
                    ]
                ]
            ]

    else
        text ""
