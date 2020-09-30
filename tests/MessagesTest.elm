module MessagesTest exposing (messagesTests)

import Expect
import Test exposing (Test, describe, test)
import View.Messages


messagesTests : Test
messagesTests =
    describe "Messages"
        [ test "triggeredByWithChoiceStrings produces correct lists" <|
            \_ ->
                View.Messages.triggeredByWithChoiceStrings [ "init|start" ] ["macaque|Macaque", "fish|Fish", "mice|Mice"]
                    |> Expect.equal [ "init|start|macaque", "init|start|fish", "init|start|mice" ],
        ,test "triggeredByWithChoiceStrings produces correct lists (2)" <|
            \_ ->
                View.Messages.triggeredByWithChoiceStrings [ "init|start|macaque", "init|start|fish" ] ["stay|Stay with macaque", "change|Change" ]
                    |> Expect.equal [ "init|start|macaque|stay", "init|start|macaque|change", "init|start|fish|stay", "init|start|fish|change" ]
            
        ,test "triggeredByWithChoiceStrings produces correct lists (3)" <|       
            \_ ->
                View.Messages.triggeredByWithChoiceStrings [ "init|start" ] ["macaque|Macaque", "fish|Fish", "mice|Mice"]
                    |> Expect.equal [ "init|start|macaque", "init|start|fish", "init|start|mice" ],             
        ]
