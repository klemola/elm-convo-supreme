module Message (..) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Time exposing (..)
import Date
import String


type alias Model =
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


msgContent : Model -> Html
msgContent model =
  span
    [ style [ ( "flex", "5" ) ] ]
    [ text (model.sentBy ++ ": " ++ model.content) ]


msgSentOn : Time -> Html
msgSentOn sentOn =
  span
    [ style
        [ ( "flex", "1" )
        , ( "text-align", "right" )
        ]
    ]
    [ text (msgTime sentOn) ]


view : Model -> Html
view model =
  li
    [ style
        [ ( "padding", "0.5rem" )
        , ( "display", "flex" )
        , ( "border-bottom", "0.1rem solid #E5E5E5" )
        ]
    ]
    [ msgContent model
    , msgSentOn model.sentOn
    ]
