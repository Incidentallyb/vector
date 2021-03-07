module Hashtag exposing (Hashtag(..), getHashtagsFromSocials, getScoreChanges)

import Content exposing (SocialData)
import Dict exposing (Dict)


type Hashtag
    = BiocoreEngage
    | BiocoreGlobal
    | BiocoreAdvance
    | BiocoreInvest
    | BiocoreReview


type alias HashtagData =
    { scoreChangeEconomic : Int
    , scoreChangeHarm : Int
    , scoreChangeSuccess : Int
    }


getHashtagsFromSocials : Dict String SocialData -> List Hashtag
getHashtagsFromSocials socials =
    [ BiocoreEngage ]


getScoreChanges : Hashtag -> HashtagData
getScoreChanges tag =
    case tag of
        BiocoreAdvance ->
            { scoreChangeEconomic = -2
            , scoreChangeHarm = 0
            , scoreChangeSuccess = 0
            }

        BiocoreEngage ->
            { scoreChangeEconomic = 0
            , scoreChangeHarm = 0
            , scoreChangeSuccess = 0
            }

        BiocoreGlobal ->
            { scoreChangeEconomic = 0
            , scoreChangeHarm = 0
            , scoreChangeSuccess = 0
            }

        BiocoreInvest ->
            { scoreChangeEconomic = 0
            , scoreChangeHarm = 0
            , scoreChangeSuccess = 0
            }

        BiocoreReview ->
            { scoreChangeEconomic = 0
            , scoreChangeHarm = 0
            , scoreChangeSuccess = 0
            }
