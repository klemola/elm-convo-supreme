module Messages (..) where

import Html exposing (..)


type Action
  = ReceiveMessage String


type alias Model =
  { messages : List String }


init : Model
init =
  { messages = []
  }


update : Action -> Model -> Model
update action model =
  case action of
    ReceiveMessage message ->
      { model | messages = message :: model.messages }


view : Model -> Html
view model =
  text (toString model.messages)
