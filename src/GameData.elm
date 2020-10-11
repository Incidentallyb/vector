module GameData exposing (GameData, filterEmails, filterMessages, filterSocials, getIntegerIfMatchFound, init, updateEconomicScore, updateHarmScore, updateSuccessScore)

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


filterBranchingContent : Dict String BranchingContent -> List String -> Dict String BranchingContent
filterBranchingContent content choices =
    ContentChoices.triggeredBranchingContentByChoice choices content


filterMessages : Dict String MessageData -> List String -> Dict String MessageData
filterMessages allMessages choices =
    ContentChoices.triggeredMessagesByChoice choices allMessages


filterEmails : Dict String EmailData -> List String -> Dict String EmailData
filterEmails allEmails choices =
    ContentChoices.triggeredEmailsByChoice choices allEmails


filterSocials : Dict String SocialData -> List String -> Dict String SocialData
filterSocials allSocials choices =
    ContentChoices.triggeredSocialsByChoice choices allSocials



-- Scoring functions
{-
   This function produces a list of tuples of choices chosen against their message, e.g.
   [ ("start", message1) ] , then on next choice it would be
   [ ("start", message1), ("macaques", message2) ]
-}


choicesAndMessages : List String -> List MessageData -> List ( String, MessageData )
choicesAndMessages playerChoices messages =
    List.map (\message -> ( ContentChoices.getChoiceChosen playerChoices message, message ))
        -- We want to process the messages in reverse for scoring
        -- We will also need to include emails
        (List.reverse messages)



-- given a string like "macaques|50" , return int 50 if string == macaques


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

   This allows our scoreChange options to be both delta modifiers (+/-) or be prefixed with a = if we want to SET a value.
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


updateEconomicScore : Content.Datastore -> GameData -> String -> Int
updateEconomicScore datastore gamedata newChoice =
    let
        playerChoices =
            newChoice :: gamedata.choices

        -- get a list of the messages that are being shown
        messages =
            List.reverse
                (Dict.values (filterMessages datastore.messages gamedata.choices))

        -- this variable ends up with a list of score changes based on each message's point in time, e.g.
        -- [18, -7, 0 ] for the message choices of start > macaques > stay
        listOfEconomicScoreChanges =
            List.map (\( choice, message ) -> getEconomicScoreChange choice message) (choicesAndMessages playerChoices messages)
    in
    -- take all of the economic score changes and add them together
    List.foldl (+) 0 listOfEconomicScoreChanges



{-
   This function produces a list of economic change values that match choices made for this message.
   so if you have a choice of 'macaque' and your scoreChangeEconomic is
       ["macaques|-7", "pigs|-3", "mice|-2", "fish|-4", "bio|-11"]
   it will return
       foldr (+) 0 [-7 , 0 , 0 , 0 , 0]
   == -7
-}


getEconomicScoreChange : String -> MessageData -> Int
getEconomicScoreChange choice message =
    List.foldr (+) 0 (List.map (\scoreChangeValue -> getIntegerIfMatchFound scoreChangeValue choice) (Maybe.withDefault [ "" ] message.scoreChangeEconomic))



-- Same as updateEconomicScore


updateHarmScore : Content.Datastore -> GameData -> String -> Int
updateHarmScore datastore gamedata newChoice =
    let
        playerChoices =
            newChoice :: gamedata.choices

        messages =
            List.reverse
                (Dict.values (filterMessages datastore.messages gamedata.choices))

        listOfHarmScoreChanges =
            List.map (\( choice, message ) -> getHarmScoreChange choice message) (choicesAndMessages playerChoices messages)
    in
    List.foldl (+) 0 listOfHarmScoreChanges



-- Same as getEconomicScoreChange


getHarmScoreChange : String -> MessageData -> Int
getHarmScoreChange choice message =
    List.foldr (+) 0 (List.map (\scoreChangeValue -> getIntegerIfMatchFound scoreChangeValue choice) (Maybe.withDefault [ "" ] message.scoreChangeHarm))



-- same as updateEconomicScore, but can use = (set) values for scoring mechanics


updateSuccessScore : Content.Datastore -> GameData -> String -> Int
updateSuccessScore datastore gamedata newChoice =
    let
        playerChoices =
            newChoice :: gamedata.choices

        messages =
            List.reverse
                (Dict.values (filterMessages datastore.messages gamedata.choices))

        listOfSuccessScoreChanges =
            List.map (\( choice, message ) -> getSuccessScoreChange choice message) (choicesAndMessages playerChoices messages)
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


getSuccessScoreChange : String -> MessageData -> String
getSuccessScoreChange choice message =
    List.foldr (++) "" (List.map (\scoreChangeValue -> getStringIfMatchFound scoreChangeValue choice) (Maybe.withDefault [ "" ] message.scoreChangeSuccess))
