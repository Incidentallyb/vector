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
            { id = "mvo5p86uYNc", title = "Welcome to Biocore - YouTube" }

        Intro2 ->
            { id = "zDvg0tnHc0Q", title = "Protocol - YouTube" }

        Intro3 ->
            { id = "qCv6EkEG5sQ", title = "Next Steps - YouTube" }


embedUrlFromIdString : String -> String
embedUrlFromIdString id =
    String.join "/" [ "https://www.youtube.com/embed", id ]
