module ConvoSupreme (..) where

import Html exposing (..)
import Html.Attributes exposing (style)
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


headerBlock : String -> Html
headerBlock title =
  header
    [ style
        [ ( "flex-basis", "4rem" )
        , ( "flex-shrink", "0" )
        , ( "background", "#f5f5f5" )
        , ( "border-bottom", "0.2rem solid #e5e5e5" )
        , ( "text-align", "center" )
        ]
    ]
    [ h2 [] [ text title ] ]


messagesBlock : Messages.Model -> Html
messagesBlock messages =
  div
    [ style
        [ ( "flex", "1" )
        , ( "overflow-y", "scroll" )
        ]
    ]
    [ Messages.view messages ]


inputBlock : Signal.Address Action -> InputArea.Model -> Html
inputBlock address model =
  div
    [ style
        [ ( "flex-basis", "3rem" )
        , ( "flex-shrink", "0" )
        , ( "padding", "0.5rem" )
        , ( "background", "#f5f5f5" )
        , ( "border-top", "0.2rem solid #e5e5e5" )
        ]
    ]
    [ InputArea.view (Signal.forwardTo address InputAreaAction) model ]


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ style
        [ ( "color", "#333" )
        , ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "min-height", "100vh" )
        ]
    ]
    [ headerBlock model.title
    , messagesBlock model.messagesModel
    , inputBlock address model.inputModel
    ]
