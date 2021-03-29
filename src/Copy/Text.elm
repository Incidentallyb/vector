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
            ""

        EndInfoSlug ->
            "thank-you"

        UploadPath ->
            "/images/uploads/"

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

        FinalScoreFeedbackPrompt ->
            "While AL analyses your proposal is there anything else you would like to tell us?"

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
                    "fir.png"

                "Hawthorne" ->
                    "hawthorne.png"

                "Juniper" ->
                    "juniper.png"

                "Lime" ->
                    "lime.png"

                "Maple" ->
                    "maple.png"

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

        SocialInputLabel ->
            "Post a tweeeet"

        SocialInputPost ->
            "Tweeeet"

        EndInfoHeader ->
            "Thank you for playing!"

        EndInfoParagraph1 ->
            "Vector and Biocore are fictional but based on research, conversations, observations and strategic decisions. Vector was produced by [The Lab Collective](https://www.thelabcollective.co.uk/) and [Bentley Crudgington](https://animalresearchnexus.org/people/bentley-crudgington) as part of the [Animal Research Nexus](https://animalresearchnexus.org) Public Engagement Programme."

        EndInfoParagraph2 ->
            "Our aim is to change how animal research is discussed. We want to replace for/against debates with more creative processes that support more nuanced empowering conversations, ones that encourage people to learn about their own views, the views of others and how those may change in unexpected ways."

        EndInfoParagraph3 ->
            "You can explore more [engagement activities](https://animalresearchnexus.org/public-engagement), play again, [talk to us](https://incidentallyb.typeform.com/to/DqyrGE9a), or share this with others."

        EndInfoParagraph4 ->
            "Coded collectively by Nick Wade, Kris Sum and Katja Mordaunt"

        FilterInputLabel ->
            "Add comma separated values (with spaces)"

        FilterInputPlaceholder ->
            "e.g. macaques, pigs"
