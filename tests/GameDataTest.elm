module GameDataTest exposing (gamedataTests)

import Expect
import Test exposing (Test, describe, test)
import GameData


gamedataTests : Test
gamedataTests =
    describe "Gamedata"
        [ test "choiceStepsList produces correct lists" <|
            \_ ->
                GameData.choiceStepsList [ "macaque", "start", "init" ]
                    |> Expect.equal [ "init|start|macaque", "init|start", "init" ]
        , test "triggeredByChoices triggers correctly (1)" <|
            \_ ->
                GameData.triggeredByChoices [ "macaque", "start", "init" ]  [ "init|start" ]
                    |> Expect.equal True
        , test "triggeredByChoices triggers correctly (2)" <|
            \_ ->
                GameData.triggeredByChoices [ "start", "init" ]  [ "init|start" ]
                    |> Expect.equal True
        , test "triggeredByChoices triggers correctly (3)" <|
            \_ ->
                GameData.triggeredByChoices [ "macaque", "start", "init" ]  [ "init|start|fish", "init|start|mice" ]
                    |> Expect.equal False
        -- given a list of triggers, based on our current choices, find the exact trigger which matches the choice. 
        , test "triggeredByChoicesReturnStrings" <|
            \_ ->
                GameData.triggeredByChoicesGetMatches [ "macaque", "start", "init" ]  [ "init|start|macaque" , "init|start|fish", "init|start|mice"]
                    |> Expect.equal [ "init|start|macaque" ]
        , test "triggeredByChoicesReturnStrings (2)" <|
            \_ ->
                GameData.triggeredByChoicesGetMatches [ "start", "init" ]  [ "init|start|fish", "init|start|macaque" , "init|start|mice"]
                    |> Expect.equal [ ]
        -- given a list of triggers, based on our current choices, find the trigger which matched the choice (including historical choices). 
        , test "triggeredByChoicesReturnStrings (3)" <|
            \_ ->
                GameData.triggeredByChoicesGetMatches [ "macaque", "start", "init" ]  [ "init|start" ]
                    |> Expect.equal ["init|start" ]
        , test "triggeredByChoicesReturnStrings (4)" <|
            \_ ->
                GameData.triggeredByChoicesGetMatches [ "stay", "macaque", "start", "init" ]  [ "init|start|fish", "init|start|macaque", "init|start|mice"]
                    |> Expect.equal ["init|start|macaque" ]                           
        ]
