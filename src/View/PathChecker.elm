module View.PathChecker exposing (Model, Msg, update, view)

import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Set


type alias Model =
    String


type Msg
    = ChangeFilter String


update : Msg -> ( Model, Cmd Msg )
update msg =
    case msg of
        ChangeFilter newFilter ->
            ( newFilter, Cmd.none )


view : Model -> Content.Datastore -> Html Msg
view filterString contentData =
    div [ id "path-checker" ]
        [ renderProblems contentData
        , text (t FilterInputLabel)
        , input
            [ placeholder (t FilterInputPlaceholder)
            , onInput ChangeFilter
            , value filterString
            ]
            []
        , renderTable (getAvailableChoices filterString contentData) contentData
        ]


ignoreInChoiceMatch : List String
ignoreInChoiceMatch =
    [ "step", "change" ]


pathList : List String
pathList =
    [ "bio", "fish", "macaque", "mice", "pigs" ]


nonScoringChoices : List String
nonScoringChoices =
    [ "training", "rehousing", "helping", "making", "publishing", "cage", "donothing" ]
        ++ [ "one-extra", "two-extras", "nothing" ]
        ++ [ "replay", "send" ]
        ++ [ "feedback" ]


renderProblems : Content.Datastore -> Html Msg
renderProblems content =
    div []
        [ h3 [] [ text "Choices that do not appear in any trigger" ]
        , ul [ id "bad-choices" ] (getChoiceKeyTypos content)
        , h3 [] [ text "Content hidden from some teams or without trigger" ]
        , ul [ id "hidden-content" ] (getProblemList content)
        , h3 [] [ text "Dead ends" ]
        , ul [ id "dead-ends" ] (getDeadEnds content)
        ]


getChoiceKeyTypos : Content.Datastore -> List (Html Msg)
getChoiceKeyTypos content =
    List.map (\choice -> li [] [ text choice ])
        -- filter out choices not in any triggered_by
        (List.filter (\aChoice -> not (List.member aChoice (getAllTriggerKeys content))) (getChoiceList content)
            -- Filter out ending choices
            |> List.filter (\maybeBadChoice -> not (List.member maybeBadChoice nonScoringChoices))
        )


getAllTriggerKeys : Content.Datastore -> List String
getAllTriggerKeys content =
    getTriggerList content
        |> List.map (\trigger -> String.split "|" trigger)
        |> List.concat


getProblemList : Content.Datastore -> List (Html Msg)
getProblemList allContent =
    let
        messages =
            Dict.values allContent.messages

        messageErrors =
            List.map
                (\message ->
                    if List.isEmpty message.triggered_by then
                        [ li []
                            [ text "* Message with empty triggered by: "
                            , contentPathFromBasename "message" message.basename
                            ]
                        ]

                    else
                        [ text "" ]
                )
                messages

        documents =
            Dict.values allContent.documents

        documentErrors =
            List.map
                (\document ->
                    if List.isEmpty document.triggered_by then
                        [ li []
                            [ text "* Document with empty triggered by: "
                            , contentPathFromBasename "document" document.basename
                            ]
                        ]

                    else
                        [ text "" ]
                )
                documents

        emails =
            Dict.values allContent.emails

        emailErrors =
            List.map
                (\email ->
                    [ case email.hideFromTeams of
                        Nothing ->
                            text ""

                        Just teamList ->
                            li []
                                [ text
                                    ("* Email is hidden from "
                                        ++ String.join ", " (List.sort teamList)
                                        ++ ": "
                                    )
                                , contentPathFromBasename "email" email.basename
                                ]
                    , if List.isEmpty email.triggered_by then
                        li []
                            [ text "* Email with empty triggered by: "
                            , contentPathFromBasename "email" email.basename
                            ]

                      else
                        text ""
                    ]
                )
                emails

        socials =
            Dict.values allContent.social

        socialErrors =
            List.map
                (\social ->
                    if List.isEmpty social.triggered_by then
                        [ li []
                            [ text "* Social with empty triggered by: "
                            , contentPathFromBasename "social" social.basename
                            ]
                        ]

                    else
                        [ text "" ]
                )
                socials
    in
    (documentErrors ++ emailErrors ++ messageErrors ++ socialErrors)
        |> List.concat


getDeadEnds : Content.Datastore -> List (Html Msg)
getDeadEnds content =
    let
        allTriggers =
            getTriggerList content

        messagePathDataWithChoices =
            messagesToPathData (Dict.values content.messages)
                |> List.filter (\data -> List.length data.triggers > 0)

        messagesWithDeadEndChoices =
            List.map
                (\data ->
                    List.filter (\trigger -> not (List.member trigger allTriggers)) data.triggers
                )
                messagePathDataWithChoices
                |> List.concat

        excludeMessagesEndingInNonScoringChoice =
            List.filter (\trigger -> not (List.member (lastChoice trigger) nonScoringChoices)) messagesWithDeadEndChoices

        emailPathDataWithChoices =
            emailsToPathData (Dict.values content.emails)
                |> List.filter (\data -> List.length data.triggers > 0)

        emailsWithDeadEndChoices =
            List.map
                (\data ->
                    List.filter (\trigger -> not (List.member trigger allTriggers)) data.triggers
                )
                emailPathDataWithChoices
                |> List.concat

        excludeEmailsEndingInNonScoringChoice =
            List.filter (\trigger -> not (List.member (lastChoice trigger) nonScoringChoices)) emailsWithDeadEndChoices
    in
    List.map (\path -> li [] [ text path ])
        (excludeEmailsEndingInNonScoringChoice
            ++ excludeMessagesEndingInNonScoringChoice
            |> List.sort
        )


