module Messages (..) where

import Html exposing (..)
import Message


type Action
  = ReceiveMessage Message.Model


type alias Model =
  { messages : List Message.Model }


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
  ul
    []
    (model.messages
      |> List.reverse
      |> List.map Message.view
    )
