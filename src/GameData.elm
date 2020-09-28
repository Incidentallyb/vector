module GameData exposing (GameData, filterMessages, init, updateSuccessScore, updateEconomicScore)

import Content exposing (MessageData)
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
    -- Start button on intro screen will eventually set this "init"
    { choices = [ ]
    , teamName = "?"
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }


triggeredByChoices : String -> List String -> Bool
triggeredByChoices currentChoices triggeredByList =
    List.member currentChoices triggeredByList


filterMessages : Dict String MessageData -> List String -> Dict String MessageData
filterMessages allMessages choices =
    let
        choiceString =
            -- The game data choices get added to head of list, we want to match that in reverse.
            String.join "|" (List.reverse choices)
    in
    Dict.filter (\key value -> triggeredByChoices choiceString value.triggered_by) allMessages


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