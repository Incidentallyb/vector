module GameDataTest exposing (getIntegerIfMatchFound)

import Expect
import GameData
import Test exposing (Test, describe, test)


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
