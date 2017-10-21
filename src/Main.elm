module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http exposing (..)
import Json.Decode exposing (Decoder, field, list, int, string)
import Json.Decode.Pipeline exposing (decode, required)
import Debug exposing (log)


type Msg
    = PrepareRequest String
    | RequestSend (Result Http.Error Response)


type alias ResponseData =
    { count : List Int
    }


type alias Response =
    { data : ResponseData
    }


responseDataDecoder : Json.Decode.Decoder ResponseData
responseDataDecoder =
    decode ResponseData
        |> Json.Decode.Pipeline.required "count" (Json.Decode.list int)

responseDecoder : Json.Decode.Decoder Response
responseDecoder =
    decode Response
        |> Json.Decode.Pipeline.required "data" responseDataDecoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PrepareRequest req ->
            ( model, requestSend req )

        RequestSend result ->
            case result of
                Ok response ->
                    let _ = log "RequestSend Ok" response
                    in
                    ({ model | count = response.data.count }, Cmd.none )
                Err error ->
                    let _ = log "RequestSend Err" error
                    in
                    ( model, Cmd.none )


requestSend : String -> Cmd Msg
requestSend msg =
    let
        requestUrl =
            "http://localhost:3000/api/" ++ msg

        request =
            Http.post requestUrl Http.emptyBody responseDecoder

    in
    Http.send RequestSend request


type alias Model =
    { count : List Int
    }


init : ( Model, Cmd Msg )
init =
    ( { count = [] }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (toString model.count) ]
        , button [ onClick (PrepareRequest "stage") ] [ text "Stage" ]
        , button [ onClick (PrepareRequest "commit") ] [ text "Commit" ]
        , button [ onClick (PrepareRequest "abort") ] [ text "Abort" ]
        ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
