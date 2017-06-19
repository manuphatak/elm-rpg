module Commands exposing (..)

import Http
import Json.Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode
import Models exposing (NewPlayerForm, Player, PlayerId)
import Msgs exposing (Msg)
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


playerDetailsUrl : PlayerId -> String
playerDetailsUrl playerId =
    "http://localhost:3000/players/" ++ playerId


playersUrl : String
playersUrl =
    "http://localhost:3000/players"


savePlayerRequest : Player -> Http.Request Player
savePlayerRequest player =
    Http.request
        { body = playerEncoder player |> Http.jsonBody
        , expect = Http.expectJson playerDecoder
        , headers = []
        , method = "PATCH"
        , timeout = Nothing
        , url = playerDetailsUrl player.id
        , withCredentials = False
        }


savePlayerCmd : Player -> Cmd Msg
savePlayerCmd player =
    savePlayerRequest player
        |> Http.send Msgs.OnPlayerSave


deletePlayerRequest : Player -> Http.Request PlayerId
deletePlayerRequest player =
    Http.request
        { body = Http.emptyBody
        , expect = Http.expectStringResponse << always <| Ok player.id
        , headers = []
        , method = "DELETE"
        , timeout = Nothing
        , url = playerDetailsUrl player.id
        , withCredentials = False
        }


deletePlayerCmd : Player -> Cmd Msg
deletePlayerCmd player =
    deletePlayerRequest player
        |> Http.send Msgs.OnPlayerDelete


createPlayerRequest : NewPlayerForm -> Http.Request Player
createPlayerRequest newPlayerForm =
    Http.request
        { body = newPlayerFormEncoder newPlayerForm |> Http.jsonBody
        , expect = Http.expectJson playerDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = playersUrl
        , withCredentials = False
        }


createPlayerCmd : NewPlayerForm -> Cmd Msg
createPlayerCmd newPlayerForm =
    createPlayerRequest newPlayerForm
        |> Http.send Msgs.OnPlayerCreate


playerEncoder : Player -> Json.Encode.Value
playerEncoder player =
    let
        attributes =
            [ ( "id", Json.Encode.string player.id )
            , ( "name", Json.Encode.string player.name )
            , ( "level", Json.Encode.int player.level )
            ]
    in
        Json.Encode.object attributes


newPlayerFormEncoder : NewPlayerForm -> Json.Encode.Value
newPlayerFormEncoder newPlayerForm =
    let
        attributes =
            [ ( "name", Json.Encode.string newPlayerForm.name )
            , ( "level", Json.Encode.int (String.toInt newPlayerForm.level |> Result.toMaybe |> Maybe.withDefault 1) )
            ]
    in
        Json.Encode.object attributes
