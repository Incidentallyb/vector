module View.Messages exposing (view)

import Content
import ContentChoices
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import GameData exposing (GameData, filterMessages)
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


view : GameData -> Dict String Content.MessageData -> Html Msg
view gamedata messagesDict =
    ul [ class "message-list p-0" ]
        (List.reverse
            (Dict.values (filterMessages messagesDict gamedata.choices))
            |> List.map (renderMessageAndPrompt gamedata.choices)
        )


renderMessageAndPrompt : List String -> Content.MessageData -> Html Msg
renderMessageAndPrompt choices message =
    li []
        [ div [ class "typing-indicator" ] [ span [] [ text "" ], span [] [ text "" ], span [] [ text "" ] ]
        , renderMessage message.author message.content
        , renderPrompt message choices
        ]


renderMessage : String -> String -> Html Msg
renderMessage from message =
    div
        [ class "message al w-75 float-left mt-3 ml-3 py-2" ]
        [ div [ class "mx-3" ]
            [ p [ class "message-from m-0" ]
                [ text from ]
            , p
                [ class "card-text m-0" ]
                [ Markdown.toHtml [ class "content" ] message ]
            ]
        ]


renderPrompt : Content.MessageData -> List String -> Html Msg
renderPrompt message choices =
    if List.length message.choices > 0 then
        div
            [ class "message player w-75 float-right mt-3 mr-3 py-2" ]
            [ div [ class "mx-3" ]
                [ p [ class "message-from m-0" ]
                    [ text (t FromPlayerTeam) ]

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
