port module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Dropdown
import Html exposing (Html, div, h1, text)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode exposing (Decoder, decodeValue, list, string, succeed)
import Json.Decode.Pipeline exposing (required)


fromDictGet : Dict comparableA b -> comparableA -> Maybe b
fromDictGet d a =
    Dict.get a d


type alias MIDI_PortID =
    String


type alias MIDI_Device =
    { name : String
    , manufacturer : String
    , portId : MIDI_PortID
    , version : String
    , connection : String
    }


type alias MIDI_Input_Device =
    MIDI_Device


type alias MIDI_Output_Device =
    MIDI_Device


midi_deviceDecoder : Decoder MIDI_Device
midi_deviceDecoder =
    succeed MIDI_Device
        |> required "name" string
        |> required "manufacturer" string
        |> required "portId" string
        |> required "version" string
        |> required "connection" string


type alias Retrieved_MIDI_Devices =
    { output_devices : List MIDI_Output_Device
    , input_devices : List MIDI_Input_Device
    }


midi_devicesDecoder : Decoder Retrieved_MIDI_Devices
midi_devicesDecoder =
    succeed Retrieved_MIDI_Devices
        |> required "output_devices" (list midi_deviceDecoder)
        |> required "input_devices" (list midi_deviceDecoder)


type alias LFO_Configuration =
    { device : MIDI_Input_Device
    , channel : Int
    , cc : Int
    , value : Int
    }


type alias Model =
    { decode_error : Maybe String
    , midi_input_devices : Dict MIDI_PortID MIDI_Output_Device
    , midi_output_devices : Dict MIDI_PortID MIDI_Input_Device
    , lfo_configuration : Maybe LFO_Configuration
    , tempoDevice : Maybe MIDI_Input_Device
    , bpm : Float
    }


type Msg
    = UpdateMIDIDevices (Result Decode.Error Retrieved_MIDI_Devices)
    | LFO_Value_Change Int
    | LFO_MIDI_channel Int
    | LFO_MIDI_CC Int
    | LFO_MIDI_Device (Maybe MIDI_PortID)
    | GeneralError String
    | RecievedExternalTempo Float
    | SetTempoDevice (Maybe MIDI_PortID)


port initializeMIDI : () -> Cmd msg


port errorAlert : String -> Cmd msg


port setTempoDevice : Maybe MIDI_PortID -> Cmd msg


port set_LFO_Device : Maybe MIDI_PortID -> Cmd msg


port all_MIDI_Devices : (Decode.Value -> msg) -> Sub msg


port setExternalTempo : (Float -> msg) -> Sub msg


initialModel : Model
initialModel =
    { decode_error = Nothing
    , midi_input_devices = Dict.empty
    , midi_output_devices = Dict.empty
    , lfo_configuration = Nothing
    , tempoDevice = Nothing
    , bpm = 100.0
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel
    , initializeMIDI ()
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ lfo_configuration, midi_output_devices, midi_input_devices } as model) =
    case msg of
        UpdateMIDIDevices (Ok retrieved_midi_devices) ->
            let
                input_devices =
                    retrieved_midi_devices
                        |> .input_devices
                        |> List.map (\({ portId } as device) -> ( portId, device ))
                        |> Dict.fromList

                output_devices =
                    retrieved_midi_devices
                        |> .output_devices
                        |> List.map (\({ portId } as device) -> ( portId, device ))
                        |> Dict.fromList
            in
            ( { model
                | midi_input_devices = input_devices
                , midi_output_devices = output_devices
              }
            , Cmd.none
            )

        UpdateMIDIDevices (Err errorMessage) ->
            ( model, errorAlert (Decode.errorToString errorMessage) )

        GeneralError message ->
            ( model, errorAlert message )

        LFO_MIDI_Device (Just midi_portId) ->
            Dict.get midi_portId midi_output_devices
                |> Maybe.map
                    (\device ->
                        let
                            newConfiguration =
                                lfo_configuration
                                    |> Maybe.map (\configuration -> { configuration | device = device })
                                    |> Maybe.withDefault { device = device, channel = 0, cc = 0, value = 2500 }
                        in
                        ( { model | lfo_configuration = Just newConfiguration }, set_LFO_Device (Just device.portId) )
                    )
                |> Maybe.withDefault ( model, errorAlert ("device with portId " ++ midi_portId ++ " not found!") )

        LFO_MIDI_Device Nothing ->
            ( { model | lfo_configuration = Nothing }, set_LFO_Device Nothing )

        LFO_Value_Change value ->
            ( { model | lfo_configuration = lfo_configuration |> Maybe.map (\c -> { c | value = value }) }
            , Cmd.none
            )

        LFO_MIDI_channel channel ->
            ( { model | lfo_configuration = lfo_configuration |> Maybe.map (\c -> { c | channel = channel }) }
            , Cmd.none
            )

        LFO_MIDI_CC cc ->
            ( { model | lfo_configuration = lfo_configuration |> Maybe.map (\c -> { c | cc = cc }) }
            , Cmd.none
            )

        RecievedExternalTempo bpm ->
            ( { model | bpm = bpm }, Cmd.none )

        SetTempoDevice Nothing ->
            ( { model | tempoDevice = Nothing }, setTempoDevice Nothing )

        SetTempoDevice (Just midi_portId) ->
            Dict.get midi_portId midi_input_devices
                |> Maybe.map
                    (\device ->
                        ( { model | tempoDevice = Just device }, setTempoDevice (Just midi_portId) )
                    )
                |> Maybe.withDefault ( model, errorAlert ("device with portId " ++ midi_portId ++ " not found!") )


