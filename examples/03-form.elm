module Main exposing (Model, Msg(..), init, main, update, validateAge, validatePasswordCharType, validatePasswordLength, validatePasswords, view, viewInput)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , age : String
    , password : String
    , passwordAgain : String
    , isSubmitted : Bool
    }


init : Model
init =
    Model "" "" "" "" False



-- UPDATE


type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name, isSubmitted = False }

        Age age ->
            { model | age = age, isSubmitted = False }

        Password password ->
            { model | password = password, isSubmitted = False }

        PasswordAgain password ->
            { model | passwordAgain = password, isSubmitted = False }

        Submit ->
            { model | isSubmitted = True }



-- VIEW


view : Model -> Html Msg
view model =
    if model.isSubmitted then
        div []
            [ viewInput "text" "Name" model.name Name
            , viewInput "text" "Age" model.age Age
            , viewInput "password" "Password" model.password Password
            , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
            , validateAge model
            , validatePasswords model
            , validatePasswordLength model
            , validatePasswordCharType model
            , button [ onClick Submit ] [ text "submit!" ]
            ]

    else
        div []
            [ viewInput "text" "Name" model.name Name
            , viewInput "text" "Age" model.age Age
            , viewInput "password" "Password" model.password Password
            , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
            , button [ onClick Submit ] [ text "submit!" ]
            ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


validateAge : Model -> Html msg
validateAge model =
    if String.all Char.isDigit model.age then
        div [ style "color" "green" ] [ text "OK. Age is valid" ]

    else
        div [ style "color" "red" ] [ text "Age must be numbers" ]


validatePasswords : Model -> Html msg
validatePasswords model =
    if model.password == model.passwordAgain then
        div [ style "color" "green" ] [ text "OK. Passwords match." ]

    else
        div [ style "color" "red" ] [ text "Passwords do not match!" ]


validatePasswordLength : Model -> Html msg
validatePasswordLength model =
    if String.length model.password > 8 then
        div [ style "color" "green" ] [ text "OK. Password is long enough." ]

    else
        div [ style "color" "red" ] [ text "Password should have more than 8 characters!" ]


validatePasswordCharType : Model -> Html msg
validatePasswordCharType model =
    if String.any Char.isDigit model.password && String.any Char.isLower model.password && String.any Char.isUpper model.password then
        div [ style "color" "green" ] [ text "OK. Password contains upper case, lower case and numbers." ]

    else
        div [ style "color" "red" ] [ text "Password should contain upper case, lower case and numbers!" ]
