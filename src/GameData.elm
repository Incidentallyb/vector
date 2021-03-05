module GameData exposing (CheckboxData, GameData, NotificationCount, ScoreType(..), emailContainsPendingDecision, filterDocuments, filterEmails, filterMessages, filterSocials, getStringIfMatchFound, init, unactionedEmailChoices, unactionedMessageChoices, updateScore)

import Content exposing (BranchingContent(..), DocumentData, EmailData, MessageData, SocialData)
import ContentChoices exposing (branchingContentListKeyedByTriggerChoice, getBranchingChoiceChosen, getTriggeredBy, socialListKeyedByTriggerChoice, triggeredByChoices)
import Dict exposing (Dict)
import Set exposing (Set)


type alias GameData =
    { choices : List String
    , choicesVisited : Set String
    , checkboxSet : CheckboxData
    , teamName : String
    , scoreSuccess : Int
    , scoreEconomic : Int
    , scoreHarm : Int
    }


type alias CheckboxData =
    -- Right now we only have one but later we might do something like this:
    -- checkboxSets : { choice5 : (Set.empty, False) }
    { selected : Set String, submitted : Bool }


type alias NotificationCount =
    { messages : Int
    , messagesNeedAttention : Bool
    , documents : Int
    , emails : Int
    , emailsNeedAttention : Bool
    , social : Int
    }


init : GameData
init =
    { choices = []
    , choicesVisited = Set.empty
    , checkboxSet = { selected = Set.empty, submitted = False }
    , teamName = "?"
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }



-- Public filter functions, might become one
-- Might also want change these to return List (String, String, ContentData)
-- With Strings being trigger & choice made to make render less complicated


filterMessages : Dict String MessageData -> List String -> Dict String MessageData
filterMessages messagesData choices =
    -- Try to get a Dict of keyed filtered message. Fail with empty.
    filterBranchingContent (messagesToBranchingContent messagesData) choices
        |> branchingContentToMessageData
        |> Maybe.withDefault Dict.empty


filterEmails : Dict String EmailData -> List String -> String -> Dict String EmailData
filterEmails emailsData choices teamname =
    -- Try to get a Dict of keyed filtered emails. Fail with empty.
    filterBranchingContent (emailsToBranchingContent emailsData) choices
        |> branchingContentToEmailData
        |> filterByHiddenFromTeam teamname
        |> Maybe.withDefault Dict.empty


filterSocials : Dict String SocialData -> List String -> Dict String SocialData
filterSocials allSocials choices =
    let
        filteredSocials =
            Dict.filter (\_ value -> triggeredByChoices choices value.triggered_by) allSocials
    in
    Dict.fromList (socialListKeyedByTriggerChoice choices filteredSocials)


filterDocuments : Dict String DocumentData -> List String -> Dict String DocumentData
filterDocuments documentData choices =
    -- Try to get a Dict of keyed filtered message. Fail with empty.
    filterBranchingContent (documentsToBranchingContent documentData) choices
        |> branchingContentToDocumentData
        |> Maybe.withDefault Dict.empty



--
-- Branching content helpers
--


filterBranchingContent : Dict String BranchingContent -> List String -> Dict String BranchingContent
filterBranchingContent contentData choices =
    let
        filteredData =
            Dict.filter (\_ value -> triggeredByChoices choices (getTriggeredBy value)) contentData
    in
    -- A Dict of messages keyed by the choice string that triggered them.
    -- In alphabetical order so messages triggered first come first in dict.
    Dict.fromList (branchingContentListKeyedByTriggerChoice choices filteredData)


messagesToBranchingContent : Dict String MessageData -> Dict String BranchingContent
messagesToBranchingContent data =
    Dict.map (\_ messageData -> Message messageData) data


emailsToBranchingContent : Dict String EmailData -> Dict String BranchingContent
emailsToBranchingContent data =
    Dict.map (\_ emailData -> Email emailData) data


documentsToBranchingContent : Dict String DocumentData -> Dict String BranchingContent
documentsToBranchingContent data =
    Dict.map (\_ documentData -> Document documentData) data


