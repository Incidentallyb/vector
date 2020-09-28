module View.Messages exposing (view)

import Content
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
        (List.map renderMessageAndPrompt (List.reverse (Dict.values (filterMessages messagesDict gamedata.choices))))


renderMessageAndPrompt : Content.MessageData -> Html Msg
renderMessageAndPrompt message =
    li []
        [ renderMessage message.author message.content
        , renderPrompt message
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


renderPrompt : Content.MessageData -> Html Msg
renderPrompt message =
    if List.length message.choices > 0 then
        div
            [ class "message player w-75 float-right mt-3 mr-3 py-2" ]
            [ div [ class "mx-3" ]
                [ p [ class "message-from m-0" ]
                    [ text (t FromPlayerTeam) ]

                -- we might have some player text in the future?
                --, div [ class "card-text m-0" ]
                --    [ Markdown.toHtml [ class "content" ] message.content ]
                , renderButtons (List.map choiceStringsToButtons message.choices)
                ]
            ]

    else
        text ""


renderButtons : List ButtonInfo -> Html Msg
renderButtons buttonList =
    div []
        (List.map
            (\buttonItem ->
                button
                    [ class "btn btn-primary choice-button"
                    , onClick (ChoiceButtonClicked buttonItem.action)
                    ]
                    [ text buttonItem.label ]
            )
            buttonList
        )
