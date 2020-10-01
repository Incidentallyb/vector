module GameData exposing (GameData, filterEmails, filterMessages, init, updateEconomicScore)

import Content exposing (EmailData, MessageData)
import ContentChoices
import Debug
import Dict exposing (Dict)
import List.Extra
import Set


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


updateEconomicScore : Content.Datastore -> GameData -> String -> Int
updateEconomicScore datastore gamedata newChoice =
    let
        playerChoices =
            newChoice :: gamedata.choices

        -- get a list of the messages that are being shown
        messages =
            List.reverse
                (Dict.values (filterMessages datastore.messages gamedata.choices))

        -- a list of tuples of choices chosen against their message, e.g.
        -- [ ("start", message1) ] , then on next choice it would be
        -- [ ("start", message1), ("macaques", message2) ]
        economicScoreChanges =
            List.map (\message -> ( ContentChoices.getChoiceChosen playerChoices message, message )) messages

        -- this variable ends up with a list of score changes based on each message's point in time, e.g.
        -- [18000000, -7000000, 0 ] for the message choices of start > macaques > stay
        listOfEconomicScoreChanges =
            List.map (\( choice, message ) -> getEconomicScoreChange choice message) economicScoreChanges

        --debugger2 =
        --    Debug.log "applyEconomicScoreChange " (Debug.toString applyEconomicScoreChange)
        -- debugger =
        --    Debug.log "Messages " (Debug.toString economicScoreChanges)
    in
    -- take all of the economic score changes and add them together
    List.foldl (+) 0 listOfEconomicScoreChanges



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
            List.map
                (\scoreChangeValue ->
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

                        --debug =
                        --    Debug.log "getEconomicScoreChange " (Debug.toString (changeValue, choiceMatch, choice))
                    in
                    if choiceMatch == choice then
                        changeValue

                    else
                        0
                )
                -- ["macaques|-7000000", "pigs|-7000000", "mice|-7000000", "fish|-7000000", "bio|-7000000"]
                (Maybe.withDefault [ "" ] message.scoreChangeEconomic)

        --debug2 =
        --    Debug.log "getEconomicScoreChange result " (Debug.toString result)
    in
    List.foldr (+) 0 result
