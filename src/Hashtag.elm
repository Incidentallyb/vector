module Hashtag exposing (Hashtag(..), getHashtagsFromSocials, getScoreChanges)

import Content exposing (SocialData)
import Dict exposing (Dict)
import Set


type Hashtag
    = BiocoreEngage
    | BiocoreGlobal
    | BiocoreAdvance
    | BiocoreInvest
    | BiocoreReview
    | NonScoringHashtag


type alias HashtagData =
    { scoreChangeEconomic : Int
    , scoreChangeHarm : Int
    , scoreChangeSuccess : Int
    }


scoringHashtags : List String
scoringHashtags =
    [ "BiocoreAdvance"
    , "BiocoreEngage"
    , "BiocoreGlobal"
    , "BiocoreInvest"
    , "BiocoreReview"
    ]


hashtagFromString : String -> Hashtag
hashtagFromString tag =
    case tag of
        "#BiocoreAdvance" ->
            BiocoreAdvance

        "#BiocoreEngage" ->
            BiocoreEngage

        "#BiocoreGlobal" ->
            BiocoreGlobal

        "#BiocoreInvest" ->
            BiocoreInvest

        "#BiocoreReview" ->
            BiocoreReview

        _ ->
            NonScoringHashtag


hashtagToString : Hashtag -> String
hashtagToString tag =
    case tag of
        BiocoreAdvance ->
            "BiocoreAdvance"

        BiocoreEngage ->
            "BiocoreEngage"

        BiocoreGlobal ->
            "BiocoreGlobal"

        BiocoreInvest ->
            "BiocoreInvest"

        BiocoreReview ->
            "BiocoreReview"

        _ ->
            "NonScoringHashtag"


getHashtagsFromSocials : Dict String SocialData -> List Hashtag
getHashtagsFromSocials socials =
    let
        socialTextList =
            List.map (\social -> social.content) (Dict.values socials)

        getHashtags =
            List.map hashtagFromContent socialTextList

        hashtagsUsed =
            List.filter
                (\tag ->
                    if tag == NonScoringHashtag then
                        False

                    else
                        True
                )
                (List.concat getHashtags)
                |> List.map (\tag -> hashtagToString tag)
                |> Set.fromList
    in
    List.map (\tag -> hashtagFromString tag) (Set.toList hashtagsUsed)


hashtagFromContent : String -> List Hashtag
hashtagFromContent content =
    List.map
        (\tag ->
            if String.contains tag content then
                hashtagFromString ("#" ++ tag)

            else
                NonScoringHashtag
        )
        scoringHashtags


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

        NonScoringHashtag ->
            { scoreChangeEconomic = 0
            , scoreChangeHarm = 0
            , scoreChangeSuccess = 0
            }
