port module InputArea exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Json.Encode exposing (encode)
import Time exposing (Time)
import WebSocket
import Task
import Message exposing (Message, encodeMessage)


type Msg
  = Input String
  | SendMessage
  | PostMessage Time
  | SetUser String
  | Fail ()


type alias Model =
  { username : String
  , input : String
  }


port username : (String -> msg) -> Sub msg


init : ( Model, Cmd Msg )
init =
  ( Model "" "", Cmd.none )


subscriptions : Sub Msg
subscriptions =
  username SetUser


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Input text ->
      ( { model | input = text }, Cmd.none )

    SendMessage ->
      ( model, Task.perform Fail PostMessage Time.now )

    PostMessage currentTime ->
      let
        message =
          Message model.input currentTime model.username

        encodedMessage =
          encode 0 (encodeMessage message)
      in
        ( { model | input = "" }, WebSocket.send "wss://test-ws-chat.herokuapp.com" encodedMessage )

    SetUser name ->
      ( { model | username = name }, Cmd.none )

    Fail _ ->
      ( model, Cmd.none )


onEnter : a -> a -> Attribute a
onEnter fail success =
  let
    tagger code =
      if code == 13 then
        success
      else
        fail
  in
    on "keyup" (Json.map tagger keyCode)


userInput : String -> Html Msg
userInput model =
  input
    [ class "user-input"
    , placeholder "Your message..."
    , autofocus True
    , value model
    , onInput Input
    , onEnter (Fail ()) SendMessage
    ]
    []


sendMessage : Html Msg
sendMessage =
  button
    [ onClick SendMessage
    , class "send-message"
    ]
    [ text ">" ]


view : Model -> Html Msg
view model =
  div [ class "input-area" ]
    [ userInput model.input
    , sendMessage
    ]
