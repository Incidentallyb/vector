module View.PathChecker exposing (view)

import Content
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
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
        -- Todo hardcoded for demo
        |> filterChoicesBySelected [ "macaques" ]


filterChoicesBySelected : List String -> List String -> List String
filterChoicesBySelected selectedChoices allChoices =
    List.filter (\item -> isTriggeredByChoices selectedChoices item) allChoices


isTriggeredByChoices : List String -> String -> Bool
isTriggeredByChoices selectedChoices triggeredBy =
    let
        choiceString =
            String.join "|" selectedChoices

        cleanTriggerString =
            String.split "|" triggeredBy
                |> List.filter (\choice -> not (List.member choice ignoreInChoiceMatch))
                |> String.join "|"
    in
    -- Append init|start| so we match in choice order from start
    String.contains choiceString ("init|start|" ++ cleanTriggerString)


ignoreInChoiceMatch : List String
ignoreInChoiceMatch =
    [ "init", "start", "step", "change" ]


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
                            , ul [ class "messages" ]
                                (renderContentTitles choice (Dict.values allContent.messages))
                            , ul [ class "emails" ]
                                (renderContentTitles choice (Dict.values allContent.emails))
                            , ul [ class "documents" ]
                                (renderContentTitles choice (Dict.values allContent.documents))
                            , ul [ class "socials" ]
                                (renderContentTitles choice (Dict.values allContent.social))
                            , if nextIsShorter choice (getNext (filterChoicesByPath path (List.sort choiceList)) choice) then
                                p [ class "path-end" ] []

                              else
                                text ""
                            ]
                    )
                    (filterChoicesByPath path (List.sort choiceList))
                )
        )
        pathList


type alias ContentData a =
    { a | basename : String, triggered_by : List String }


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


nextIsShorter : String -> Maybe String -> Bool
nextIsShorter currentChoice nextChoice =
    let
        currentLength =
            List.length (String.split "|" currentChoice)

        nextLength =
            List.length (String.split "|" (Maybe.withDefault "" nextChoice))
    in
    currentLength > nextLength



-- Drop first item in list & zip with original to get tuple (current, next)
-- Filter for current choice, take only the next and grab head


getNext : List String -> String -> Maybe String
getNext triggerList choice =
    triggerList
        |> List.drop 1
        |> zip triggerList
        |> List.filter (\( current, _ ) -> current == choice)
        |> List.map (\( _, next ) -> next)
        |> List.head



-- Convert 2 lists to list of tuples


zip : List String -> List String -> List ( String, String )
zip first next =
    List.map2 Tuple.pair first next
