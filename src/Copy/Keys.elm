module Copy.Keys exposing (Key(..))


type Key
    = --- Site Meta
      SiteTitle
      --- Route Slugs
    | DesktopSlug
    | DocumentsSlug
    | EmailsSlug
    | MessagesSlug
    | SocialSlug
    | IntroSlug
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
      --- Documents
    | ViewDocument
      --- Emails
    | EmailDummySentTime
    | EmailQuickReply
      --- TeamNames
    | TeamNames
