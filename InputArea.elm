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


userInput : Signal.Address Action -> Model -> Html
userInput address model =
  input
    [ style
        [ ( "flex", "5" )
        , ( "height", "2.5rem" )
        , ( "padding", "0.25rem 0.5rem" )
        , ( "font-size", "1em" )
        , ( "border", "none" )
        , ( "border-radius", "0.5rem" )
        , ( "margin-right", "0.5rem" )
        ]
    , placeholder "Your message..."
    , autofocus True
    , value model.input
    , on "input" targetValue (\str -> Signal.message address (Input str))
    ]
    []


sendMessage : Signal.Address Action -> Model -> Html
sendMessage address model =
  button
    [ onClick address (SendMessage model.input)
    , style
        [ ( "flex", "1" )
        , ( "height", "3rem" )
        , ( "font-size", "1.5em" )
        , ( "border", "none" )
        , ( "background", "lightblue" )
        , ( "color", "#345B80" )
        , ( "border-radius", "0.5rem" )
        ]
    ]
    [ text ">" ]


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ style [ ( "display", "flex" ) ] ]
    [ userInput address model
    , sendMessage address model
    ]
