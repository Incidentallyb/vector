module EmailsTest exposing (displaySingleEmail)

import Content
import Dict
import GameData
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestData exposing (testDatastore, testGamedata)
import View.Emails


gameData : GameData.GameData
gameData =
    testGamedata


dataStore : Content.Datastore
dataStore =
    { testDatastore | messages = Dict.empty, social = Dict.empty }


emailData : Maybe Content.EmailData
emailData =
    Dict.get "testEmail1" dataStore.emails


displaySingleEmail : Test
displaySingleEmail =
    describe "Views.Emails.single function"
        [ test "can display an email with choices" <|
            \_ ->
                View.Emails.single gameData emailData
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "button-choices" ]
                    |> Query.has [ Selector.text "test choice" ]
        ]
