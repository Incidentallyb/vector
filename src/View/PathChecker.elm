module View.PathChecker exposing (view)

import Content
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Message exposing (Msg(..))
import Set


view : Content.Datastore -> Html Msg
view contentData =
    div [ id "path-checker" ]
        [ renderTable (getAllChoices contentData) contentData
        ]


getAllChoices : Content.Datastore -> List String
getAllChoices allContent =
    let
        messages =
            Dict.values allContent.messages

        messageTriggers =
            List.map (\message -> message.triggered_by) messages

        documents =
            Dict.values allContent.documents

        documentTriggers =
            List.map (\document -> document.triggered_by) documents

        emails =
            Dict.values allContent.emails

        emailTriggers =
            List.map (\email -> email.triggered_by) emails

        socials =
            Dict.values allContent.social

        socialTriggers =
            List.map (\social -> social.triggered_by) socials
    in
    List.sort (Set.toList (Set.fromList (List.concat messageTriggers)))


pathList : List String
pathList =
    [ "bio", "fish", "macaque", "mice", "pigs" ]


filterChoicesByPath : String -> List String -> List String
filterChoicesByPath path choices =
  List.filter (\choice -> String.contains path choice) choices


renderTable : List String -> Content.Datastore -> Html Msg
renderTable allChoices allContent =
    table []
        [ thead [] [ tr [] (renderHeaders) ]
        , tbody []
            [ tr []
                (renderMessageList allChoices (Dict.values allContent.messages))
            ]
        ]


renderHeaders : List (Html Msg)
renderHeaders =
    List.map (\path -> th [] [ text path ]) pathList


renderMessageList : List String -> List Content.MessageData -> List (Html Msg)
renderMessageList choiceList messageList =
    List.map (\path -> td []( 
      List.map (\choice -> div[][p[][text choice],ul[]
        (renderMessageTitles choice messageList)
        ]) (filterChoicesByPath path choiceList))
    
    ) pathList


renderMessageTitles : String -> List Content.MessageData -> List (Html Msg)
renderMessageTitles choice messages =
    List.map
        (\message ->
            if messageTriggeredByChoice choice message.triggered_by then
                li [] [ text message.basename ]

            else
                text ""
        )
        messages


messageTriggeredByChoice : String -> List String -> Bool
messageTriggeredByChoice choice triggerList =
    List.member choice triggerList


renderMessage : Content.MessageData -> Html Msg
renderMessage message =
    li []
        [ span [] (List.map renderTrigger message.triggered_by)
        , text " - "
        , span [] [ text message.basename ]
        ]


renderTrigger : String -> Html Msg
renderTrigger trigger =
    text trigger
