module Models exposing (..)

import RemoteData exposing (WebData)


type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NewPlayerRoute
    | NotFoundRoute


type Notification
    = NotifyEmpty
    | NotifyError String


type alias Model =
    { players : WebData (List Player)
    , route : Route
    , notification : Notification
    , newPlayerForm : NewPlayerForm
    }


initialModel : Route -> Model
initialModel route =
    { players = RemoteData.Loading
    , route = route
    , notification = NotifyEmpty
    , newPlayerForm = NewPlayerForm "" ""
    }


type alias PlayerId =
    String


type alias PlayerName =
    String


type alias Player =
    { id : PlayerId
    , name : PlayerName
    , level : Int
    }


type alias NewPlayerForm =
    { name : PlayerName
    , level : String
    }
