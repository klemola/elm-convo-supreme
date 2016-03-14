module Messages (..) where

import Html exposing (..)
import Html.Attributes exposing (style)
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
    [ style
        [ ( "list-style", "none" )
        , ( "padding", "0" )
        , ( "margin", "0" )
        ]
    ]
    (model.messages
      |> List.reverse
      |> List.map Message.view
    )
