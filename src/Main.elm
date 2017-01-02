module Main exposing (..)

import Html
import ConvoSupreme exposing (init, update, view, subscriptions)


main =
    Html.program
        { init = init "Convo Supreme"
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
