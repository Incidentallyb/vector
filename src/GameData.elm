module GameData exposing (GameData, filterMessages, init)

import Content exposing (MessageData)
import Dict exposing (Dict)


type alias GameData =
    { choices : List String
    , teamName : String
    }


init : GameData
init =
    { choices = []
    , teamName = "?"
    }



-- Process choices into a staged list of choice strings to match triggers
-- e.g. ["start", "macaques", "stay"] becomes ["start", "start|macaques", "start|macaques|stay"]


choiceStepsList : List String -> List String
choiceStepsList currentChoices =
    [ String.join "|" (List.reverse currentChoices) ]


triggeredByChoices : List String -> List String -> Bool
triggeredByChoices currentChoices triggeredByList =
    choiceStepsList currentChoices
        |> List.map (\choices -> List.member choices triggeredByList)
        |> List.member True


filterMessages : Dict String MessageData -> List String -> Dict String MessageData
filterMessages allMessages choices =
    Dict.filter (\_ value -> triggeredByChoices choices value.triggered_by) allMessages
