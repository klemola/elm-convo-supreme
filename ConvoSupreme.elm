module ConvoSupreme (..) where

import Html exposing (..)
import InputArea
import Messages
import Message


type Action
  = InputAreaAction InputArea.Action
  | MessagesAction Messages.Action


type alias Model =
  { title : String
  , inputModel : InputArea.Model
  , messagesModel : Messages.Model
  }


init : Model
init =
  { title = "Convo Supreme"
  , inputModel = InputArea.init
  , messagesModel = Messages.init
  }


update : Action -> Model -> Model
update action model =
  case action of
    InputAreaAction inputAction ->
      case inputAction of
        InputArea.SendMessage input ->
          { model
            | messagesModel = Messages.update (Messages.ReceiveMessage (createMessage input)) model.messagesModel
            , inputModel = InputArea.update inputAction model.inputModel
          }

        _ ->
          { model
            | inputModel = InputArea.update inputAction model.inputModel
          }

    _ ->
      model


createMessage : String -> Message.Model
createMessage input =
  { content = input
  , sentOn = 0
  , sentBy = "User"
  }


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ h1 [] [ text model.title ]
    , InputArea.view (Signal.forwardTo address InputAreaAction) model.inputModel
    , Messages.view model.messagesModel
    ]
