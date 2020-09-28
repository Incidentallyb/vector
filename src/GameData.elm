module GameData exposing (GameData, filterEmails, filterMessages, init)

import Content exposing (EmailData, MessageData)
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
