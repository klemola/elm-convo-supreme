module Message exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Time exposing (..)
import Date
import String
import Json.Encode as Encode
import Json.Decode as Decode exposing (Decoder, (:=))

type alias Message =
  { content : String
  , sentOn : Time
  , sentBy : String
  }


messageDecoder : Decoder Message
messageDecoder =
  Decode.object3 Message
    ("content" := Decode.string)
    ("sentOn" := Decode.float)
    ("sentBy" := Decode.string)

encodeMessage : Message -> Encode.Value
encodeMessage message =
  Encode.object
      [ ("content", Encode.string message.content)
      , ("sentOn", Encode.float message.sentOn)
      , ("sentBy", Encode.string message.sentBy)
      ]

msgTime : Time -> String
msgTime timestamp =
  let
    date =
      Date.fromTime timestamp

    pad n =
      String.padLeft 2 '0' (toString n)
  in
    (pad (Date.hour date)) ++ ":" ++ (pad (Date.minute date))


msgContent : Message -> Html msg
msgContent model =
  span
    [ class "message-content" ]
    [ text (model.sentBy ++ ": " ++ model.content) ]


msgSentOn : Time -> Html msg
msgSentOn sentOn =
  span
    [ class "message-timestamp" ]
    [ text (msgTime sentOn) ]


view : Message -> Html msg
view model =
  li
    [ class "message" ]
    [ msgContent model
    , msgSentOn model.sentOn
    ]