branchingContentToMessageData : Dict String BranchingContent -> Maybe (Dict String MessageData)
branchingContentToMessageData contentDict =
    let
        keyedList =
            Dict.toList contentDict
    in
    case List.head keyedList of
        -- Our branching data holds messages
        Just ( _, Message _ ) ->
            Just (Dict.fromList (List.map (\( key, value ) -> ( key, getMessage value )) keyedList))

        _ ->
            Nothing


getMessage : BranchingContent -> MessageData
getMessage data =
    case data of
        Message message ->
            message

        _ ->
            -- Not sure best way to handle this error
            Content.emptyMessage


branchingContentToEmailData : Dict String BranchingContent -> Maybe (Dict String EmailData)
branchingContentToEmailData contentDict =
    let
        keyedList =
            Dict.toList contentDict
    in
    case List.head keyedList of
        -- Our branching data holds emails
        Just ( _, Email _ ) ->
            Just (Dict.fromList (List.map (\( key, email ) -> ( key, getEmail email )) keyedList))

        _ ->
            Nothing


filterByHiddenFromTeam : String -> Maybe (Dict String EmailData) -> Maybe (Dict String EmailData)
filterByHiddenFromTeam teamname maybeEmails =
    case maybeEmails of
        Just emails ->
            Just
                (Dict.filter
                    (\_ value ->
                        case value.hideFromTeams of
                            Just hidelist ->
                                not (List.member teamname hidelist)

                            Nothing ->
                                True
                    )
                    emails
                )

        Nothing ->
            Nothing


getEmail : BranchingContent -> EmailData
getEmail data =
    case data of
        Email email ->
            email

        _ ->
            -- Not sure best way to handle this error.
            Content.emptyEmail


branchingContentToDocumentData : Dict String BranchingContent -> Maybe (Dict String DocumentData)
branchingContentToDocumentData contentDict =
    let
        keyedList =
            Dict.toList contentDict
    in
    case List.head keyedList of
        -- Our branching data holds documents
        Just ( _, Document _ ) ->
            Just (Dict.fromList (List.map (\( key, value ) -> ( key, getDocument value )) keyedList))

        _ ->
            Nothing


getDocument : BranchingContent -> DocumentData
getDocument data =
    case data of
        Document document ->
            document

        _ ->
            Content.emptyDocument



--
-- Notification functions
--
-- work out if there are un-actioned choices in emails


unactionedEmailChoices : Dict String EmailData -> List String -> String -> Bool
unactionedEmailChoices emails choices teamname =
    let
        maybeLastEmailDisplayed =
            List.head (List.reverse (Dict.toList (filterEmails emails choices teamname)))

        lastEmailDisplayed =
            case maybeLastEmailDisplayed of
                Just item ->
                    Tuple.second item

                Nothing ->
                    Content.emptyEmail
    in
    emailContainsPendingDecision lastEmailDisplayed choices


emailContainsPendingDecision : EmailData -> List String -> Bool
emailContainsPendingDecision email choices =
    let
        triggeredBy =
            email.triggered_by

        potentialChoices =
            case email.choices of
                Just someChoices ->
                    List.map ContentChoices.getChoiceAction someChoices

                Nothing ->
                    []

        triggerString =
            String.join "|" (List.reverse choices)

        triggeredByLastChoice =
            List.member triggerString triggeredBy

        hasChoiceMatchLastChoice =
            List.member ("|" ++ Maybe.withDefault "" (List.head choices)) potentialChoices
    in
    triggeredByLastChoice && not hasChoiceMatchLastChoice



--
-- Notification functions
--
-- work out if there are un-actioned choices in messages


unactionedMessageChoices : Dict String MessageData -> List String -> Bool
unactionedMessageChoices messages choices =
    let
        maybeLastMessageDisplayed =
            List.head (List.reverse (Dict.toList (filterMessages messages choices)))

        lastMessageDisplayed =
            case maybeLastMessageDisplayed of
                Just item ->
                    Tuple.second item

                Nothing ->
                    Content.emptyMessage

        -- will return choice triggers with pipe prefix for the last item, e.g. (|macaques, |pigs, ... )
        choiceTriggers =
            List.map ContentChoices.getChoiceAction lastMessageDisplayed.choices

        -- see if the last message has choices but we've answered them already
        -- or if the last message has no available choices
        hasDoneActionsFromMessages =
            List.member ("|" ++ Maybe.withDefault "" (List.head choices)) choiceTriggers
                || List.length choiceTriggers
                == 0
    in
    not hasDoneActionsFromMessages



