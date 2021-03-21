module HashtagTest exposing (updateEconomicScore, updateEconomicScoreWithDuplicate, updateHarmScore, updateHarmScoreWithDuplicate, updateSuccessScore, updateSuccessScoreWithDuplicate)

import Content exposing (SocialData)
import Dict
import Expect
import GameData exposing (GameData, ScoreType(..))
import Set
import Test exposing (Test, describe, test)
import TestData


testGameData : GameData
testGameData =
    TestData.testGamedata


hashtagGameData : GameData
hashtagGameData =
    { choices = []
    , choicesVisited = Set.empty
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    , socialsPosted =
        Dict.fromList
            [ ( "hashtagSocial1"
              , testSocialWithHashtag
              )
            ]
    }


hashtagGameDataWithDuplicate : GameData
hashtagGameDataWithDuplicate =
    { hashtagGameData
        | socialsPosted =
            Dict.fromList
                [ ( "hashtagSocial1"
                  , testSocialWithHashtag
                  )
                , ( "hashtagSocial2"
                  , testSocialWithDuplicateHashtag
                  )
                ]
    }


testSocialWithHashtag : SocialData
testSocialWithHashtag =
    { triggered_by = []
    , author = "Test Author"
    , handle = "@testauthor"
    , content = "Test social content #BioCOreAdvANce yes! #biocoreEngage"
    , image = Nothing
    , basename = "testSocialWithHashtag"
    , numComments = 10
    , numRetweets = 5
    , numLoves = 2
    }


testSocialWithDuplicateHashtag : SocialData
testSocialWithDuplicateHashtag =
    { triggered_by = []
    , author = "Test Author"
    , handle = "@testauthor"
    , content = "Test social content #BioCOreAdvANce yes!"
    , image = Nothing
    , basename = "testSocialWithDuplicateHashtag"
    , numComments = 10
    , numRetweets = 5
    , numLoves = 2
    }


updateEconomicScore : Test
updateEconomicScore =
    describe "updateScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore hashtagGameData.socialsPosted hashtagGameData.choices "init"
                    |> Expect.equal (-8 + -3)

        --Advance & Engage hashtags
        ]


updateSuccessScore : Test
updateSuccessScore =
    describe "updateSuccessScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore hashtagGameData.socialsPosted hashtagGameData.choices "init"
                    |> Expect.equal (-20 + 0)

        -- Advance & Engage hashtags
        ]


updateHarmScore : Test
updateHarmScore =
    describe "updateHarmScore with duplicate hashtag Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore hashtagGameData.socialsPosted hashtagGameData.choices "init"
                    |> Expect.equal (-2 + 5)

        -- Advance & Engage hashtags
        ]


updateEconomicScoreWithDuplicate : Test
updateEconomicScoreWithDuplicate =
    describe "updateScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore hashtagGameDataWithDuplicate.socialsPosted hashtagGameDataWithDuplicate.choices "init"
                    |> Expect.equal (-8 + -3)

        -- 2x Advance & Engage hashtags
        ]


updateSuccessScoreWithDuplicate : Test
updateSuccessScoreWithDuplicate =
    describe "updateSuccessScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore hashtagGameDataWithDuplicate.socialsPosted hashtagGameDataWithDuplicate.choices "init"
                    |> Expect.equal (-20 + 0)

        -- 2x Advance & Engage hashtags
        ]


updateHarmScoreWithDuplicate : Test
updateHarmScoreWithDuplicate =
    describe "updateHarmScore with duplicate hashtag Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore hashtagGameDataWithDuplicate.socialsPosted hashtagGameDataWithDuplicate.choices "init"
                    |> Expect.equal (-2 + 5)

        -- 2x Advance & Engage hashtags
        ]
