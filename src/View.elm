module View exposing (..)

import Html exposing (Html, text, div)
import Models exposing (Model)
import Messages exposing (Msg)


view : Model -> Html Msg
view model =
    div []
        [ text model ]
