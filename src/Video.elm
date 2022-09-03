module Video exposing (Video(..), embedUrlFromIdString, videoToData)


type Video
    = Landing
    | Intro1
    | Intro2
    | Intro3
    | EndMessage


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

        EndMessage ->
            { id = "5jG7032_r7g", title = "Thank You - YouTube" }


embedUrlFromIdString : String -> String
embedUrlFromIdString id =
    String.join "/" [ "https://www.youtube.com/embed", id ]
