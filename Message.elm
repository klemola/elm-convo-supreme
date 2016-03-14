module Message (..) where

import Html exposing (..)
import Time exposing (..)


type alias Model =
  { content : String
  , sentOn : Time
  , sentBy : String
  }


view : Model -> Html
view model =
  li
    []
    [ text model.content ]
