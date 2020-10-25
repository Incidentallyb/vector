module View.Messages exposing (view)

import Content
import ContentChoices
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import GameData exposing (GameData, displayScoreNow, filterMessages)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))


type alias ButtonInfo =
    { label : String
    , action : String
    }


choiceStringsToButtons : String -> ButtonInfo
choiceStringsToButtons buttonString =
    let
        ( parsedString, action ) =
            ( case List.head (String.indexes "|" buttonString) of
                Nothing ->
                    buttonString

                Just val ->
                    String.dropLeft (val + 1) buttonString
            , case List.head (String.indexes "|" buttonString) of
                Nothing ->
                    buttonString

                Just val ->
                    String.left val buttonString
            )
    in
    { label = parsedString, action = action }


view : GameData -> Content.Datastore -> Html Msg
view gamedata messagesDict =
    ul [ class "message-list p-0" ]
        (Dict.values
            (filterMessages messagesDict.messages gamedata.choices)
            |> List.map (renderMessageAndPrompt gamedata messagesDict gamedata.teamName)
        )


renderMessageAndPrompt : GameData -> Content.Datastore -> String -> Content.MessageData -> Html Msg
renderMessageAndPrompt gamedata content team message =
    li []
        [ div [ class "typing-indicator" ] [ span [] [ text "" ], span [] [ text "" ], span [] [ text "" ] ]
        , renderMessage message.author message.content
        , renderPrompt message gamedata.choices team
        , if List.length message.triggered_by == 2 || List.length message.triggered_by == 5 then
            renderScore "AL" gamedata content message

          else
            text ""
        ]



-- getChoicePath : List String -> List String -> List String
-- getChoicePath gameChoices triggers =
--     List.head Maybe.withDefault "" (List.partition (\x -> x == "hi") [ "hi", "something  " ])


renderScore : String -> GameData -> Content.Datastore -> Content.MessageData -> Html Msg
renderScore from currentGameData content message =
    div
        [ class "message al w-75 float-left mt-3 ml-3 py-2" ]
        [ div [ class "mx-3" ]
            [ p [ class "message-from m-0" ]
                [ text from ]

            -- use the message to partition all the choices and display score up to there
            , div [] [ text ("Something " ++ String.fromInt (Maybe.withDefault 0 (List.head (GameData.displayScoreNow content currentGameData)))) ]
            , p [] [ text "Your choices have produced the following results:" ]
            , p [] [ text ("Success: " ++ String.fromInt currentGameData.scoreSuccess ++ "%") ]
            , p [] [ text ("Economic: £" ++ String.fromInt currentGameData.scoreEconomic ++ " remaining") ]
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


renderPrompt : Content.MessageData -> List String -> String -> Html Msg
renderPrompt message choices team =
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
                , renderButtons (List.map choiceStringsToButtons message.choices) (ContentChoices.getChoiceChosen choices message)
                ]
            ]

    else
        text ""


renderButtons : List ButtonInfo -> String -> Html Msg
renderButtons buttonList chosenValue =
    div []
        (List.map
            (\buttonItem ->
                button
                    [ classList
                        [ ( "btn choice-button", True )
                        , ( "btn-primary", chosenValue == "" )
                        , ( "active", chosenValue == buttonItem.action )
                        , ( "disabled", chosenValue /= buttonItem.action && chosenValue /= "" )
                        ]
                    , if chosenValue == "" then
                        onClick (ChoiceButtonClicked buttonItem.action)

                      else
                        Html.Attributes.class ""
                    ]
                    [ text buttonItem.label ]
            )
            buttonList
        )
