module TestData exposing (testDatastore, testGamedata)

import Content
import Dict
import GameData
import Set


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
    , choices = [ "macaques|Macaques", "mice|Mice", "fish|Fish" ]
    , preview = ""
    , content = "Please choose a test subject"
    , basename = "testMessage2"
    , scoreChangeEconomic = Just [ "macaques|-7000000", "mice|-1000000", "fish|-500000" ]
    , scoreChangeHarm = Just [ "macaques|8", "mice|4", "fish|3" ]
    , scoreChangeSuccess = Just [ "macaques|40", "mice|30", "fish|10" ]
    }


testMessage3 : Content.MessageData
testMessage3 =
    { triggered_by = [ "init|start|macaques" ]
    , author = "test"
    , playerMessage = Nothing
    , choices = [ "stay|Stay with macaques", "change|Change to another animal" ]
    , preview = ""
    , content = "Are you sure you want to stay with macaques?"
    , basename = "testMessage3"
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Just [ "stay|1" ]

    -- bonus of 5% sucesss if you stick with macaques
    , scoreChangeSuccess = Just [ "stay|5" ]
    }


testMessage4 : Content.MessageData
testMessage4 =
    { triggered_by = [ "init|start|macaques|change" ]
    , author = "test"
    , playerMessage = Nothing
    , choices = [ "mice|Mice", "fish|Fish" ]
    , preview = ""
    , content = "Choose another animal (you lost 250,000 in lab costs by changing your mind)"
    , basename = "testMessage4"
    , scoreChangeEconomic = Just [ "mice|5750000", "fish|6250000" ]
    , scoreChangeHarm = Just [ "mice|=3", "fish|=2" ]

    -- bonus of +10% sucesss if you switch to fish
    -- else SET to 30% if you choose mice
    , scoreChangeSuccess = Just [ "mice|=30", "fish|10" ]
    }

testEmail1 : Content.EmailData
testEmail1 =
  { triggered_by = ["init|start"]
  , author = "test"
  , subject = "Test email subject"
  , preview = "Test email preview"
  , content = "Test email content"
  , image = Nothing
  , basename = "testEmail1"
  , choices = Just ["test choice"]
  , scoreChangeEconomic = Nothing
  , scoreChangeHarm = Nothing
  , scoreChangeSuccess = Nothing
  }


testDatastore : Content.Datastore
testDatastore =
    { messages =
        Dict.fromList
            [ ( "firstmessage", testMessage1 )
            , ( "subjectchoice", testMessage2 )
            , ( "stayorgo", testMessage3 )
            , ( "changeanimal", testMessage4 )
            ]
    , documents = Dict.empty
    , emails = Dict.fromList [ ( "testEmail1", testEmail1 ) ]
    , social = Dict.empty
    }


testGamedata : GameData.GameData
testGamedata =
    { choices = [ "" ]
    , choicesVisited = Set.empty
    , checkboxSet = { selected = Set.empty, submitted = False }
    , teamName = "TestTeam"
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }
