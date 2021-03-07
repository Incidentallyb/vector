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
            { scoreChangeEconomic = -8
            , scoreChangeHarm = 5
            , scoreChangeSuccess = -20
            }

        BiocoreEngage ->
            { scoreChangeEconomic = -3 --2.5
            , scoreChangeHarm = -2
            , scoreChangeSuccess = 0
            }

        BiocoreGlobal ->
            { scoreChangeEconomic = -8
            , scoreChangeHarm = 5
            , scoreChangeSuccess = 23
            }

        BiocoreInvest ->
            { scoreChangeEconomic = 5
            , scoreChangeHarm = 0
            , scoreChangeSuccess = 10
            }

        BiocoreReview ->
            { scoreChangeEconomic = -1 --0.5
            , scoreChangeHarm = -3
            , scoreChangeSuccess = -15
            }
