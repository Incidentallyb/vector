module Route exposing (Route(..), fromUrl, isDocumentRoute, isEmailRoute, toString)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Url
import Url.Parser as Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)


type Route
    = Desktop
    | Documents
    | Document String
    | Emails
    | Email Int
    | Messages
    | Social
    | Intro


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    { url | path = url.path }
        |> Parser.parse routeParser


toString : Route -> String
toString route =
    case route of
        Desktop ->
            "/" ++ t DesktopSlug

        Documents ->
            "/" ++ t DocumentsSlug

        Document id ->
            "/" ++ t DocumentsSlug ++ "/" ++ id

        Emails ->
            "/" ++ t EmailsSlug

        Email id ->
            "/" ++ t EmailsSlug ++ "/" ++ String.fromInt id

        Messages ->
            "/" ++ t MessagesSlug

        Social ->
            "/" ++ t SocialSlug

        Intro ->
            "/" ++ t IntroSlug


isDocumentRoute : Route -> Bool
isDocumentRoute pageRoute =
    case pageRoute of
        Documents ->
            True

        Document _ ->
            True

        _ ->
            False


isEmailRoute : Route -> Bool
isEmailRoute pageRoute =
    case pageRoute of
        Emails ->
            True

        Email _ ->
            True

        _ ->
            False



-- Internal helpers


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Desktop (s (t DesktopSlug))
        , map Documents (s (t DocumentsSlug))
        , map Document (s (t DocumentsSlug) </> string)
        , map Emails (s (t EmailsSlug))
        , map Email (s (t EmailsSlug) </> int)
        , map Messages (s (t MessagesSlug))
        , map Social (s (t SocialSlug))
        , map Intro (s (t IntroSlug))
        ]
