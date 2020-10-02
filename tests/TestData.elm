module TestData exposing (..)

import Content
import Dict
import GameData

testMessage1 : Content.MessageData
testMessage1 = 
    { triggered_by = ["init"]
    , author = "test"
    , choices = ["start|Lets go!"]
    , preview = ""
    , content = "Welcome to Vector"
    , basename = "testMessage1"
    , scoreChangeEconomic = Just ["start|18000000"]
    , scoreChangeSuccess = Nothing
    }


testMessage2 : Content.MessageData
testMessage2 = 
    { triggered_by = ["init|start"]
    , author = "test"
    , choices = [ "macaques|Macaques", "mice|Mice", "fish|Fish"]
    , preview = ""
    , content = "Please choose a test subject"
    , basename = "testMessage2"
    , scoreChangeEconomic = Just ["macaques|-7000000", "mice|-1000000", "fish|-500000" ]
    , scoreChangeSuccess = Just ["macaques|40", "mice|30", "fish|10" ]
    }


testMessage3 : Content.MessageData
testMessage3 = 
    { triggered_by = ["init|start|macaques"]
    , author = "test"
    , choices = [ "stay|Stay with macaques", "change|Change to another animal"]
    , preview = ""
    , content = "Are you sure you want to stay with macaques?"
    , basename = "testMessage3"
    , scoreChangeEconomic = Nothing
    , scoreChangeSuccess = Nothing
    }


testMessage4 : Content.MessageData
testMessage4 = 
    { triggered_by = ["init|start|macaques|change"]
    , author = "test"
    , choices = [  "mice|Mice", "fish|Fish"]
    , preview = ""
    , content = "Choose another animal (you lost 250,000 in lab costs by changing your mind)"
    , basename = "testMessage4"
    , scoreChangeEconomic = Just ["mice|5750000", "fish|6250000" ]
    , scoreChangeSuccess = Nothing
    }



testDatastore : Content.Datastore
testDatastore = 
    { messages = Dict.fromList [ ("firstmessage", testMessage1)
        , ("subjectchoice", testMessage2)
        , ("stayorgo", testMessage3)
        , ("changeanimal", testMessage4)
        ]
    , documents =Dict.empty 
    , emails = Dict.empty
    , social = Dict.empty
    }


testGamedata : GameData.GameData
testGamedata = 
  { choices = [ "" ]
    , teamName = "TestTeam"
    , scoreSuccess = 0
    , scoreEconomic = 0
    , scoreHarm = 0
    }
