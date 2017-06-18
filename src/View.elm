module View exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)
import Html exposing (Html, div, text)


view : Model -> Html Msg
view model =
    div []
        [ text model ]
