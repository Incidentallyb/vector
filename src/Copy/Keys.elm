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
      --- General application texts
    | ItemNotFound
      --- Documents
    | ViewDocument
