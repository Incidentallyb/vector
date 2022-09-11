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
        Navbar ->
            "BioCore"

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
            "intro"

        LandingSlug ->
            ""

        EndInfoSlug ->
            "thank-you"

        UploadPath ->
            "/images/uploads/"

        -- Document page
        WatchVideo ->
            "Watch Video"

        -- Intro page
        WatchIntro3Button ->
            "YOUR ASSIGNMENT"

        SkipIntro3VideoLink ->
            "JUMP RIGHT IN"

        StartNewGameLink ->
            "BEGIN ETHICAL REVIEW"

        NavDocuments ->
            "Documents"

        NavEmails ->
            "Emails"

        NavMessages ->
            "Messages"

        NavMessagesNeedAttention ->
            "Decisions need to be made"

        NavSocial ->
            "Tweeeeter"

        -- Messages
        FromPlayerTeam ->
            "Team "

        ReadyToReply ->
            "I'm ready to reply"

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

        EmailDummySentTime ->
            "Sent: Today"

        EmailReplyButton ->
            "Reply"

        EmailQuickReply ->
            "Send email quick-reply: "

        NeedsReply ->
            "Needs reply"

        TeamNames ->
            "Ash|Birch|Cedar|Elm|Fir|Hawthorn|Juniper|Lime|Maple|Oak"

        TeamLogo teamname ->
            case teamname of
                "Ash" ->
                    "ash.png"

                "Birch" ->
                    "birch.png"

                "Cedar" ->
                    "cedar.png"

                "Elm" ->
                    "elm.png"

                "Fir" ->
                    "fir.jpg"

                "Hawthorn" ->
                    "hawthorn.png"

                "Juniper" ->
                    "juniper.gif"

                "Lime" ->
                    "lime.png"

                "Maple" ->
                    "maple.jpg"

                "Oak" ->
                    "oak.png"

                _ ->
                    "leaf.png"

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

        FeedbackForm1Source ->
            "https://form.typeform.com/to/xHe8Bf3N"

        FeedbackForm2Source ->
            "https://form.typeform.com/to/yuQOdud5"

        FeedbackForm3Source ->
            "https://form.typeform.com/to/WEEJSvQN"

        FeedbackFormClose ->
            "Close"

        SubmitEndChoices ->
            "Submit choices"

        SocialInputLabel ->
            "Post a tweeeet"

        SocialInputPost ->
            "Tweeeet"

        -- End page
        EndInfoHeader ->
            "Thank you for playing!"

        EndInfoParagraph1 ->
            "Vector and BioCore are fictional but based on research, conversations, observations and strategic decisions. Vector was produced by [The Lab Collective](https://www.thelabcollective.co.uk/) and [Bentley Crudgington](https://animalresearchnexus.org/people/bentley-crudgington) as part of the [Animal Research Nexus](https://animalresearchnexus.org) Public Engagement Programme."

        EndInfoParagraph2 ->
            "Our aim is to change how animal research is discussed. We want to replace for/against debates with more creative processes that support more nuanced empowering conversations, ones that encourage people to learn about their own views, the views of others and how those may change in unexpected ways."

        EndInfoParagraph3 ->
            "You can explore more [engagement activities](https://animalresearchnexus.org/public-engagement), play again, [talk to us](https://incidentallyb.typeform.com/to/DqyrGE9a), or share this with others."

        EndInfoParagraph4 ->
            "Coded collectively by Nick Wade, Kris Sum and Katja Mordaunt"

        -- Landing page
        LandingParagraph ->
            "This game uses Google Analytics to improve your experience. By entering BioCore, you agree to Google Analytics cookies being placed on your device."

        LandingLinkText ->
            "ENTER BIOCORE"

        FilterInputLabel ->
            "Add comma separated values (with spaces)"

        FilterInputPlaceholder ->
            "e.g. macaques, pigs"
