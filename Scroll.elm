module Scroll (..) where

import Signal
import Task


box : Signal.Mailbox String
box =
  Signal.mailbox ""


signal : Signal String
signal =
  box.signal


scroll : String -> Task.Task a ()
scroll elementId =
  Signal.send box.address elementId
