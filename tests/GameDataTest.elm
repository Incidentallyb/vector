module GameDataTest exposing (getStringIfMatchFound, updateAllScores, updateEconomicScore, updateHarmScore, updateSuccessScore)

import Expect
import GameData exposing (ScoreType(..))
import Test exposing (Test, describe, test)
import TestData


testGameData =
    TestData.testGamedata


initGameData =
    { choices = [ "init" ]
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }


startGameData =
    { choices = [ "start", "init" ]
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }


macaquesGameData =
    { choices = [ "macaques", "start", "init" ]
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }


changeGameData =
    { choices = [ "change", "macaques", "start", "init" ]
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }


getStringIfMatchFound : Test
getStringIfMatchFound =
    describe "getStringIfMatchFound Function"
        [ test "returns 0 for non matching values" <|
            \_ ->
                GameData.getStringIfMatchFound "macaque|50" "fish"
                    |> Expect.equal ""
        , test "returns 0 for non matching values (2)" <|
            \_ ->
                GameData.getStringIfMatchFound "macaque|50" "mice"
                    |> Expect.equal ""
        , test "returns 0 for non matching values (3)" <|
            \_ ->
                GameData.getStringIfMatchFound "" "fish"
                    |> Expect.equal ""
        , test "returns 0 for non matching values (4)" <|
            \_ ->
                GameData.getStringIfMatchFound "" ""
                    |> Expect.equal ""
        , test "returns value for matching values" <|
            \_ ->
                GameData.getStringIfMatchFound "macaque|50" "macaque"
                    |> Expect.equal "50"
        , test "returns value for matching values (2)" <|
            \_ ->
                GameData.getStringIfMatchFound "macaque|-40000" "macaque"
                    |> Expect.equal "-40000"
        ]


updateEconomicScore : Test
updateEconomicScore =
    describe "updateScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore testGameData "init"
                    |> Expect.equal 0
        , test "returns 18000000 for start" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore initGameData "start"
                    |> Expect.equal 18000000
        , test "returns 0 for non-start" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore initGameData "no-thanks"
                    |> Expect.equal 0
        , test "returns 11000000 for start->macaques" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore startGameData "macaques"
                    |> Expect.equal 11000000
        , test "returns 11000000 for start->macaques->stay" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore macaquesGameData "stay"
                    |> Expect.equal 11000000
        , test "returns 167500000 for start->macaques->change->mice" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore changeGameData "mice"
                    |> Expect.equal 16750000
        ]


updateSuccessScore : Test
updateSuccessScore =
    describe "updateSuccessScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore testGameData "init"
                    |> Expect.equal 0
        , test "returns 0 for start" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore initGameData "start"
                    |> Expect.equal 0
        , test "returns 0 for non-start" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore initGameData "no-thanks"
                    |> Expect.equal 0
        , test "returns 40% success for start->macaques" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore startGameData "macaques"
                    |> Expect.equal 40
        , test "returns bonus 5% for start->macaques->stay" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore macaquesGameData "stay"
                    |> Expect.equal 45
        , test "returns 30% (set value) for start->macaques->change->mice" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore changeGameData "mice"
                    |> Expect.equal 30
        , test "returns 50% (added value) for start->macaques->change->fish" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore changeGameData "fish"
                    |> Expect.equal 50
        ]


updateHarmScore : Test
updateHarmScore =
    describe "updateHarmScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore testGameData "init"
                    |> Expect.equal 0
        , test "returns 0 for start" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore initGameData "start"
                    |> Expect.equal 0
        , test "returns 0 for non-start" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore initGameData "no-thanks"
                    |> Expect.equal 0
        , test "returns 8 harm for start->macaques" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore startGameData "macaques"
                    |> Expect.equal 8
        , test "returns 8+1 harm for start->macaques->stay" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore macaquesGameData "stay"
                    |> Expect.equal 9
        , test "returns 3 (set value) for start->macaques->change->mice" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore changeGameData "mice"
                    |> Expect.equal 3
        , test "returns 2 for start->macaques->change->fish" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore changeGameData "fish"
                    |> Expect.equal 2
        ]


updateAllScores : Test
updateAllScores =
    describe "updateAllScores Function"
        [ test "Check data for start->macaques->change->fish" <|
            \_ ->
                { choices = "fish" :: changeGameData.choices
                , checkboxSet = changeGameData.checkboxSet
                , teamName = changeGameData.teamName
                , scoreSuccess = GameData.updateScore Success TestData.testDatastore changeGameData "fish"
                , scoreEconomic = GameData.updateScore Economic TestData.testDatastore changeGameData "fish"
                , scoreHarm = GameData.updateScore Harm TestData.testDatastore changeGameData "fish"
                }
                    |> Expect.equal
                        { choices = [ "fish", "change", "macaques", "start", "init" ]
                        , checkboxSet = changeGameData.checkboxSet
                        , teamName = "TestTeam"
                        , scoreSuccess = 50
                        , scoreEconomic = 17250000
                        , scoreHarm = 2
                        }
        ]
