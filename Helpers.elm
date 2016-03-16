module Helpers (onEnter) where

import Html exposing (Attribute)
import Html.Events exposing (on, keyCode)
import Json.Decode as Json
import Signal exposing (Address)


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
