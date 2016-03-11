module InputArea (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)


type Action
  = Input String
  | SendMessage String


type alias Model =
  { input : String }


init : Model
init =
  { input = ""
  }


update : Action -> Model -> Model
update action model =
  case action of
    Input value ->
      { model | input = value }

    SendMessage _ ->
      init


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ userInput address model
    , sendMessage address model
    ]


userInput : Signal.Address Action -> Model -> Html
userInput address model =
  input
    [ placeholder "Your message..."
    , autofocus True
    , value model.input
    , on "input" targetValue (\str -> Signal.message address (Input str))
    ]
    []


sendMessage : Signal.Address Action -> Model -> Html
sendMessage address model =
  button
    [ onClick address (SendMessage model.input) ]
    [ text ">" ]
