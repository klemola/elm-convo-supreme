module ConvoSupreme (..) where

import Html exposing (..)
import InputArea


type Action
  = InputAreaAction InputArea.Action


type alias Model =
  { inputModel : InputArea.Model
  , title : String
  , messages : List String
  }


init : Model
init =
  { inputModel = InputArea.init
  , title = "Convo Supreme"
  , messages = []
  }


update : Action -> Model -> Model
update action model =
  case action of
    InputAreaAction inputAction ->
      case inputAction of
        InputArea.SendMessage message ->
          { model
            | messages = message :: model.messages
            , inputModel = InputArea.update inputAction model.inputModel
          }

        _ ->
          { model
            | inputModel = InputArea.update inputAction model.inputModel
          }


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ h1 [] [ text model.title ]
    , InputArea.view (Signal.forwardTo address InputAreaAction) model.inputModel
    , text (toString model.messages)
    ]
