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
            "desktop"

        DocumentsSlug ->
            "documents"

        EmailsSlug ->
            "emails"

        MessagesSlug ->
            "messages"

        SocialSlug ->
            "social-media"

        IntroSlug ->
            "intro"

        -- Intro page
        StartNewGame ->
            "Start New Game"

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

        NavDocumentsBackTo ->
            "Back to Documents"

        ItemNotFound ->
            "Item not found"

        ViewDocument ->
            "View Document"

        EmailDummySentTime -> 
            "Sent: Today"