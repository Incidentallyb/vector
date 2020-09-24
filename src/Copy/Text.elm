module Copy.Text exposing (t)

import Copy.Keys exposing (Key(..))



-- The translate function


t : Key -> String
t key =
    case key of
        -- Meta
        SiteTitle ->
            "Vector App"

        -- Slugs
        DesktopSlug ->
            ""

        DocumentsSlug ->
            "documents"

        EmailsSlug ->
            "emails"

        MessagesSlug ->
            "messages"

        SocialSlug ->
            "social-media"

        NavDocuments ->
            "Documents"

        NavEmails ->
            "Emails"

        NavMessages ->
            "Messages"

        NavSocial ->
            "Tweeeeter"

        FromAL ->
            "AL @ Biocore"

        FromPlayerTeam ->
            "Team Elm"