deviceDropdown :
    { attrs : List (Html.Attribute Msg)
    , toMsg : Maybe MIDI_PortID -> Msg
    , defaultOption : String
    , midi_devices : Dict MIDI_PortID MIDI_Device
    }
    -> Html Msg
deviceDropdown { attrs, toMsg, defaultOption, midi_devices } =
    let
        mkItem : MIDI_Device -> Dropdown.Item
        mkItem =
            \item -> { value = item.portId, text = item.name, enabled = True }

        optionItems : List Dropdown.Item
        optionItems =
            midi_devices
                |> Dict.values
                |> List.map mkItem

        defaultSelection : MIDI_PortID
        defaultSelection =
            ""

        emptyItem : Dropdown.Item
        emptyItem =
            { value = defaultSelection, text = defaultOption, enabled = True }

        options : Dropdown.Options Msg
        options =
            { items = optionItems
            , emptyItem = Just emptyItem
            , onChange = toMsg
            }
    in
    Dropdown.dropdown options attrs (Just defaultSelection)


numberDropdown : List (Html.Attribute msg) -> (Int -> msg) -> String -> Int -> Int -> Html msg
numberDropdown attrs toMsg label from to =
    let
        mkItem : String -> Dropdown.Item
        mkItem =
            \n -> { value = n, text = label ++ ": " ++ n, enabled = True }

        optionItems : List Dropdown.Item
        optionItems =
            List.range from to |> List.map (String.fromInt >> mkItem)

        defaultSelection : Int
        defaultSelection =
            0

        onChange : Maybe String -> msg
        onChange =
            Maybe.andThen String.toInt
                >> Maybe.map toMsg
                >> Maybe.withDefault (toMsg defaultSelection)

        options : Dropdown.Options msg
        options =
            { items = optionItems
            , emptyItem = Nothing
            , onChange = onChange
            }
    in
    Dropdown.dropdown options attrs (Just (String.fromInt defaultSelection))


switchOnOff : Bool -> String -> (Bool -> msg) -> Html msg
switchOnOff on name toMsg =
    div []
        [ Html.label []
            [ Html.input [ Attr.type_ "radio", Attr.checked (not on), Attr.name name, Events.onClick (toMsg False) ] []
            , text "Off"
            ]
        , Html.label []
            [ Html.input [ Attr.type_ "radio", Attr.checked on, Attr.name name, Events.onClick (toMsg True) ] []
            , text "On"
            ]
        ]


view : Model -> Html Msg
view { midi_input_devices, midi_output_devices, bpm, lfo_configuration } =
    div []
        [ div [] [ text "INPUT PORTS" ]
        , div [] (midi_input_devices |> Dict.values |> List.map (\{ name, portId } -> div [] [ text (name ++ " " ++ portId) ]))
        , div [] [ text "OUTPUT PORTS" ]
        , div [] (midi_output_devices |> Dict.values |> List.map (\{ name, portId } -> div [] [ text (name ++ " " ++ portId) ]))
        , div
            []
            [ h1 [] [ text ("BPM: " ++ String.fromFloat bpm) ]
            , deviceDropdown
                { attrs = []
                , toMsg = SetTempoDevice
                , defaultOption = "Internal tempo"
                , midi_devices = midi_input_devices
                }
            ]
        , div []
            [ h1 [] [ text "LFO" ]
            , deviceDropdown
                { attrs = []
                , toMsg = LFO_MIDI_Device
                , defaultOption = "No LFO device"
                , midi_devices = midi_output_devices
                }
            , numberDropdown [] LFO_MIDI_channel "MIDI Channel" 0 15
            , numberDropdown [] LFO_MIDI_CC "MIDI CC" 0 255
            , Html.input
                [ Attr.type_ "range"
                , Attr.min "1"
                , Attr.max "5000"
                , Attr.value (lfo_configuration |> Maybe.map (.value >> String.fromInt) |> Maybe.withDefault "1")
                , Events.onInput (String.toInt >> Maybe.withDefault 0 >> LFO_Value_Change)
                ]
                []
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions =
            \model ->
                Sub.batch
                    [ all_MIDI_Devices (decodeValue midi_devicesDecoder >> UpdateMIDIDevices)
                    , setExternalTempo RecievedExternalTempo
                    ]
        }
