module Update exposing (..)

import Commands exposing (createPlayerCmd, deletePlayerCmd, savePlayerCmd)
import Models exposing (Model, NewPlayerForm, Notification(..), Player, PlayerId)
import Msgs exposing (Msg(..))
import Navigation exposing (newUrl)
import RemoteData
import Routing exposing (parseLocation, playersPath)


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

        Msgs.OnPlayerSave (Err _) ->
            ( { model | notification = defaultError }, Cmd.none )

        Msgs.DeletePlayer player ->
            ( model, deletePlayerCmd player )

        Msgs.OnPlayerDelete (Ok playerId) ->
            ( deletePlayer model playerId, Cmd.none )

        Msgs.OnPlayerDelete (Err _) ->
            ( { model | notification = defaultError }, Cmd.none )

        Msgs.UpdateNewPlayerForm newPlayerForm ->
            ( { model | newPlayerForm = newPlayerForm }, Cmd.none )

        Msgs.CreatePlayer newPlayerForm ->
            ( model, createPlayerCmd newPlayerForm )

        Msgs.OnPlayerCreate (Ok player) ->
            ( createPlayer model player, newUrl playersPath )

        Msgs.OnPlayerCreate (Err _) ->
            ( { model | notification = defaultError }, Cmd.none )


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
        { model | players = updatedPlayers, notification = NotifyEmpty, notification = defaultSuccess }


deletePlayer : Model -> PlayerId -> Model
deletePlayer model playerId =
    let
        players =
            case model.players of
                RemoteData.Success players ->
                    players
                        |> List.filter (.id >> (/=) playerId)
                        |> RemoteData.succeed

                _ ->
                    model.players
    in
        { model | players = players, notification = defaultSuccess }


createPlayer : Model -> Player -> Model
createPlayer model player =
    let
        players =
            case model.players of
                RemoteData.Success players ->
                    RemoteData.succeed <| player :: players

                _ ->
                    model.players

        newPlayerForm =
            NewPlayerForm "" ""
    in
        { model | players = players, newPlayerForm = newPlayerForm }


defaultError : Notification
defaultError =
    NotifyError "Something went wrong, please try again."


defaultSuccess : Notification
defaultSuccess =
    NotifyInfo "Something went right!"
