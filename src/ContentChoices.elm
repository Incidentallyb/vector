module ContentChoices exposing (choiceStepsList, getChoiceChosen, getChoiceChosenEmail, triggeredBranchingContentByChoice, triggeredByChoices, triggeredByChoicesGetMatches, triggeredByWithChoiceStrings, triggeredEmailsByChoice, triggeredMessagesByChoice, triggeredSocialsByChoice)

import Content exposing (BranchingContent(..), EmailData, MessageData, SocialData)
import Dict exposing (Dict)
import List.Extra
import Set



--
-- Public functions to get choices and triggered content keyed by choice list
--


triggeredBranchingContentByChoice : List String -> Dict String BranchingContent -> Dict String BranchingContent
triggeredBranchingContentByChoice choices contentData =
    let
        filteredData =
            Dict.filter (\_ value -> triggeredByChoices choices (getTriggeredBy value)) contentData
    in
    -- A Dict of messages keyed by the choice string that triggered them.
    -- In alphabetical order so messages triggered first come first in dict.
    Dict.fromList (branchingContentListKeyedByTriggerChoice choices filteredData)


triggeredEmailsByChoice : List String -> Dict String EmailData -> Dict String EmailData
triggeredEmailsByChoice choices emails =
    let
        filteredEmails =
            Dict.filter (\_ value -> triggeredByChoices choices value.triggered_by) emails
    in
    -- A Dict of emails keyed by the choice string that triggered them.
    -- In alphabetical order so emails triggered first come first in dict.
    Dict.fromList (emailListKeyedByTriggerChoice choices filteredEmails)


triggeredMessagesByChoice : List String -> Dict String MessageData -> Dict String MessageData
triggeredMessagesByChoice choices messages =
    let
        filteredMessages =
            Dict.filter (\_ value -> triggeredByChoices choices value.triggered_by) messages
    in
    -- A Dict of messages keyed by the choice string that triggered them.
    -- In alphabetical order so messages triggered first come first in dict.
    Dict.fromList (messageListKeyedByTriggerChoice choices filteredMessages)


triggeredSocialsByChoice : List String -> Dict String SocialData -> Dict String SocialData
triggeredSocialsByChoice choices socials =
    let
        filteredSocials =
            Dict.filter (\_ value -> triggeredByChoices choices value.triggered_by) socials
    in
    Dict.fromList (socialListKeyedByTriggerChoice choices filteredSocials)


getChoiceChosen : List String -> MessageData -> String
getChoiceChosen playerChoices message =
    -- first choice is 'init', so don't do anything
    -- if the message doesn't give us choices, don't do anything
    if List.length playerChoices <= 1 || List.length message.choices == 0 then
        ""

    else
        let
            -- set of current player choices, e.g. ["init", "init|start", "init|start|macaque"]
            setOfPlayerChoices =
                Set.fromList (choiceStepsList playerChoices)

            -- list of valid triggers for the current message that match our current or historical player choices
            -- this is normally a single item, but could be multiple
            -- e.g. [ "init|start" ]
            listOfChoicesThatMatch =
                triggeredByChoicesGetMatches playerChoices message.triggered_by

            -- set of triggers that also have our choice strings attached to them, e.g.
            -- [ "init|start|macaque", "init|start|fish", "init|start|mice" ... ]
            setOfTriggersWithChoiceStringsAttached =
                Set.fromList (triggeredByWithChoiceStrings listOfChoicesThatMatch message.choices)

            -- which player choices match this message?
            setOfMatches =
                Set.intersect setOfPlayerChoices setOfTriggersWithChoiceStringsAttached

            -- take the matching player choice, find the last string (e.g. "macaques")
            -- and we use that as the value that was clicked by the button
            chosenAction =
                Maybe.withDefault "" (List.head (List.reverse (String.split "|" (Maybe.withDefault "" (List.head (Set.toList setOfMatches))))))

            result =
                if Set.isEmpty setOfMatches then
                    ""

                else
                    chosenAction

            -- debugger =
            --    Debug.log "SETS" (Debug.toString playerChoices ++ " TRIGGERS for " ++ message.basename ++ " " ++ Debug.toString (triggeredByWithChoiceStrings playerChoices message.choices))
        in
        result


getChoiceChosenEmail : List String -> EmailData -> String
getChoiceChosenEmail playerChoices email =
    -- first choice is 'init', so don't do anything
    -- if the message doesn't give us choices, don't do anything
    if List.length playerChoices <= 1 || List.length (Maybe.withDefault [] email.choices) == 0 then
        ""

    else
        let
            -- set of current player choices, e.g. ["init", "init|start", "init|start|macaque"]
            setOfPlayerChoices =
                Set.fromList (choiceStepsList playerChoices)

            -- list of valid triggers for the current email that match our current or historical player choices
            -- this is normally a single item, but could be multiple
            -- e.g. [ "init|start" ]
            listOfChoicesThatMatch =
                triggeredByChoicesGetMatches playerChoices email.triggered_by

            -- set of triggers that also have our choice strings attached to them, e.g.
            -- [ "init|start|macaque", "init|start|fish", "init|start|mice" ... ]
            setOfTriggersWithChoiceStringsAttached =
                Set.fromList (triggeredByWithChoiceStrings listOfChoicesThatMatch (Maybe.withDefault [] email.choices))

            -- which player choices match this email?
            setOfMatches =
                Set.intersect setOfPlayerChoices setOfTriggersWithChoiceStringsAttached

            -- take the matching player choice, find the last string (e.g. "macaques")
            -- and we use that as the value that was clicked by the button
            chosenAction =
                Maybe.withDefault "" (List.head (List.reverse (String.split "|" (Maybe.withDefault "" (List.head (Set.toList setOfMatches))))))

            result =
                if Set.isEmpty setOfMatches then
                    ""

                else
                    chosenAction
        in
        result



