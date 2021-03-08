module HashtagTest exposing (updateEconomicScore, updateHarmScore, updateSuccessScore)

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


testSocialWithHashtag : SocialData
testSocialWithHashtag =
    { triggered_by = []
    , author = "Test Author"
    , handle = "@testauthor"
    , content = "Test social content #BiocoreAdvance yes! #BiocoreEngage"
    , image = Nothing
    , basename = "testSocialWithHashtag"
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
    describe "updateHarmScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore hashtagGameData.socialsPosted hashtagGameData.choices "init"
                    |> Expect.equal (-2 + 5)

        -- Advance & Engage hashtags
        ]
