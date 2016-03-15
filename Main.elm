module Main (..) where

import Effects exposing (Never)
import StartApp
import Html exposing (Html)
import Task
import ConvoSupreme exposing (init, update, view)


app : StartApp.App ConvoSupreme.Model
app =
  StartApp.start
    { init = init "Convo Supreme"
    , update = update
    , view = view
    , inputs = []
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
