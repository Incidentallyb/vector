module GameData exposing (GameData, init)


type alias GameData =
    { choices : List String }


init : GameData
init =
    { choices = [] }