--
-- Private helper functions
--
-- Process choices into a staged list of choice strings to match triggers
--   e.g. ["start", "macaques", "stay"] becomes ["start", "start|macaques", "start|macaques|stay"]


choiceStepsList : List String -> List String
choiceStepsList currentChoices =
    let
        list =
            case currentChoices of
                -- There are at least 2 choices in the list (a first choice and tail)
                firstChoice :: remainingChoices ->
                    -- Join them by pipe, add to list and call again on the tail
                    String.join "|" (List.reverse remainingChoices ++ [ firstChoice ])
                        :: choiceStepsList remainingChoices

                oneChoiceList ->
                    -- return unchanged
                    oneChoiceList
    in
    list


getTriggeringChoice : List String -> List String -> String
getTriggeringChoice choices triggers =
    let
        choiceSet =
            -- The set of choices at each stage
            Set.fromList (choiceStepsList choices)

        triggerSet =
            -- The set of triggers in this content's `triggered_by`
            Set.fromList triggers
    in
    -- Get the match (the choice string that triggered this content to display)
    Set.intersect choiceSet triggerSet
        |> Set.toList
        |> List.head
        |> Maybe.withDefault "error-no-choice-trigger-match"


branchingContentListKeyedByTriggerChoice : List String -> Dict String BranchingContent -> List ( String, BranchingContent )
branchingContentListKeyedByTriggerChoice choices content =
    -- Go through the (key, message) pairs and replace key with the choice string that triggered it.
    List.map
        (\( _, data ) ->
            ( getTriggeringChoice choices (getTriggeredBy data), data )
        )
        (Dict.toList content)


getTriggeredBy : BranchingContent -> List String
getTriggeredBy content =
    case content of
        Message message ->
            message.triggered_by

        Email email ->
            email.triggered_by


messageListKeyedByTriggerChoice : List String -> Dict String MessageData -> List ( String, MessageData )
messageListKeyedByTriggerChoice choices messages =
    -- Go through the (key, message) pairs and replace key with the choice string that triggered it.
    List.map
        (\( _, message ) -> ( getTriggeringChoice choices message.triggered_by, message ))
        (Dict.toList messages)


emailListKeyedByTriggerChoice : List String -> Dict String EmailData -> List ( String, EmailData )
emailListKeyedByTriggerChoice choices emails =
    -- Go through the (key, email) pairs and replace key with the choice string that triggered it.
    List.map
        (\( _, email ) -> ( getTriggeringChoice choices email.triggered_by, email ))
        (Dict.toList emails)


socialListKeyedByTriggerChoice : List String -> Dict String SocialData -> List ( String, SocialData )
socialListKeyedByTriggerChoice choices socials =
    -- Go through the (key, message) pairs and replace key with the choice string that triggered it.
    List.map
        (\( _, social ) -> ( getTriggeringChoice choices social.triggered_by, social ))
        (Dict.toList socials)


triggeredByChoices : List String -> List String -> Bool
triggeredByChoices currentChoices triggeredByList =
    choiceStepsList currentChoices
        |> List.map (\choices -> List.member choices triggeredByList)
        |> List.member True



-- find the triggeredBy strings that match our current choices


triggeredByChoicesGetMatches : List String -> List String -> List String
triggeredByChoicesGetMatches currentChoices triggeredByList =
    choiceStepsList currentChoices
        |> List.map (\choice -> Maybe.withDefault "" (List.Extra.find (\val -> val == choice) triggeredByList))
        |> List.filter (\returnString -> returnString /= "")



{-
   Finding player choices is done by looking at the current message.triggered_by,
   seeing if that matches one of our current or previous game choices,
   then looping over the choice actions to see if the current game choice list's last element matches
   one of our choice actions.

   e.g.
       gameData.choices = [ "macaques", "start", "init"]
   so we've just clicked to select 'macaques' as our animal.

   The message entry for that point in time is
       message.triggered_by = [ "init|start" ]
       message.choices = [ "macaques|Macaques", "mice|Mice", "fish|Fish" ... ]

   so we transform gameData.choices to ["init" , "init|start", "init|start|macaques"],
   and iterate over all the combinations and look for matches against [ "init|start|macaques", "init|start|mice", "init|start|fish" ... ]

   If we find a match, we simply take the last element of the string (macaques) and deduce that this must be the value we chose for this message.

-}
-- creates a new triggeredBy list which has all the choice combinations added


triggeredByWithChoiceStrings : List String -> List String -> List String
triggeredByWithChoiceStrings triggeredBy choices =
    List.Extra.lift2 (++) triggeredBy (List.map getChoiceAction choices)


getChoiceAction : String -> String
getChoiceAction choiceString =
    let
        action =
            case List.head (String.indexes "|" choiceString) of
                Nothing ->
                    choiceString

                Just val ->
                    String.left val choiceString
    in
    "|" ++ action
