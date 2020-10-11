module GameData exposing (GameData, ScoreType(..), filterEmails, filterMessages, filterSocials, getIntegerIfMatchFound, init, updateScore, updateSuccessScore)

import Content exposing (BranchingContent(..), EmailData, MessageData, SocialData)
import ContentChoices
import Dict exposing (Dict)


type alias GameData =
    { choices : List String
    , teamName : String
    , scoreSuccess : Int
    , scoreEconomic : Int
    , scoreHarm : Int
    }


init : GameData
init =
    { choices = []
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


filterEmails : Dict String EmailData -> List String -> Dict String EmailData
filterEmails emailsData choices =
    -- Try to get a Dict of keyed filtered emails. Fail with empty.
    filterBranchingContent (emailsToBranchingContent emailsData) choices
        |> branchingContentToEmailData
        |> Maybe.withDefault Dict.empty


filterSocials : Dict String SocialData -> List String -> Dict String SocialData
filterSocials allSocials choices =
    ContentChoices.triggeredSocialsByChoice choices allSocials



--
-- Branching content helpers
--


filterBranchingContent : Dict String BranchingContent -> List String -> Dict String BranchingContent
filterBranchingContent content choices =
    ContentChoices.triggeredBranchingContentByChoice choices content


messagesToBranchingContent : Dict String MessageData -> Dict String BranchingContent
messagesToBranchingContent data =
    Dict.map (\_ messageData -> Message messageData) data


emailsToBranchingContent : Dict String EmailData -> Dict String BranchingContent
emailsToBranchingContent data =
    Dict.map (\_ emailData -> Email emailData) data


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


getEmail : BranchingContent -> EmailData
getEmail data =
    case data of
        Email email ->
            email

        _ ->
            -- Not sure best way to handle this error.
            Content.emptyEmail



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
    List.map (\content -> ( ContentChoices.getBranchingChoiceChosen playerChoices content, content ))
        -- We want to process the messages in reverse for scoring
        (List.reverse contentList)



{-
   given a string like "macaques|50" , return int 50 if string == macaques
-}


getIntegerIfMatchFound : String -> String -> Int
getIntegerIfMatchFound scoreChangeValue choice =
    let
        ( changeValue, choiceMatch ) =
            ( case List.head (String.indexes "|" scoreChangeValue) of
                Nothing ->
                    0

                Just val ->
                    Maybe.withDefault 0 (String.toInt (String.dropLeft (val + 1) scoreChangeValue))
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
        0



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


updateScore : ScoreType -> Content.Datastore -> GameData -> String -> Int
updateScore scoreType datastore gamedata newChoice =
    let
        playerChoices =
            newChoice :: gamedata.choices

        messageDict =
            messagesToBranchingContent datastore.messages

        emailDict =
            emailsToBranchingContent datastore.emails

        -- get a list of the messages & emails that are being shown
        messages =
            filterBranchingContent (Dict.union messageDict emailDict) gamedata.choices
                |> Dict.values
                |> List.reverse

        mix =
            Debug.log "mixed" messages

        -- this variable ends up with a list of score changes based on each message's point in time, e.g.
        -- [18, -7, 0 ] for the message choices of start > macaques > stay
        listOfScoreChanges =
            choicesAndBranchingContent playerChoices messages
                |> List.map (\( choice, message ) -> getScoreChanges scoreType choice message)
    in
    -- take all of the score changes and add them together
    List.foldl (+) 0 listOfScoreChanges



{-
   This function produces a list of economic change values that match choices made for this message.
   so if you have a choice of 'macaque' and your scoreChangeEconomic is
       ["macaques|-7", "pigs|-3", "mice|-2", "fish|-4", "bio|-11"]
   it will return
       foldr (+) 0 [-7 , 0 , 0 , 0 , 0]
   == -7
-}


getScoreChanges : ScoreType -> String -> BranchingContent -> Int
getScoreChanges scoreType choice message =
    List.foldr (+) 0 (List.map (\scoreChangeValue -> getIntegerIfMatchFound scoreChangeValue choice) (getScoreChange scoreType message))


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
    in
    Maybe.withDefault [ "" ] maybeChange



-- same as updateScore, but can use = (set) values for scoring mechanics


updateSuccessScore : Content.Datastore -> GameData -> String -> Int
updateSuccessScore datastore gamedata newChoice =
    let
        playerChoices =
            newChoice :: gamedata.choices

        messages =
            List.reverse
                (Dict.values (filterBranchingContent (messagesToBranchingContent datastore.messages) gamedata.choices))

        listOfSuccessScoreChanges =
            List.map (\( choice, message ) -> getSuccessScoreChange choice message) (choicesAndBranchingContent playerChoices messages)
    in
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
        listOfSuccessScoreChanges



-- same as getEconomicScoreChange, but can use = (set) values for scoring mechanics


getSuccessScoreChange : String -> BranchingContent -> String
getSuccessScoreChange choice message =
    List.foldr (++) "" (List.map (\scoreChangeValue -> getStringIfMatchFound scoreChangeValue choice) (getScoreChange Success message))
