module GameData exposing (GameData, init)


type alias GameData =
    { choices : List String
    , teamName: String }


init : GameData
init =
    { choices = [],
    teamName = "?" }
