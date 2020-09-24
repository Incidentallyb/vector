module Content exposing (DocumentData, EmailData, MessageData, SocialData, documentDictDecoder, emailDictDecoder, messageDictDecoder, socialDictDecoder)

import Dict exposing (Dict)
import Json.Decode exposing (..)


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
