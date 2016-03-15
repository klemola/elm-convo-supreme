module InputArea (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Effects exposing (Effects)
import Json.Decode as Json


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


onEnter : Address a -> a -> Attribute
onEnter address value =
  on
    "keydown"
    (Json.customDecoder keyCode is13)
    (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
  if code == 13 then
    Ok ()
  else
    Err "not the right key code"


userInput : Signal.Address Action -> String -> Html
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
    , value model
    , on "input" targetValue (\str -> Signal.message address (Input str))
    , onEnter address (SendMessage model)
    ]
    []


sendMessage : Signal.Address Action -> String -> Html
sendMessage address model =
  button
    [ onClick address (SendMessage model)
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
