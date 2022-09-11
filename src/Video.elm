module Video exposing (Video(..), embedUrlFromIdString, videoToData)


type Video
    = Landing
    | Intro1
    | Intro2
    | EndMessage


videoToData : Video -> { id : String, title : String }
videoToData video =
    case video of
        Landing ->
            { id = "oWzsFH4LLME", title = "Let’s get started - YouTube" }

        Intro1 ->
            { id = "mvo5p86uYNc", title = "Welcome to Biocore - YouTube" }

        Intro2 ->
            { id = "qCv6EkEG5sQ", title = "Next Steps - YouTube" }

        EndMessage ->
            { id = "5jG7032_r7g", title = "Thank You - YouTube" }


embedUrlFromIdString : String -> String
embedUrlFromIdString id =
    String.join "/" [ "https://www.youtube.com/embed", id ]
