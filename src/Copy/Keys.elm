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
      --- Navigation text
    | NavDocuments
    | NavEmails
    | NavMessages
    | NavSocial
      --- Messages
    | FromAL
    | FromPlayerTeam
