module ConvoSupreme (..) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Time exposing (Time)
import Effects exposing (Effects)
import Task
import TaskTutorial
import InputArea
import Messages
import Message


type Action
  = CreateMessage ( Time, String )
  | InputAreaAction InputArea.Action


type alias Model =
  { title : String
  , inputModel : InputArea.Model
  , messagesModel : Messages.Model
  }


init : String -> ( Model, Effects Action )
init title =
  ( (Model title "" Messages.init), Effects.none )


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    CreateMessage ( time, content ) ->
      ( { model
          | messagesModel = Messages.update (Messages.ReceiveMessage (createMessage content time)) model.messagesModel
        }
      , Effects.none
      )

    InputAreaAction inputAction ->
      handleInput inputAction model


handleInput : InputArea.Action -> Model -> ( Model, Effects Action )
handleInput action model =
  case action of
    InputArea.SendMessage content ->
      ( { model
          | inputModel = InputArea.init
        }
      , triggerCreateMessage content
      )

    InputArea.Input content ->
      let
        ( inputModel, fx ) =
          InputArea.update action content
      in
        ( { model | inputModel = inputModel }, Effects.none )


triggerCreateMessage : String -> Effects Action
triggerCreateMessage message =
  TaskTutorial.getCurrentTime
    |> (flip Task.andThen)
        (\time ->
          Task.succeed (CreateMessage ( time, message ))
        )
    |> Effects.task


createMessage : String -> Time -> Message.Model
createMessage input timestamp =
  { content = input
  , sentOn = timestamp
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
