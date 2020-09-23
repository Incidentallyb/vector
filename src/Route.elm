module Route exposing (Route(..), fromUrl)

import Url
import Url.Parser as Parser exposing ((</>), Parser, int, map, oneOf, s, top)


type Route
    = Desktop
    | Documents
    | Document Int
    | Emails
    | Email Int
    | Messages
    | Tweets


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Desktop top
        , map Documents (s "documents")
        , map Document (s "documents" </> int)
        , map Emails (s "emails")
        , map Email (s "emails" </> int)
        , map Messages (s "messages")
        , map Tweets (s "tweets")
        ]


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    { url | path = url.path }
        |> Parser.parse routeParser
