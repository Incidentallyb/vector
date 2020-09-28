module GameData exposing (GameData, filterMessages, init)

import Content exposing (MessageData)
import Dict exposing (Dict)


type alias GameData =
    { choices : List String }


init : GameData
init =
    { choices = [] }



-- Process choices into a staged list of choice strings to match triggers
-- e.g. ["start", "macaques", "stay"] becomes ["start", "start|macaques", "start|macaques|stay"]


choiceStepsList : List String -> List String
choiceStepsList currentChoices =
    [ String.join "|" (List.reverse currentChoices) ]


stripInitChoice : String -> String
stripInitChoice choices =
    -- "init" only for the initial content after that all trigger strings start with "start"
    String.replace "init|" "" choices


triggeredByChoices : List String -> List String -> Bool
triggeredByChoices currentChoices triggeredByList =
    choiceStepsList currentChoices
        |> List.map (\choices -> List.member (stripInitChoice choices) triggeredByList)
        |> List.member True


filterMessages : Dict String MessageData -> List String -> Dict String MessageData
filterMessages allMessages choices =
    Dict.filter (\_ value -> triggeredByChoices choices value.triggered_by) allMessages
