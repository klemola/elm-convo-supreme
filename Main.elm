module Main exposing (..)

import Html.App as Html
import ConvoSupreme exposing (init, update, view, subscriptions)

main : Program Never
main =
  Html.program
    { init = init "Convo Supreme"
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
