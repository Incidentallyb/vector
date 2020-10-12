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
      --- "Back to" area texts
    | NavDocumentsBackTo
    | NavEmailsBackTo
      --- General application texts
    | ItemNotFound
      --- Documents
    | ViewDocument
      --- Emails
    | EmailDummySentTime
    | EmailQuickReply
      --- TeamNames
    | TeamNames
