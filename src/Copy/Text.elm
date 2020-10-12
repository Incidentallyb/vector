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
            ""

        -- Intro page
        StartNewGame ->
            "Start New Game"

        IntroVideo ->
            "https://www.youtube.com/embed/mRRMSFHPWJU"

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
            "Team "

        NavDocumentsBackTo ->
            "Back to Documents"

        ItemNotFound ->
            "Item not found"

        ViewDocument ->
            "View Document"

        EmailDummySentTime ->
            "Sent: Today"

        TeamNames ->
            "Ash, Birch, Cedar, Elm, Fir, Hawthorn, Juniper, Lime, Maple, Oak"
