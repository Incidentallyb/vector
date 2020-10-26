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
      --- Intro page
    | StartNewGame
    | IntroVideo
      --- Navigation text
    | NavDocuments
    | NavEmails
    | NavMessages
    | NavSocial
      --- Messages
    | FromAL
    | FromPlayerTeam
    | WellDone
    | Results
      --- "Back to" area texts
    | NavDocumentsBackTo
    | NavEmailsBackTo
      --- General application texts
    | ItemNotFound
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
