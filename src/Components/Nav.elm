module Components.Nav exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Msgs exposing (Msg)
import Routing exposing (playersPath)


view : Html Msg
view =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ listBtn ]


listBtn : Html Msg
listBtn =
    a [ class "btn regular", href playersPath ]
        [ i [ class " fa fa-chevron-left mr1" ] [], text "Players" ]
