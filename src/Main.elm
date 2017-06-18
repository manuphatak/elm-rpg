module Main exposing (..)

import Html exposing (program)
import Models exposing (Model, initialModel)
import Msgs exposing (Msg)
import Update exposing (update)
import View exposing (view)
import Commands exposing (fetchPlayers)


-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchPlayers )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
