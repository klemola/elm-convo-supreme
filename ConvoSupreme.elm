module ConvoSupreme (..) where

import Html exposing (..)
import InputArea
import Messages


type Action
  = InputAreaAction InputArea.Action
  | MessagesAction Messages.Action


type alias Model =
  { inputModel : InputArea.Model
  , title : String
  , messagesModel : Messages.Model
  }


init : Model
init =
  { inputModel = InputArea.init
  , title = "Convo Supreme"
  , messagesModel = Messages.init
  }


update : Action -> Model -> Model
update action model =
  case action of
    InputAreaAction inputAction ->
      case inputAction of
        InputArea.SendMessage message ->
          { model
            | messagesModel = Messages.update (Messages.ReceiveMessage message) model.messagesModel
            , inputModel = InputArea.update inputAction model.inputModel
          }

        _ ->
          { model
            | inputModel = InputArea.update inputAction model.inputModel
          }

    _ ->
      model


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ h1 [] [ text model.title ]
    , InputArea.view (Signal.forwardTo address InputAreaAction) model.inputModel
    , Messages.view model.messagesModel
    ]
