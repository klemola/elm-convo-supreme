module ConvoSupreme (..) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Time exposing (Time)
import Effects exposing (Effects)
import Task
import Signal
import TaskTutorial
import InputArea
import Messages
import Message
import Scroll


type Action
  = CreateMessage ( Time, String )
  | ReceiveMessage Message.Model
  | SetUser String
  | InputAreaAction InputArea.Action
  | NoOp


type alias Model =
  { title : String
  , username : String
  , inputModel : InputArea.Model
  , messagesModel : Messages.Model
  }


init : String -> ( Model, Effects Action )
init title =
  ( (Model title "" "" Messages.init), Effects.none )


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    CreateMessage ( time, content ) ->
      let
        task =
          Message.post (Message.Model content time model.username)
      in
        ( model, (doNothing task) )

    ReceiveMessage message ->
      let
        ( messagesModel, fx ) =
          Messages.update (Messages.AddMessage message) model.messagesModel

        task =
          Scroll.scroll Messages.componentId
      in
        ( { model | messagesModel = messagesModel }, (doNothing task) )

    SetUser name ->
      ( { model | username = name }, Effects.none )

    InputAreaAction inputAction ->
      handleInput inputAction model

    _ ->
      ( model, Effects.none )


doNothing : Task.Task Effects.Never a -> Effects Action
doNothing task =
  task
    |> Effects.task
    |> Effects.map (always NoOp)


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
        , ( "height", "100%" )
        , ( "min-height", "100%" )
        ]
    ]
    [ headerBlock model.title
    , messagesBlock model.messagesModel
    , inputBlock address model.inputModel
    ]
