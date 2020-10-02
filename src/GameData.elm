module GameData exposing (GameData, filterEmails, filterMessages, getIntegerIfMatchFound, init, updateEconomicScore)

import Content exposing (EmailData, MessageData)
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


filterMessages : Dict String MessageData -> List String -> Dict String MessageData
filterMessages allMessages choices =
    Dict.filter (\_ value -> ContentChoices.triggeredByChoices choices value.triggered_by) allMessages


filterEmails : Dict String EmailData -> List String -> Dict String EmailData
filterEmails allEmails choices =
    Dict.filter (\_ value -> ContentChoices.triggeredByChoices choices value.triggered_by) allEmails



-- scoring functions


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
        -- [18000000, -7000000, 0 ] for the message choices of start > macaques > stay
        listOfEconomicScoreChanges =
            List.map (\( choice, message ) -> getEconomicScoreChange choice message) (choicesAndMessages playerChoices messages)

    in
    -- take all of the economic score changes and add them together
    List.foldl (+) 0 listOfEconomicScoreChanges


{-
    This function produces a list of tuples of choices chosen against their message, e.g.
    [ ("start", message1) ] , then on next choice it would be
    [ ("start", message1), ("macaques", message2) ]
-}


choicesAndMessages : List String -> List MessageData -> List (String, MessageData)
choicesAndMessages playerChoices messages =
    List.map (\message -> ( ContentChoices.getChoiceChosen playerChoices message, message )) messages

{-
   This function produces a list of eceonomic change values that match choices made for this message.
   so if you have a choice of 'macaque' and your scoreChangeEconomic is
       ["macaques|-7000000", "pigs|-3000000", "mice|-2000000", "fish|-4000000", "bio|-11000000"]
   it will return
       foldr (+) 0 [-7000000 , 0 , 0 , 0 , 0]
   == -7000000
-}


getEconomicScoreChange : String -> MessageData -> Int
getEconomicScoreChange choice message =
    let
        result =
            List.map (\scoreChangeValue -> getIntegerIfMatchFound scoreChangeValue choice) (Maybe.withDefault [ "" ] message.scoreChangeEconomic)
    in
    List.foldr (+) 0 result



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
