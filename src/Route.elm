module Route exposing (Route(..), fromUrl, toString)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Url
import Url.Parser as Parser exposing ((</>), Parser, int, map, oneOf, s, top)


type Route
    = Desktop
    | Documents
    | Document Int
    | Emails
    | Email Int
    | Messages
    | Social


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    { url | path = url.path }
        |> Parser.parse routeParser


toString : Route -> String
toString route =
    case route of
        Desktop ->
            t DesktopSlug

        Documents ->
            t DocumentsSlug

        Document id ->
            t DocumentsSlug ++ "/" ++ String.fromInt id

        Emails ->
            t EmailsSlug

        Email id ->
            t EmailsSlug ++ "/" ++ String.fromInt id

        Messages ->
            t MessagesSlug

        Social ->
            t SocialSlug



-- Internal helpers


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Desktop top
        , map Documents (s (t DocumentsSlug))
        , map Document (s (t DocumentsSlug) </> int)
        , map Emails (s (t EmailsSlug))
        , map Email (s (t EmailsSlug) </> int)
        , map Messages (s (t MessagesSlug))
        , map Social (s (t SocialSlug))
        ]