module View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Models exposing (Model, Notification(..), PlayerId)
import Msgs exposing (Msg)
import Players.Edit
import Players.List
import Players.New
import RemoteData


view : Model -> Html Msg
view model =
    div []
        [ notify model, page model ]


notify : Model -> Html Msg
notify model =
    case model.notification of
        NotifyError message ->
            div [ class "h5 px2 white bg-red" ] [ text message ]

        NotifyInfo message ->
            div [ class "h5 px2 white bg-blue" ] [ text message ]

        NotifyEmpty ->
            text ""


page : Model -> Html Msg
page model =
    case model.route of
        Models.PlayersRoute ->
            Players.List.view model.players

        Models.PlayerRoute id ->
            playerEditPage model id

        Models.NewPlayerRoute ->
            Players.New.view model.newPlayerForm

        Models.NotFoundRoute ->
            notFoundView


playerEditPage : Model -> PlayerId -> Html Msg
playerEditPage model playerId =
    case model.players of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading ..."

        RemoteData.Success players ->
            let
                maybePlayer =
                    players
                        |> List.filter (\player -> player.id == playerId)
                        |> List.head
            in
                case maybePlayer of
                    Just player ->
                        Players.Edit.view player

                    Nothing ->
                        notFoundView

        RemoteData.Failure err ->
            text (toString err)


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not Found" ]
