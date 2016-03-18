module Messages (..) where

import Html exposing (..)
import Html.Attributes exposing (style, id)
import Effects exposing (Effects)
import Message


type Action
  = AddMessage Message.Model


type alias Model =
  List Message.Model


init : Model
init =
  []


componentId : String
componentId =
  "messagesList"


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    AddMessage message ->
      ( message :: model, Effects.none )


view : Model -> Html
view model =
  ul
    [ style
        [ ( "list-style", "none" )
        , ( "padding", "0" )
        , ( "margin", "0" )
        ]
    , id componentId
    ]
    (model
      |> List.reverse
      |> List.map Message.view
    )
