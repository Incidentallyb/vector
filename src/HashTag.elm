module HashTag exposing (HashTag(..))


type HashTag
    = BiocoreEngage
    | BiocoreGlobal
    | BiocoreAdvance
    | BiocoreInvest
    | BiocoreReview


type alias HashTagData =
    { scoreChangeEconomic : Int
    , scoreChangeHarm : Int
    , scoreChangeSuccess : Int
    }


getScoreChanges : HashTag -> HashTagData
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
