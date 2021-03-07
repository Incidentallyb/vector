module GameDataTest exposing (getStringIfMatchFound, updateAllScores, updateEconomicScore, updateHarmScore, updateSuccessScore)

import Dict
import Expect
import GameData exposing (GameData, ScoreType(..))
import Set
import Test exposing (Test, describe, test)
import TestData


testGameData : GameData
testGameData =
    TestData.testGamedata


initGameData : GameData
initGameData =
    { choices = [ "init" ]
    , choicesVisited = Set.empty
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    , peepsPosted = Dict.empty
    }


startGameData : GameData
startGameData =
    { choices = [ "start", "init" ]
    , choicesVisited = Set.empty
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    , peepsPosted = Dict.empty
    }


macaquesGameData : GameData
macaquesGameData =
    { choices = [ "macaques", "start", "init" ]
    , choicesVisited = Set.empty
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    , peepsPosted = Dict.empty
    }


changeGameData : GameData
changeGameData =
    { choices = [ "change", "macaques", "start", "init" ]
    , choicesVisited = Set.empty
    , checkboxSet = testGameData.checkboxSet
    , teamName = testGameData.teamName
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    , peepsPosted = Dict.empty
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
                GameData.updateScore Economic TestData.testDatastore Dict.empty testGameData.choices "init"
                    |> Expect.equal 0
        , test "returns 18000000 for start" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore Dict.empty initGameData.choices "start"
                    |> Expect.equal 18000000
        , test "returns 0 for non-start" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore Dict.empty initGameData.choices "no-thanks"
                    |> Expect.equal 0
        , test "returns 11000000 for start->macaques" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore Dict.empty startGameData.choices "macaques"
                    |> Expect.equal 11000000
        , test "returns 11000000 for start->macaques->stay" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore Dict.empty macaquesGameData.choices "stay"
                    |> Expect.equal 11000000
        , test "returns 167500000 for start->macaques->change->mice" <|
            \_ ->
                GameData.updateScore Economic TestData.testDatastore Dict.empty changeGameData.choices "mice"
                    |> Expect.equal 16750000
        ]


updateSuccessScore : Test
updateSuccessScore =
    describe "updateSuccessScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore Dict.empty testGameData.choices "init"
                    |> Expect.equal 0
        , test "returns 0 for start" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore Dict.empty initGameData.choices "start"
                    |> Expect.equal 0
        , test "returns 0 for non-start" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore Dict.empty initGameData.choices "no-thanks"
                    |> Expect.equal 0
        , test "returns 40% success for start->macaques" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore Dict.empty startGameData.choices "macaques"
                    |> Expect.equal 40
        , test "returns bonus 5% for start->macaques->stay" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore Dict.empty macaquesGameData.choices "stay"
                    |> Expect.equal 45
        , test "returns 30% (set value) for start->macaques->change->mice" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore Dict.empty changeGameData.choices "mice"
                    |> Expect.equal 30
        , test "returns 50% (added value) for start->macaques->change->fish" <|
            \_ ->
                GameData.updateScore Success TestData.testDatastore Dict.empty changeGameData.choices "fish"
                    |> Expect.equal 50
        ]


updateHarmScore : Test
updateHarmScore =
    describe "updateHarmScore Function"
        [ test "returns 0 for init" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore Dict.empty testGameData.choices "init"
                    |> Expect.equal 0
        , test "returns 0 for start" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore Dict.empty initGameData.choices "start"
                    |> Expect.equal 0
        , test "returns 0 for non-start" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore Dict.empty initGameData.choices "no-thanks"
                    |> Expect.equal 0
        , test "returns 8 harm for start->macaques" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore Dict.empty startGameData.choices "macaques"
                    |> Expect.equal 8
        , test "returns 8+1 harm for start->macaques->stay" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore Dict.empty macaquesGameData.choices "stay"
                    |> Expect.equal 9
        , test "returns 3 (set value) for start->macaques->change->mice" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore Dict.empty changeGameData.choices "mice"
                    |> Expect.equal 3
        , test "returns 2 for start->macaques->change->fish" <|
            \_ ->
                GameData.updateScore Harm TestData.testDatastore Dict.empty changeGameData.choices "fish"
                    |> Expect.equal 2
        ]


updateAllScores : Test
updateAllScores =
    describe "updateAllScores Function"
        [ test "Check data for start->macaques->change->fish" <|
            \_ ->
                { choices = "fish" :: changeGameData.choices
                , choicesVisited = Set.empty
                , checkboxSet = changeGameData.checkboxSet
                , teamName = changeGameData.teamName
                , scoreSuccess = GameData.updateScore Success TestData.testDatastore Dict.empty changeGameData.choices "fish"
                , scoreEconomic = GameData.updateScore Economic TestData.testDatastore Dict.empty changeGameData.choices "fish"
                , scoreHarm = GameData.updateScore Harm TestData.testDatastore Dict.empty changeGameData.choices "fish"
                }
                    |> Expect.equal
                        { choices = [ "fish", "change", "macaques", "start", "init" ]
                        , choicesVisited = Set.empty
                        , checkboxSet = changeGameData.checkboxSet
                        , teamName = "TestTeam"
                        , scoreSuccess = 50
                        , scoreEconomic = 17250000
                        , scoreHarm = 2
                        }
        ]
