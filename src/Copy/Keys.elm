module Copy.Keys exposing (Key(..))


type Key
    = --- Site Meta
      SiteTitle
      --- Route Slugs
    | Navbar
    | DesktopSlug
    | DocumentsSlug
    | EmailsSlug
    | MessagesSlug
    | SocialSlug
    | IntroSlug
    | EndInfoSlug
    | PathCheckerSlug
    | UploadPath
      --- Intro page
    | StartNewGame
      --- Navigation text
    | NavDocuments
    | NavEmails
    | NavMessagesNeedAttention
    | NavMessages
    | NavSocial
      --- VideoUrls
    | IntroVideo1
    | IntroVideo2
    | VideoFromId String
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
