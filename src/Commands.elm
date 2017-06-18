module Commands exposing (..)

import Http
import Json.Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (PlayerId, Player)
import RemoteData


fetchPlayers : Cmd Msg
fetchPlayers =
    Http.get fetchPlayersUrl playersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchPlayers


fetchPlayersUrl : String
fetchPlayersUrl =
    "http://localhost:3000/players"


playersDecoder : Json.Decode.Decoder (List Player)
playersDecoder =
    Json.Decode.list playerDecoder


playerDecoder : Json.Decode.Decoder Player
playerDecoder =
    decode Player
        |> required "id" Json.Decode.string
        |> required "name" Json.Decode.string
        |> required "level" Json.Decode.int
