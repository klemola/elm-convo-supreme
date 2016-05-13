port module ConvoSupreme exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (class, id)
import InputArea
import Message exposing (Message)

type Msg
  = ReceiveMessage Message
  | InputAreaMsg InputArea.Msg


type alias Model =
  { title : String
  , messages : List Message
  , inputModel : InputArea.Model
  }


port scroll : String -> Cmd msg
port receiveMessage : (Message -> msg) -> Sub msg


init : String -> ( Model, Cmd Msg )
init title =
  let
    (inputModel, inputInitFx) = InputArea.init
  in
    ( (Model title [] inputModel ), Cmd.map InputAreaMsg inputInitFx )


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ receiveMessage ReceiveMessage
    , Sub.map InputAreaMsg InputArea.subscriptions
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ReceiveMessage message ->
        ( { model | messages = message :: model.messages }, scroll "messagesList" )

    InputAreaMsg inputMsg ->
      let
        ( updatedModel, fx ) =
          InputArea.update inputMsg model.inputModel
      in
        ( { model | inputModel = updatedModel }, Cmd.map InputAreaMsg fx)


headerBlock : String -> Html msg
headerBlock title =
  header
    [ class "header-block" ]
    [ h1 [] [ text title ] ]


messagesView : List Message -> Html msg
messagesView messages =
  ul
    [ class "message-list"
    , id "messagesList"
    ]
    (messages
      |> List.reverse
      |> List.map Message.view
    )

messagesBlock : List Message -> Html msg
messagesBlock messages =
  div
    [ class "messages-block" ]
    [ messagesView messages ]


inputBlock : InputArea.Model -> Html Msg
inputBlock model =
  div
    [ class "input-block" ]
    [ App.map InputAreaMsg (InputArea.view model) ]


view : Model -> Html Msg
view model =
  div
    [ class "convo-supreme-container" ]
    [ headerBlock model.title
    , messagesBlock model.messages
    , inputBlock model.inputModel
    ]