--
-- Scoring functions
--
{-
   This function produces a list of tuples of choices chosen against their message, e.g.
   [ ("start", message1) ] , then on next choice it would be
   [ ("start", message1), ("macaques", message2) ]
-}


choicesAndBranchingContent : List String -> List BranchingContent -> List ( String, BranchingContent )
choicesAndBranchingContent playerChoices contentList =
    List.map (\content -> ( getBranchingChoiceChosen playerChoices content, content ))
        -- We want to process the messages in reverse for scoring
        (List.reverse contentList)



{-
   given a string like "macaques|50" , return string "50" if string == macaques
   given a string like "mice|=30" , return string "=30" if string == mice

   This allows our scoreChange options to be both delta modifiers (+/-)
   or be prefixed with a = if we want to SET a value.
-}


getStringIfMatchFound : String -> String -> String
getStringIfMatchFound scoreChangeValue choice =
    let
        ( changeValue, choiceMatch ) =
            ( case List.head (String.indexes "|" scoreChangeValue) of
                Nothing ->
                    ""

                Just val ->
                    String.dropLeft (val + 1) scoreChangeValue
            , case List.head (String.indexes "|" scoreChangeValue) of
                Nothing ->
                    scoreChangeValue

                Just val ->
                    String.left val scoreChangeValue
            )
    in
    if choiceMatch == choice then
        changeValue

    else
        ""


type ScoreType
    = Economic
    | Harm
    | Success


updateScore : ScoreType -> Content.Datastore -> List String -> String -> Int
updateScore scoreType datastore gamedataChoices newChoice =
    let
        playerChoices =
            newChoice :: gamedataChoices

        messageDict =
            messagesToBranchingContent datastore.messages

        emailDict =
            emailsToBranchingContent datastore.emails

        -- get a list of the messages & emails that are being shown
        messages =
            filterBranchingContent (Dict.union messageDict emailDict) gamedataChoices
                |> Dict.values
                |> List.reverse

        -- this variable ends up with a list of score changes based on each message's point in time, e.g.
        -- [18, -7, 0 ] for the message choices of start > macaques > stay
        listOfScoreChanges =
            choicesAndBranchingContent playerChoices messages
                |> List.map (\( choice, message ) -> getScoreChanges scoreType choice message)
    in
    -- take all of the score changes and add them together
    List.foldl
        (\x a ->
            let
                result =
                    case String.left 1 x of
                        "=" ->
                            Maybe.withDefault 0 (String.toInt (String.dropLeft 1 x))

                        _ ->
                            a + Maybe.withDefault 0 (String.toInt x)
            in
            result
        )
        0
        listOfScoreChanges



{-
   This function produces a list of change values that match choices made for this message.
   so if you have a choice of 'macaque' and your scoreChangeEconomic is
       ["macaques|-7", "pigs|-3", "mice|-2", "fish|-4", "bio|-11"]
   it will return
       foldr (+) 0 [-7 , 0 , 0 , 0 , 0]
   == -7
-}


getScoreChanges : ScoreType -> String -> BranchingContent -> String
getScoreChanges scoreType choice message =
    List.foldr (++) "" (List.map (\scoreChangeValue -> getStringIfMatchFound scoreChangeValue choice) (getScoreChange scoreType message))


getScoreChange : ScoreType -> BranchingContent -> List String
getScoreChange changeType branchingContent =
    let
        maybeChange =
            case branchingContent of
                Message contentData ->
                    case changeType of
                        Economic ->
                            contentData.scoreChangeEconomic

                        Harm ->
                            contentData.scoreChangeHarm

                        Success ->
                            contentData.scoreChangeSuccess

                Email contentData ->
                    case changeType of
                        Economic ->
                            contentData.scoreChangeEconomic

                        Harm ->
                            contentData.scoreChangeHarm

                        Success ->
                            contentData.scoreChangeSuccess

                {-
                   List.tail is the easiest way to return a 'Maybe' for these items that
                   don't cause any score changes
                -}
                Document _ ->
                    List.tail [ "" ]
    in
    Maybe.withDefault [ "" ] maybeChange
