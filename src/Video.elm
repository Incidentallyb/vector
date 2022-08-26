module Video exposing (Video(..), embedUrlFromIdString, videoToData)


type Video
    = Landing
    | Intro1
    | Intro2
    | Intro3


videoToData : Video -> { id : String, title : String }
videoToData video =
    case video of
        Landing ->
            { id = "oWzsFH4LLME", title = "Let’s get started - YouTube" }

        Intro1 ->
            { id = "VB0y52wzNZU", title = "" }

        Intro2 ->
            { id = "rztd_BIXyUQ", title = "" }

        Intro3 ->
            { id = "", title = "" }


embedUrlFromIdString : String -> String
embedUrlFromIdString id =
    String.join "/" [ "https://www.youtube.com/embed", id ]
