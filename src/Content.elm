module Content exposing (Datastore, DocumentData, EmailData, MessageData, datastoreDictDecoder)

import Dict exposing (Dict)
import Json.Decode exposing (field, list, map4, map5, map6, map8, string, int, maybe)


type alias Datastore =
    { messages : Dict String MessageData
    , documents : Dict String DocumentData
    , emails : Dict String EmailData
    , social : Dict String SocialData
    }


type alias MessageData =
    { triggered_by : List String
    , author : String
    , choices : List String
    , preview : String
    , content : String
    , basename : String
    , scoreChangeEconomic : Maybe Int
    --, scoreChangeHarm : Maybe Int
    , scoreChangeSuccess : Maybe Int
    }


type alias DocumentData =
    { image : String
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
    }


type alias SocialData =
    { triggered_by : List String
    , author : String
    , handle : String
    , content : String
    , basename : String
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
        (map8 MessageData
            (field "triggered_by" (list string))
            (field "author" string)
            (field "choices" (list string))
            (field "preview" string)
            (field "content" string)
            (field "basename" string)
            (maybe (field "scoreChangeEconomic" int))
            (maybe (field "scoreChangeSuccess" int))
        )

{-
flagsDecoder : Decode.Decoder Params
flagsDecoder =
    Decode.succeed Params
        |> Decode.andMap (Decode.field "field1" (Decode.string) |> (Decode.withDefault) "1")
        |> Decode.andMap (Decode.field "field2" (Decode.string)   |> (Decode.withDefault) "2")
        |> Decode.andMap (Decode.field "field3" (Decode.string)   |> (Decode.withDefault) "3")
        |> Decode.andMap (Decode.field "field4" (Decode.string) |> (Decode.withDefault) "4")
        |> Decode.andMap (Decode.field "field5" (Decode.string)  |> (Decode.withDefault) "5")
        |> Decode.andMap (Decode.field "field6" (Decode.int) |> (Decode.withDefault) "6")
        |> Decode.andMap (Decode.field "field7" (Decode.string)    |> (Decode.withDefault) "7")
        |> Decode.andMap (Decode.field "field8" (Decode.string)   |> (Decode.withDefault) "8")
        
        -}


documentDictDecoder : Json.Decode.Decoder (Dict String DocumentData)
documentDictDecoder =
    Json.Decode.dict
        (map4 DocumentData
            (field "image" string)
            (field "preview" string)
            (field "content" string)
            (field "basename" string)
        )


emailDictDecoder : Json.Decode.Decoder (Dict String EmailData)
emailDictDecoder =
    Json.Decode.dict
        (map6 EmailData
            (field "triggered_by" (list string))
            (field "author" string)
            (field "subject" string)
            (field "preview" string)
            (field "content" string)
            (field "basename" string)
        )


socialDictDecoder : Json.Decode.Decoder (Dict String SocialData)
socialDictDecoder =
    Json.Decode.dict
        (map5 SocialData
            (field "triggered_by" (list string))
            (field "author" string)
            (field "handle" string)
            (field "content" string)
            (field "basename" string)
        )
