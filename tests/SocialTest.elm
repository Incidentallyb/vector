module SocialTest exposing (displaySocialContent)

import Content
import Dict
import GameData
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestData exposing (testDatastore, testGamedata)
import View.Social


gameData : GameData.GameData
gameData =
    { testGamedata | choices = [ "start", "init" ] }


dataStore : Content.Datastore
dataStore =
    { testDatastore | messages = Dict.empty, emails = Dict.empty }


displaySocialContent : Test
displaySocialContent =
    describe "Views.Social.view function"
        [ test "can display a social handle" <|
            \_ ->
                View.Social.view "" gameData dataStore.social
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "handle" ]
                    |> Query.has [ Selector.text "@testauthor" ]
        ]
