module Video exposing (Video(..), embedUrlFromIdString, videoToIdString)


type Video
    = Intro1
    | Intro2
    | Intro3


videoToIdString video =
    case video of
        Intro1 ->
            "VB0y52wzNZU"

        Intro2 ->
            "rztd_BIXyUQ"

        Intro3 ->
            ""


embedUrlFromIdString : String -> String
embedUrlFromIdString id =
    String.join "/" [ "https://www.youtube.com/embed", id ]
