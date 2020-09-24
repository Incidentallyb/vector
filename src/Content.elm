module Content exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)



-- A single message


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

-- Dict with string keys for multiple messages from one json file.
-- Keys, derived from individual markdown filenames are also the basename value for each message.


messageDictDecoder : Json.Decode.Decoder (Dict String (Dict String MessageData))
messageDictDecoder =
    Json.Decode.dict
        (Json.Decode.dict
            (map6 MessageData
                (field "triggered_by" (list string))
                (field "author" string)
                (field "choices" (list string))
                (field "preview" string)
                (field "content" string)
                (field "basename" string)
            )
        )


documentDictDecoder : Json.Decode.Decoder (Dict String (Dict String DocumentData))
documentDictDecoder =
    Json.Decode.dict
        (Json.Decode.dict
            (map4 DocumentData
                (field "image" string)
                (field "preview" string)
                (field "content" string)
                (field "basename" string)
            )
        )