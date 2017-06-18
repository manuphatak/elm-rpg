module Models exposing (..)

import RemoteData exposing (WebData)


type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute


type Notification
    = NotifyEmpty
    | NotifyError String


type alias Model =
    { players : WebData (List Player)
    , route : Route
    , notification : Notification
    }


initialModel : Route -> Model
initialModel route =
    { players = RemoteData.Loading
    , route = route
    , notification = NotifyEmpty
    }


type alias PlayerId =
    String


type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }
