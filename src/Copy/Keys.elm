module Copy.Keys exposing (Key(..))


type Key
    = --- Site Meta
      SiteTitle
    | DesktopTitle
    | DocumentsTitle
    | DocumentTitle String
    | EmailsTitle
    | EmailTitle String
    | MessagesTitle
    | SocialTitle
    | IntroTitle
    | LandingTitle
    | EndInfoTitle
    | PathCheckerTitle
      --- Route Slugs
    | Navbar
    | CloseAudio
    | OpenAudio
    | DesktopSlug
    | DocumentsSlug
    | EmailsSlug
    | MessagesSlug
    | SocialSlug
    | IntroSlug
    | LandingSlug
    | EndInfoSlug
    | PathCheckerSlug
    | UploadPath
      --- Landing page
    | LandingFictionAlert
    | LandingParagraph
    | LandingLinkText
      --- Intro page
    | WatchIntro2Button
    | SkipIntro2VideoLink
    | StartNewGameLink
      --- Navigation text
    | NavDocuments
    | NavEmails
    | NavMessagesNeedAttention
    | NavMessages
    | NavSocial
      -- Documents
    | WatchVideo
    | VideoSummary
      --- Messages
    | FromPlayerTeam
    | ReadyToReply
    | WellDone
    | Results
      --- "Back to" area texts
    | NavDocumentsBackTo
    | NavEmailsBackTo
      --- General application texts
    | ItemNotFound
    | New
      --- Desktop
    | DesktopWelcome
    | DesktopParagraph1
    | DesktopParagraph2
    | DesktopParagraph3
    | DesktopParagraph4
      --- Feedback Forms
    | FeedbackForm1Source
    | FeedbackForm2Source
    | FeedbackForm3Source
    | FeedbackFormClose
    | SubmitEndChoices
      --- Emails
    | EmailDummySentTime
    | EmailReplyButton
    | EmailQuickReply
    | NeedsReply
      --- Social
    | SocialInputLabel
    | SocialInputPost
      --- Ending info
    | EndInfoHeader
    | EndInfoParagraph1
    | EndInfoParagraph2
    | EndInfoParagraph3
    | EndInfoParagraph4
      --- TeamNames
    | TeamNames
    | TeamLogo String
      --- Path Checker
    | FilterInputLabel
    | FilterInputPlaceholder
