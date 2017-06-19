module Msgs exposing (..)

import Http
import Models exposing (NewPlayerForm, Player, PlayerId)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)
    | DeletePlayer Player
    | OnPlayerDelete (Result Http.Error PlayerId)
    | UpdateNewPlayerForm NewPlayerForm
    | CreatePlayer NewPlayerForm
    | OnPlayerCreate (Result Http.Error Player)