lastChoice : String -> String
lastChoice trigger =
    String.split "|" trigger
        |> List.reverse
        |> List.head
        |> Maybe.withDefault ""


type alias PathData =
    { triggers : List String
    , basename : String
    }


messagesToPathData : List Content.MessageData -> List PathData
messagesToPathData messages =
    List.map pathDataFromMessage messages


pathDataFromMessage :
    Content.MessageData
    ->
        { triggers : List String
        , basename : String
        }
pathDataFromMessage message =
    { triggers = List.map (\choice -> List.map (\trigger -> trigger ++ "|" ++ getChoiceKey choice) message.triggered_by) message.choices |> List.concat
    , basename = message.basename
    }


emailsToPathData : List Content.EmailData -> List PathData
emailsToPathData emails =
    List.map pathDataFromEmail emails


pathDataFromEmail :
    Content.EmailData
    ->
        { triggers : List String
        , basename : String
        }
pathDataFromEmail email =
    { triggers =
        List.map
            (\choice ->
                List.map (\trigger -> trigger ++ "|" ++ getChoiceKey choice) email.triggered_by
            )
            (getEmailChoicesFromMaybes [ email.choices ])
            |> List.concat
    , basename = email.basename
    }


getChoiceKey : String -> String
getChoiceKey choicePair =
    Maybe.withDefault "" (List.head (String.split "|" choicePair))


getChoiceList : Content.Datastore -> List String
getChoiceList allContent =
    let
        messageChoices =
            List.map (\message -> List.map (\choice -> getChoiceKey choice) message.choices) (Dict.values allContent.messages) |> List.concat

        maybeEmailChoicesList =
            Dict.values allContent.emails
                |> List.map (\email -> email.choices)

        emailChoices =
            getEmailChoicesFromMaybes maybeEmailChoicesList
    in
    messageChoices ++ emailChoices |> Set.fromList |> Set.toList


getEmailChoicesFromMaybes : List (Maybe (List String)) -> List String
getEmailChoicesFromMaybes maybeEmailChoicesList =
    List.map
        (\maybeEmailChoices ->
            case maybeEmailChoices of
                Just choiceList ->
                    List.map (\choice -> getChoiceKey choice) choiceList

                Nothing ->
                    []
        )
        maybeEmailChoicesList
        |> List.concat


getTriggerList : Content.Datastore -> List String
getTriggerList allContent =
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


contentPathFromBasename : String -> String -> Html Msg
contentPathFromBasename contentType basename =
    a [ href (String.join "/" [ "/admin/#/collections", contentType, "entries", basename ]) ]
        [ text basename ]


getAvailableChoices : Model -> Content.Datastore -> List String
getAvailableChoices filterString allContent =
    getTriggerList allContent
        |> filterChoicesBySelected (String.split ", " filterString)


filterChoicesBySelected : List String -> List String -> List String
filterChoicesBySelected selectedChoices allChoices =
    List.filter (\item -> isTriggeredByChoices selectedChoices item) allChoices


isTriggeredByChoices : List String -> String -> Bool
isTriggeredByChoices selectedChoices triggeredBy =
    let
        choiceString =
            -- Append init|start| so we match in choice order from start
            "init|start|" ++ String.join "|" selectedChoices

        cleanTriggerString =
            String.split "|" triggeredBy
                |> List.filter (\choice -> not (List.member choice ignoreInChoiceMatch))
                |> String.join "|"
    in
    String.contains choiceString cleanTriggerString


filterChoicesByPath : String -> List String -> List String
filterChoicesByPath path choices =
    List.filter (\choice -> String.contains path choice) choices


renderTable : List String -> Content.Datastore -> Html Msg
renderTable allChoices allContent =
    table [ Html.Attributes.style "background-color" "white", Html.Attributes.style "font-size" "10px" ]
        [ thead [] [ tr [] renderHeaders ]
        , tbody []
            [ tr []
                (renderMessageList allChoices allContent)
            ]
        ]


renderHeaders : List (Html Msg)
renderHeaders =
    List.map (\path -> th [] [ text path ]) pathList


renderBoldChoices : String -> Html Msg
renderBoldChoices choice =
    let
        choiceList =
            String.split "|" choice
    in
    p []
        (List.map
            (\item ->
                renderBoldChoice item (isLastItem item choiceList)
            )
            choiceList
        )


isLastItem : String -> List String -> Bool
isLastItem item list =
    item == Maybe.withDefault "" (List.head (List.reverse list))


renderBoldChoice : String -> Bool -> Html Msg
renderBoldChoice choice isLast =
    if List.member choice ignoreInChoiceMatch then
        if not isLast then
            text (choice ++ "|")

        else
            text choice

    else
        b []
            [ text choice
            , if not isLast then
                text "|"

              else
                text ""
            ]


renderMessageList : List String -> Content.Datastore -> List (Html Msg)
renderMessageList choiceList allContent =
    List.map
        (\path ->
            td []
                (List.map
                    (\choice ->
                        div []
                            [ renderBoldChoices choice
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
    { a
        | basename : String
        , triggered_by : List String
    }


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
