module Main (..) where

import Effects exposing (Never)
import StartApp.Simple exposing (start)
import Html exposing (Html)
import Task
import ConvoSupreme exposing (init, update, view)


main =
  start
    { model = init
    , update = update
    , view = view
    }
