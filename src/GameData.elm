module GameData exposing (GameData, filterEmails, filterMessages, init, updateSuccessScore, updateEconomicScore)

import Content exposing (EmailData, MessageData)
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
    { choices = [ ]
    , teamName = "?"
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }


-- Public filter functions, might become one


filterMessages : Dict String MessageData -> List String -> Dict String MessageData
filterMessages allMessages choices =
    Dict.filter (\_ value -> triggeredByChoices choices value.triggered_by) allMessages


filterEmails : Dict String EmailData -> List String -> Dict String EmailData
filterEmails allEmails choices =
    Dict.filter (\_ value -> triggeredByChoices choices value.triggered_by) allEmails



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


triggeredByChoices : List String -> List String -> Bool
triggeredByChoices currentChoices triggeredByList =
    choiceStepsList currentChoices
        |> List.map (\choices -> List.member choices triggeredByList)
        |> List.member True


applySuccessScore: Int -> List Content.MessageData -> Int
applySuccessScore initialScore messages = 
    List.foldl (+) initialScore (List.map (\record -> Maybe.withDefault 0 record.scoreChangeSuccess) messages)
    
updateSuccessScore: Content.Datastore -> List String -> Int -> Int
updateSuccessScore datastore choices initialScore = 
    applySuccessScore initialScore (Dict.values (filterMessages datastore.messages choices))

applyEconomicScore: Int -> List Content.MessageData -> Int
applyEconomicScore initialScore messages = 
    List.foldl (+) initialScore (List.map (\record -> Maybe.withDefault 0 record.scoreChangeEconomic) messages)

updateEconomicScore: Content.Datastore -> List String -> Int -> Int
updateEconomicScore datastore choices initialScore = 
    applyEconomicScore initialScore (Dict.values (filterMessages datastore.messages choices))
