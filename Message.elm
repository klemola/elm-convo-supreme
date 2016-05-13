module Message exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Time exposing (..)
import Date
import String

type alias Message =
  { content : String
  , sentOn : Time
  , sentBy : String
  }


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
