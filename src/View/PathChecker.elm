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
      (documentTriggers ++ emailTriggers ++ messageTriggers ++ socialTriggers)
          |> List.concat
          |> Set.fromList
          |> Set.toList


pathList : List String
pathList =
    [ "bio", "fish", "macaque", "mice", "pigs" ]


filterChoicesByPath : String -> List String -> List String
filterChoicesByPath path choices =
    List.filter (\choice -> String.contains path choice) choices


renderTable : List String -> Content.Datastore -> Html Msg
renderTable allChoices allContent =
    table []
        [ thead [] [ tr [] renderHeaders ]
        , tbody []
            [ tr []
                (renderMessageList allChoices allContent)
            ]
        ]


renderHeaders : List (Html Msg)
renderHeaders =
    List.map (\path -> th [] [ text path ]) pathList


renderMessageList : List String -> Content.Datastore -> List (Html Msg)
renderMessageList choiceList allContent =
    List.map
        (\path ->
            td []
                (List.map
                    (\choice ->
                        div []
                            [ p [] [ text choice ]
                            , ul [ class "messages"]
                              (renderContentTitles choice (Dict.values allContent.messages))
                            , ul [class "emails"]
                              (renderContentTitles choice (Dict.values allContent.emails))
                            , ul [class "documents"]
                              (renderContentTitles choice (Dict.values allContent.documents))                           
                            , ul [class "socials"]
                              (renderContentTitles choice (Dict.values allContent.social))
                            ]
                    )
                    (filterChoicesByPath path (List.sortBy String.length choiceList))
                )
        )
        pathList

type alias ContentData a =
  { a | basename: String, triggered_by: List String }

renderContentTitles : String -> List (ContentData a) -> List (Html Msg)
renderContentTitles choice content =
    List.map
        (\file ->
            if contentTriggeredByChoice choice file.triggered_by then
                li [] [ text file.basename ]

            else
                text ""
        )
        content


contentTriggeredByChoice : String -> List String -> Bool
contentTriggeredByChoice choice triggerList =
    List.member choice triggerList


renderTrigger : String -> Html Msg
renderTrigger trigger =
    text trigger
