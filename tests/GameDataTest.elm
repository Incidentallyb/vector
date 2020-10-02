module GameDataTest exposing (..)

import Expect
import GameData
import Test exposing (Test, describe, test)
import TestData


getIntegerIfMatchFound : Test
getIntegerIfMatchFound =
    describe "getIntegerIfMatchFound Function"
        [ test "returns 0 for non matching values" <|
            \_ ->
                GameData.getIntegerIfMatchFound "macaque|50" "fish"
                    |> Expect.equal 0
        , test "returns 0 for non matching values (2)" <|
            \_ ->
                GameData.getIntegerIfMatchFound "macaque|50" "mice"
                    |> Expect.equal 0
        , test "returns 0 for non matching values (3)" <|
            \_ ->
                GameData.getIntegerIfMatchFound "" "fish"
                    |> Expect.equal 0
        , test "returns 0 for non matching values (4)" <|
            \_ ->
                GameData.getIntegerIfMatchFound "" ""
                    |> Expect.equal 0
        , test "returns value for matching values" <|
            \_ ->
                GameData.getIntegerIfMatchFound "macaque|50" "macaque"
                    |> Expect.equal 50
        , test "returns value for matching values (2)" <|
            \_ ->
                GameData.getIntegerIfMatchFound "macaque|-40000" "macaque"
                    |> Expect.equal -40000
        ]


updateEconomicScore : Test
updateEconomicScore =
    let
        testGameData =
            TestData.testGamedata
        initGameData =
            { choices = ["init"]
            , teamName =  testGameData.teamName, scoreSuccess = 0 , scoreEconomic = 0, scoreHarm = 0
            }
            
        startGameData =
            { choices = ["start", "init"]
            , teamName =  testGameData.teamName, scoreSuccess = 0 , scoreEconomic = 0, scoreHarm = 0
            }
            
        macaquesGameData =
            { choices = ["macaques", "start", "init"]
            , teamName =  testGameData.teamName, scoreSuccess = 0 , scoreEconomic = 0, scoreHarm = 0
            }
        changeGameData =
            { choices = ["change", "macaques", "start", "init"]
            , teamName =  testGameData.teamName, scoreSuccess = 0 , scoreEconomic = 0, scoreHarm = 0
            }            
    in
    describe "updateEconomicScore Function"
    [
        test "returns 0 for init" <|
            \_ ->
               GameData.updateEconomicScore TestData.testDatastore testGameData "init"
                    |> Expect.equal 0
        , test "returns 18000000 for start" <|
            \_ ->
                GameData.updateEconomicScore TestData.testDatastore initGameData "start"
                    |> Expect.equal 18000000
        , test "returns 0 for non-start" <|
            \_ ->
               GameData.updateEconomicScore TestData.testDatastore initGameData "no-thanks"
                    |> Expect.equal 0
        , test "returns 11000000 for start->macaques" <|
            \_ ->
                GameData.updateEconomicScore TestData.testDatastore startGameData "macaques"
                    |> Expect.equal 11000000
        , test "returns 11000000 for start->macaques->stay" <|
            \_ ->
                GameData.updateEconomicScore TestData.testDatastore macaquesGameData "stay"
                    |> Expect.equal 11000000
        , test "returns 167500000 for start->macaques->change->mice" <|
            \_ ->
                GameData.updateEconomicScore TestData.testDatastore changeGameData "mice"
                    |> Expect.equal 16750000
    ]

-- 