module ContentChoiceTest exposing (choiceStepsList, triggeredByChoicesReturnStrings, triggeredByWithChoiceStrings)

import ContentChoices
import Expect
import Test exposing (Test, describe, test)


choiceStepsList : Test
choiceStepsList =
    describe "choiceStepsList Function"
        [ test "produces correct lists" <|
            \_ ->
                ContentChoices.choiceStepsList [ "macaque", "start", "init" ]
                    |> Expect.equal [ "init|start|macaque", "init|start", "init" ]
        , test "triggers correctly (1)" <|
            \_ ->
                ContentChoices.triggeredByChoices [ "macaque", "start", "init" ] [ "init|start" ]
                    |> Expect.equal True
        , test "triggers correctly (2)" <|
            \_ ->
                ContentChoices.triggeredByChoices [ "start", "init" ] [ "init|start" ]
                    |> Expect.equal True
        , test "triggers correctly (3)" <|
            \_ ->
                ContentChoices.triggeredByChoices [ "macaque", "start", "init" ] [ "init|start|fish", "init|start|mice" ]
                    |> Expect.equal False
        ]


triggeredByChoicesReturnStrings : Test
triggeredByChoicesReturnStrings =
    describe "triggeredByChoicesReturnStrings Function"
        [ -- given a list of triggers, based on our current choices, find the exact trigger which matches the choice.
          test "find trigger" <|
            \_ ->
                ContentChoices.triggeredByChoicesGetMatches [ "macaque", "start", "init" ] [ "init|start|macaque", "init|start|fish", "init|start|mice" ]
                    |> Expect.equal [ "init|start|macaque" ]
        , test "(2)" <|
            \_ ->
                ContentChoices.triggeredByChoicesGetMatches [ "start", "init" ] [ "init|start|fish", "init|start|macaque", "init|start|mice" ]
                    |> Expect.equal []

        -- given a list of triggers, based on our current choices, find the trigger which matched the choice (including historical choices).
        , test "(3)" <|
            \_ ->
                ContentChoices.triggeredByChoicesGetMatches [ "macaque", "start", "init" ] [ "init|start" ]
                    |> Expect.equal [ "init|start" ]
        , test "(4)" <|
            \_ ->
                ContentChoices.triggeredByChoicesGetMatches [ "stay", "macaque", "start", "init" ] [ "init|start|fish", "init|start|macaque", "init|start|mice" ]
                    |> Expect.equal [ "init|start|macaque" ]
        ]


triggeredByWithChoiceStrings : Test
triggeredByWithChoiceStrings =
    describe "triggeredByWithChoiceStrings Function"
        [ test "produces correct lists" <|
            \_ ->
                ContentChoices.triggeredByWithChoiceStrings [ "init|start" ] [ "macaque|Macaque", "fish|Fish", "mice|Mice" ]
                    |> Expect.equal [ "init|start|macaque", "init|start|fish", "init|start|mice" ]
        , test "produces correct lists (2)" <|
            \_ ->
                ContentChoices.triggeredByWithChoiceStrings [ "init|start|macaque", "init|start|fish" ] [ "stay|Stay with macaque", "change|Change" ]
                    |> Expect.equal [ "init|start|macaque|stay", "init|start|macaque|change", "init|start|fish|stay", "init|start|fish|change" ]
        , test "produces correct lists (3)" <|
            \_ ->
                ContentChoices.triggeredByWithChoiceStrings [ "init|start" ] [ "macaque|Macaque", "fish|Fish", "mice|Mice" ]
                    |> Expect.equal [ "init|start|macaque", "init|start|fish", "init|start|mice" ]
        ]
