module PostMessage (..) where

import Signal
import Task
import Message


box : Signal.Mailbox Message.Model
box =
  Signal.mailbox (Message.Model "" 0 "")


signal : Signal Message.Model
signal =
  box.signal


post : Message.Model -> Task.Task a ()
post message =
  Signal.send box.address message
