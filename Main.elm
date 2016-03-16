module Main (..) where

import Effects exposing (Never)
import StartApp
import Html exposing (Html)
import Task
import ConvoSupreme exposing (init, update, view)
import Message


app : StartApp.App ConvoSupreme.Model
app =
  StartApp.start
    { init = init "Convo Supreme"
    , update = update
    , view = view
    , inputs = [ Signal.map (\message -> ConvoSupreme.ReceiveMessage message) receiveMessage ]
    }


main : Signal Html
main =
  app.html


port receiveMessage : Signal Message.Model
port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
