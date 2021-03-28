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
    | IntroVideo
      --- Navigation text
    | NavDocuments
    | NavEmails
    | NavMessagesNeedAttention
    | NavMessages
    | NavSocial
      --- Messages
    | FromPlayerTeam
    | ReadyToReply
    | WellDone
    | Results
    | FinalScoreFeedbackPrompt
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
      --- Documents
    | ViewDocument
      --- Emails
    | EmailDummySentTime
    | EmailReplyButton
    | EmailQuickReply
    | NeedsReply
      --- Social
    | SocialInputLabel
    | SocialInputPost
      --- TeamNames
    | TeamNames
    | TeamLogo String
      --- Path Checker
    | FilterInputLabel
    | FilterInputPlaceholder
