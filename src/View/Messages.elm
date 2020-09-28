module View.Messages exposing (view)

import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
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

choiceStringsToButtons: String -> ButtonInfo
choiceStringsToButtons buttonString = 
    { label = buttonString, action = "#" }


view : Dict String Content.MessageData -> Html Msg
view messagesDict =
    ul [ class "message-list p-0" ]
    (List.map renderMessageAndPrompt (Dict.values messagesDict))

renderMessageAndPrompt : Content.MessageData -> Html Msg
renderMessageAndPrompt message = 
    div [] [
        renderMessage message.author message.content
        , renderPrompt message
    ]


renderMessage : String -> String -> Html Msg
renderMessage from message =
    li
        [ class "message al w-75 float-left mt-3 ml-5 py-2" ]
        [ div [ class "ml-3" ]
            [ p [ class "message-from m-0" ]
                [ text from ]
            , p
                [ class "card-text m-0" ]
                [ Markdown.toHtml [ class "content" ]  message ]
            ]
        ]

renderPrompt : Content.MessageData -> Html Msg
renderPrompt message = 
    if List.length message.choices > 0 then
        li
            [ class "message player w-75 float-right mt-3 mr-5 py-2" ]
            [ div [ class "ml-3" ]
                [ p [ class "message-from m-0" ]
                    [ text (t FromPlayerTeam) ]
                --, div [ class "card-text m-0" ]
                --    [ Markdown.toHtml [ class "content" ] message.content ]
                , renderButtons (List.map choiceStringsToButtons message.choices)
                ]
            ]
    else 
        span [] []


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
