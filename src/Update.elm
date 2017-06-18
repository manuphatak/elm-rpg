module Update exposing (..)

import Commands exposing (savePlayerCmd)
import Models exposing (Model, Notification(..), Player)
import Msgs exposing (Msg(..))
import RemoteData
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            ( { model | players = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute, notification = NotifyEmpty }, Cmd.none )

        Msgs.ChangeLevel player delta ->
            let
                updatedPlayer =
                    { player | level = player.level + delta }
            in
                ( model, savePlayerCmd updatedPlayer )

        Msgs.OnPlayerSave (Ok player) ->
            ( updatePlayer model player, Cmd.none )

        Msgs.OnPlayerSave (Err error) ->
            let
                notification =
                    NotifyError "Something went wrong, please try again."
            in
                ( { model | notification = notification }, Cmd.none )


updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
    let
        pick currentPlayer =
            if updatedPlayer.id == currentPlayer.id then
                updatedPlayer
            else
                currentPlayer

        updatePlayerList players =
            List.map pick players

        updatedPlayers =
            RemoteData.map updatePlayerList model.players
    in
        { model | players = updatedPlayers, notification = NotifyEmpty }
