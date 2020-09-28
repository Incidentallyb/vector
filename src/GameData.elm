module GameData exposing (GameData, filterMessages, init)

import Content exposing (MessageData)
import Dict exposing (Dict)


type alias GameData =
    { choices : List String }


init : GameData
init =
    { choices = [] }


triggeredByChoices : String -> List String -> Bool
triggeredByChoices currentChoices triggeredByList =
    List.member currentChoices triggeredByList


filterMessages : Dict String MessageData -> List String -> Dict String MessageData
filterMessages allMessages choices =
    let
        choiceString =
            String.join "|" choices
    in
    Dict.filter (\key value -> triggeredByChoices choiceString value.triggered_by) allMessages
