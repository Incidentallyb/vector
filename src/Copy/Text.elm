module Copy.Text exposing (t)

import Copy.Keys exposing (Key(..))



-- The translate function


t : Key -> String
t key =
    case key of
        -- Meta
        SiteTitle ->
            "Welcome to BioCore"

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

        PathCheckerSlug ->
            "path-check"

        IntroSlug ->
            ""

        -- Intro page
        StartNewGame ->
            "Begin Ethical Review"

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

        -- Messages
        FromPlayerTeam ->
            "Team "

        WellDone ->
            "Well done Team "

        Results ->
            "Your choices have produced the following results:"

        NavDocumentsBackTo ->
            "Back to Documents"

        NavEmailsBackTo ->
            "Back to Emails"

        ItemNotFound ->
            "Item not found"

        New ->
            "NEW"

        ViewDocument ->
            "View Document"

        EmailDummySentTime ->
            "Sent: Today"

        EmailQuickReply ->
            "Email quick-reply: "

        TeamNames ->
            "Ash, Birch, Cedar, Elm, Fir, Hawthorn, Juniper, Lime, Maple, Oak"

        DesktopWelcome ->
            "Welcome to BioCore!"

        DesktopParagraph1 ->
            "Your participation is important to us!"

        DesktopParagraph2 ->
            "I am AL, BioCore’s ethical interface for public consultation."

        DesktopParagraph3 ->
            "I have been designed to help facilitate your decision making. I collect and share information between the public and our specialists. I monitor all BioCore communications channels and can share information via the document store, email, or social media. I will alert you to new information in real time, please watch out for red icons appearing on the menu. Decision buttons appear in blue, simply tap to continue."

        DesktopParagraph4 ->
            "I have sent you an outline of our vaccine development protocol for you to review. Please check the document store."
