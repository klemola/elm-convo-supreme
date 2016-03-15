module Messages (..) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Message


type Action
  = ReceiveMessage Message.Model


type alias Model =
  List Message.Model


init : Model
init =
  []


update : Action -> Model -> Model
update action model =
  case action of
    ReceiveMessage message ->
      message :: model


view : Model -> Html
view model =
  ul
    [ style
        [ ( "list-style", "none" )
        , ( "padding", "0" )
        , ( "margin", "0" )
        ]
    ]
    (model
      |> List.reverse
      |> List.map Message.view
    )
