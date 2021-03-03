module Content exposing (BranchingContent(..), Datastore, DocumentData, EmailData, MessageData, SocialData, datastoreDictDecoder, emptyDocument, emptyEmail, emptyMessage)

import Dict exposing (Dict)
import Json.Decode exposing (field, int, list, map4, string)
import Json.Decode.Extra exposing (andMap, withDefault)


type alias Datastore =
    { messages : Dict String MessageData
    , documents : Dict String DocumentData
    , emails : Dict String EmailData
    , social : Dict String SocialData
    }


type BranchingContent
    = Message MessageData
    | Email EmailData
    | Document DocumentData


type alias MessageData =
    { triggered_by : List String
    , author : String
    , playerMessage : Maybe String
    , choices : List String
    , preview : String
    , content : String
    , basename : String
    , scoreChangeEconomic : Maybe (List String)
    , scoreChangeHarm : Maybe (List String)
    , scoreChangeSuccess : Maybe (List String)
    }


type alias DocumentData =
    { triggered_by : List String
    , image : String
    , preview : String
    , content : String
    , basename : String
    }


type alias EmailData =
    { triggered_by : List String
    , author : String
    , subject : String
    , preview : String
    , content : String
    , basename : String
    , choices : Maybe (List String)
    , scoreChangeEconomic : Maybe (List String)
    , scoreChangeHarm : Maybe (List String)
    , scoreChangeSuccess : Maybe (List String)
    }


type alias SocialData =
    { triggered_by : List String
    , author : String
    , handle : String
    , content : String
    , basename : String
    , numComments : Int
    , numRetweets : Int
    , numLoves : Int
    }


emptyMessage : MessageData
emptyMessage =
    { triggered_by = [ "" ]
    , author = ""
    , playerMessage = Nothing
    , choices = [ "" ]
    , preview = ""
    , content = "Sorry. Something's gone wrong."
    , basename = ""
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


emptyEmail : EmailData
emptyEmail =
    { triggered_by = [ "" ]
    , author = ""
    , subject = ""
    , choices = Nothing
    , preview = ""
    , content = "Sorry. Something's gone wrong."
    , basename = ""
    , scoreChangeEconomic = Nothing
    , scoreChangeHarm = Nothing
    , scoreChangeSuccess = Nothing
    }


emptyDocument : DocumentData
emptyDocument =
    { triggered_by = [ "" ]
    , image = ""
    , preview = ""
    , content = "Sorry. Something's gone wrong."
    , basename = ""
    }


datastoreDictDecoder : Json.Decode.Value -> Datastore
datastoreDictDecoder flags =
    case Json.Decode.decodeValue flagsDictDecoder flags of
        Ok goodMessages ->
            goodMessages

        Err _ ->
            { messages = Dict.empty
            , documents = Dict.empty
            , emails = Dict.empty
            , social = Dict.empty
            }



{- to debug the above
   let
       debugger =
           Debug.log "Json Decode Error" (Debug.toString dataError)
   in
-}


flagsDictDecoder : Json.Decode.Decoder Datastore
flagsDictDecoder =
    map4 Datastore
        (field "messages" messageDictDecoder)
        (field "documents" documentDictDecoder)
        (field "emails" emailDictDecoder)
        (field "social" socialDictDecoder)



-- Dict with string keys for multiple messages from one json file.
-- Keys, derived from individual markdown filenames are also the basename value for each message.


messageDictDecoder : Json.Decode.Decoder (Dict String MessageData)
messageDictDecoder =
    Json.Decode.dict
        (Json.Decode.succeed MessageData
            |> andMap (Json.Decode.field "triggered_by" (list string) |> withDefault [])
            |> andMap (Json.Decode.field "author" string |> withDefault "")
            |> andMap (Json.Decode.maybe (Json.Decode.field "playerMessage" string))
            |> andMap (Json.Decode.field "choices" (list string) |> withDefault [])
            |> andMap (Json.Decode.field "preview" string |> withDefault "")
            |> andMap (Json.Decode.field "content" string |> withDefault "")
            |> andMap (Json.Decode.field "basename" string |> withDefault "")
            |> andMap (Json.Decode.maybe (Json.Decode.field "scoreChangeEconomic" (list string)))
            |> andMap (Json.Decode.maybe (Json.Decode.field "scoreChangeHarm" (list string)))
            |> andMap (Json.Decode.maybe (Json.Decode.field "scoreChangeSuccess" (list string)))
        )


documentDictDecoder : Json.Decode.Decoder (Dict String DocumentData)
documentDictDecoder =
    Json.Decode.dict
        (Json.Decode.succeed DocumentData
            |> andMap (Json.Decode.field "triggered_by" (list string) |> withDefault [])
            |> andMap (Json.Decode.field "image" string |> withDefault "")
            |> andMap (Json.Decode.field "preview" string |> withDefault "")
            |> andMap (Json.Decode.field "content" string |> withDefault "")
            |> andMap (Json.Decode.field "basename" string |> withDefault "")
        )


emailDictDecoder : Json.Decode.Decoder (Dict String EmailData)
emailDictDecoder =
    Json.Decode.dict
        (Json.Decode.succeed EmailData
            |> andMap (Json.Decode.field "triggered_by" (list string) |> withDefault [])
            |> andMap (Json.Decode.field "author" string |> withDefault "")
            |> andMap (Json.Decode.field "subject" string |> withDefault "")
            |> andMap (Json.Decode.field "preview" string |> withDefault "")
            |> andMap (Json.Decode.field "content" string |> withDefault "")
            |> andMap (Json.Decode.field "basename" string |> withDefault "")
            |> andMap (Json.Decode.maybe (Json.Decode.field "choices" (list string)))
            |> andMap (Json.Decode.maybe (Json.Decode.field "scoreChangeEconomic" (list string)))
            |> andMap (Json.Decode.maybe (Json.Decode.field "scoreChangeHarm" (list string)))
            |> andMap (Json.Decode.maybe (Json.Decode.field "scoreChangeSuccess" (list string)))
        )


socialDictDecoder : Json.Decode.Decoder (Dict String SocialData)
socialDictDecoder =
    Json.Decode.dict
        (Json.Decode.succeed SocialData
            |> andMap (Json.Decode.field "triggered_by" (list string) |> withDefault [])
            |> andMap (Json.Decode.field "author" string |> withDefault "")
            |> andMap (Json.Decode.field "handle" string |> withDefault "")
            |> andMap (Json.Decode.field "content" string |> withDefault "")
            |> andMap (Json.Decode.field "basename" string |> withDefault "")
            |> andMap (Json.Decode.field "numComments" int |> withDefault 0)
            |> andMap (Json.Decode.field "numLoves" int |> withDefault 0)
            |> andMap (Json.Decode.field "numRetweets" int |> withDefault 0)
        )
