module PathCheckerTest exposing (displayBrokenPaths)

import Content
import Dict
import Html
import Html.Attributes
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import View.PathChecker


cmsAdminPath : String
cmsAdminPath =
    "/admin/#/collections"


cmsPath : String -> String -> String
cmsPath contentType basename =
    String.join "/"
        [ cmsAdminPath, contentType, "entries", basename ]


testMessage1 : Content.MessageData
testMessage1 =
    { triggered_by = [ "init" ]
    , author = "test"
    , playerMessage = Nothing
    , choices = [ "start|Lets go!" ]
    , preview = ""
    , content = "Welcome to Vector"
    , basename = "testMessage1"
    , scoreChangeEconomic = Just [ "start|18000000" ]
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


testMessage2 : Content.MessageData
testMessage2 =
    { triggered_by = [ "init|start" ]
    , author = "test"
    , playerMessage = Nothing
    , choices = [ "badChoice|Bad Choice" ]
    , preview = ""
    , content = "Message with invalid choice"
    , basename = "testMessage2"
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


testMessage3 : Content.MessageData
testMessage3 =
    { triggered_by = [ "init|start|goodChoice" ]
    , author = "test"
    , playerMessage = Nothing
    , choices = [ "stay|Stay", "change|Change" ]
    , preview = ""
    , content = "Are you sure you want to stay?"
    , basename = "testMessage3"
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


testMessage4 : Content.MessageData
testMessage4 =
    { triggered_by = [ "init|start|goodChoice|change" ]
    , author = "test"
    , playerMessage = Nothing
    , choices = []
    , preview = ""
    , content = "Thanks for changing"
    , basename = "testMessage4"
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


testMessage5 : Content.MessageData
testMessage5 =
    { triggered_by = []
    , author = "test"
    , playerMessage = Nothing
    , choices = []
    , preview = ""
    , content = "Thanks for changing"
    , basename = "notriggers"
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


testEmail1 : Content.EmailData
testEmail1 =
    { triggered_by = [ "init|start" ]
    , hideFromTeams = Nothing
    , author = "test"
    , subject = "Test email subject"
    , preview = "Test email preview"
    , content = "Test email content"
    , image = Nothing
    , basename = "testEmail1"
    , choices = Just [ "goodChoice|Good choice" ]
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


testEmail2 : Content.EmailData
testEmail2 =
    { triggered_by = [ "init|start" ]
    , hideFromTeams = Just [ "team1", "team2" ]
    , author = "test"
    , subject = "Test email subject"
    , preview = "Test email preview"
    , content = "Test email content"
    , image = Nothing
    , basename = "testEmail2"
    , choices = Just [ "goodChoice|Good choice" ]
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


testEmail3 : Content.EmailData
testEmail3 =
    { triggered_by = []
    , hideFromTeams = Nothing
    , author = "test"
    , subject = "Test email subject"
    , preview = "Test email preview"
    , content = "Test email content"
    , image = Nothing
    , basename = "testEmail3"
    , choices = Just [ "goodChoice|Good choice" ]
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


badDatastore : Content.Datastore
badDatastore =
    { messages =
        Dict.fromList
            [ ( "firstmessage", testMessage1 )
            , ( "badchoice", testMessage2 )
            , ( "stayorchange", testMessage3 )
            , ( "changed", testMessage4 )
            , ( "notriggers", testMessage5 )
            ]
    , documents = Dict.empty
    , emails =
        Dict.fromList
            [ ( "testEmail1", testEmail1 )
            , ( "testEmail2", testEmail2 )
            , ( "testEmail3", testEmail3 )
            ]
    , social = Dict.empty
    }


displayBrokenPaths : Test
displayBrokenPaths =
    describe "Views.PathChecker.view function"
        [ test "displays choices not contained in any trigger" <|
            \_ ->
                View.PathChecker.view "" badDatastore
                    |> Query.fromHtml
                    |> Query.find [ Selector.id "bad-choices" ]
                    |> Query.has [ Selector.text "badChoice" ]
        , test "displays content that is hidden from some teams" <|
            \_ ->
                View.PathChecker.view "" badDatastore
                    |> Query.fromHtml
                    |> Query.find [ Selector.id "hidden-content" ]
                    |> Query.contains
                        [ Html.li []
                            [ Html.text "* Email is hidden from team1, team2: "
                            , Html.a
                                [ Html.Attributes.href
                                    (cmsPath "email" "testEmail2")
                                ]
                                [ Html.text "testEmail2" ]
                            ]
                        ]
        , test "displays content that does not have a triggered_by value" <|
            \_ ->
                View.PathChecker.view "" badDatastore
                    |> Query.fromHtml
                    |> Query.find [ Selector.id "hidden-content" ]
                    |> Query.contains
                        [ Html.li []
                            [ Html.text "* Email with empty triggered by: "
                            , Html.a
                                [ Html.Attributes.href
                                    (cmsPath "email" "testEmail3")
                                ]
                                [ Html.text "testEmail3" ]
                            ]
                        , Html.li []
                            [ Html.text "* Message with empty triggered by: "
                            , Html.a
                                [ Html.Attributes.href
                                    (cmsPath "message" "notriggers")
                                ]
                                [ Html.text "notriggers" ]
                            ]
                        ]
        , test "displays choices that do not lead to triggered content" <|
            \_ ->
                View.PathChecker.view "" badDatastore
                    |> Query.fromHtml
                    |> Query.find [ Selector.id "dead-ends" ]
                    |> Query.has
                        [ Selector.text "init|start|badChoice"
                        , Selector.text "init|start|goodChoice|stay"
                        ]
        ]
