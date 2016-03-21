module InputArea (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Effects exposing (Effects)
import Helpers exposing (onEnter)


type Action
  = Input String
  | SendMessage String


type alias Model =
  String


init : Model
init =
  ""


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    Input text ->
      ( text, Effects.none )

    SendMessage _ ->
      ( init, Effects.none )


userInput : Signal.Address Action -> String -> Html
userInput address model =
  input
    [ class "user-input"
    , placeholder "Your message..."
    , autofocus True
    , value model
    , on "input" targetValue (\str -> Signal.message address (Input str))
    , onEnter address (SendMessage model)
    ]
    []


sendMessage : Signal.Address Action -> String -> Html
sendMessage address model =
  button
    [ onClick address (SendMessage model)
    , class "send-message"
    ]
    [ text ">" ]


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "input-area" ]
    [ userInput address model
    , sendMessage address model
    ]
