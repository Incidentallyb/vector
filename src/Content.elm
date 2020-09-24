module Content exposing (Datastore, DocumentData, datastoreDictDecoder)

import Dict exposing (Dict)
import Json.Decode exposing (field, list, map4, map5, map6, string)


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
    , summary : String
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
        (map6 MessageData
            (field "triggered_by" (list string))
            (field "author" string)
            (field "choices" (list string))
            (field "preview" string)
            (field "content" string)
            (field "basename" string)
        )


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
            (field "summary" string)
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
