module GameDataTest exposing (getStringIfMatchFound, updateEconomicScore, updateSuccessScore)

import Expect
import GameData exposing (ScoreType(..))
import Test exposing (Test, describe, test)
import TestData


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
    let
        testGameData =
            TestData.testGamedata

        initGameData =
            { choices = [ "init" ]
            , teamName = testGameData.teamName
            , scoreSuccess = 0
            , scoreEconomic = 0
            , scoreHarm = 0
            }

        startGameData =
            { choices = [ "start", "init" ]
            , teamName = testGameData.teamName
            , scoreSuccess = 0
            , scoreEconomic = 0
            , scoreHarm = 0
            }

        macaquesGameData =
            { choices = [ "macaques", "start", "init" ]
            , teamName = testGameData.teamName
            , scoreSuccess = 0
            , scoreEconomic = 0
            , scoreHarm = 0
            }

        changeGameData =
            { choices = [ "change", "macaques", "start", "init" ]
            , teamName = testGameData.teamName
            , scoreSuccess = 0
            , scoreEconomic = 0
            , scoreHarm = 0
            }
    in
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
    let
        testGameData =
            TestData.testGamedata

        initGameData =
            { choices = [ "init" ]
            , teamName = testGameData.teamName
            , scoreSuccess = 0
            , scoreEconomic = 0
            , scoreHarm = 0
            }

        startGameData =
            { choices = [ "start", "init" ]
            , teamName = testGameData.teamName
            , scoreSuccess = 0
            , scoreEconomic = 0
            , scoreHarm = 0
            }

        macaquesGameData =
            { choices = [ "macaques", "start", "init" ]
            , teamName = testGameData.teamName
            , scoreSuccess = 0
            , scoreEconomic = 0
            , scoreHarm = 0
            }

        changeGameData =
            { choices = [ "change", "macaques", "start", "init" ]
            , teamName = testGameData.teamName
            , scoreSuccess = 0
            , scoreEconomic = 0
            , scoreHarm = 0
            }
    in
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
