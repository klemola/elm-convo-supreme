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
    , inputs =
        [ (Signal.map (\message -> ConvoSupreme.ReceiveMessage message) receiveMessage)
        , (Signal.map (\username -> ConvoSupreme.SetUser username) username)
        ]
    }


main : Signal Html
main =
  app.html


port username : Signal String
port receiveMessage : Signal Message.Model
port postMessage : Signal Message.Model
port postMessage =
  Message.signal


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
