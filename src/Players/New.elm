module Players.New exposing (..)

import Components.Nav
import Html exposing (..)
import Html.Attributes exposing (class, for, id, placeholder, required, style, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Models exposing (NewPlayerForm)
import Msgs exposing (Msg)


view : NewPlayerForm -> Html Msg
view model =
    div []
        [ Components.Nav.view
        , newPlayerForm model
        ]


newPlayerForm : NewPlayerForm -> Html Msg
newPlayerForm player =
    form [ class "clearfix py1 flex items-center", onSubmit <| Msgs.CreatePlayer player ]
        [ div []
            [ label [ for "name", class "hide" ] [ text "Name" ]
            , input [ type_ "text", id "name", class "input not-rounded m0", placeholder "Name", required True, value player.name, onInput <| handleNameInput player ] []
            ]
        , div []
            [ label [ for "level", class "hide" ] [ text "Level" ]
            , input [ type_ "number", id "level", class "input not-rounded m0", placeholder "Level", required True, value player.level, onInput <| handleLevelInput player ] []
            ]
        , div []
            [ button [ type_ "submit", class "btn not-rounded btn-outline ml1" ] [ text "Create" ]
            ]
        ]


handleNameInput : NewPlayerForm -> String -> Msg
handleNameInput newPlayerForm name =
    Msgs.UpdateNewPlayerForm { newPlayerForm | name = name }


handleLevelInput : NewPlayerForm -> String -> Msg
handleLevelInput newPlayerForm level =
    Msgs.UpdateNewPlayerForm { newPlayerForm | level = level }
