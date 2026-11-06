{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 9,
      "minor": 2,
      "revision": 0,
      "architecture": "arm64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      60,
      70,
      1084,
      736
    ],
    "openinpresentation": 1,
    "gridsize": [
      8,
      8
    ],
    "isolateaudio": 1,
    "description": "Four-window sample instrument with modulation, mix effects and stereo capture",
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "varname": "title",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            16,
            16,
            140,
            20
          ],
          "text": "FIELD KIT",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            16,
            16,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-2",
          "varname": "source_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            160,
            20,
            524,
            20
          ],
          "text": "Loading demo…",
          "presentation": 1,
          "presentation_rect": [
            160,
            20,
            524,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-3",
          "varname": "output_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            16,
            92,
            20
          ],
          "text": "Audio output",
          "presentation": 1,
          "presentation_rect": [
            688,
            16,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-4",
          "varname": "status",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            46,
            380,
            20
          ],
          "text": "Loading the demo…",
          "presentation": 1,
          "presentation_rect": [
            688,
            46,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-5",
          "varname": "standalone",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            30,
            2080,
            754,
            22
          ],
          "text": "standalone @bundleidentifier audio.poeticstate.fieldkit @preffilename FieldKit @gensupport 1 @cefsupport 0"
        }
      },
      {
        "box": {
          "id": "obj-6",
          "varname": "source_control",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 4,
          "patching_rect": [
            24,
            808,
            117,
            22
          ],
          "text": "js fk_source.js",
          "outlettype": [
            "list",
            "list",
            "list",
            "list"
          ]
        }
      },
      {
        "box": {
          "id": "obj-7",
          "varname": "initialize",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            200,
            808,
            145,
            22
          ],
          "text": "loadmess initialize",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-8",
          "varname": "audio_file",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            400,
            808,
            82,
            22
          ],
          "text": "opendialog",
          "outlettype": [
            "",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-9",
          "varname": "load_path",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            400,
            846,
            145,
            22
          ],
          "text": "prepend open_source",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-10",
          "varname": "buffer",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            630,
            808,
            138,
            22
          ],
          "text": "buffer~ fk-unbound",
          "outlettype": [
            "float",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-11",
          "varname": "source_info",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 10,
          "patching_rect": [
            880,
            808,
            47,
            22
          ],
          "text": "info~",
          "outlettype": [
            "float",
            "list",
            "float",
            "float",
            "float",
            "float",
            "float",
            "",
            "int",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-12",
          "varname": "buffer_complete",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            630,
            846,
            159,
            22
          ],
          "text": "prepend source_loaded",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-13",
          "varname": "dsp_state",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 4,
          "patching_rect": [
            1130,
            808,
            75,
            22
          ],
          "text": "dspstate~",
          "outlettype": [
            "int",
            "float",
            "int",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-14",
          "varname": "dsp_enabled",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1130,
            846,
            145,
            22
          ],
          "text": "prepend dsp_enabled"
        }
      },
      {
        "box": {
          "id": "obj-15",
          "varname": "source_rate",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            880,
            846,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-16",
          "varname": "load",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            40,
            140,
            32
          ],
          "mode": 0,
          "text": "Load audio…",
          "texton": "Load audio…",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            40,
            140,
            32
          ]
        }
      },
      {
        "box": {
          "id": "obj-17",
          "varname": "load_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            24,
            728,
            68,
            22
          ],
          "text": "sel bang",
          "outlettype": [
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-18",
          "varname": "load_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            24,
            766,
            140,
            22
          ],
          "text": "choose"
        }
      },
      {
        "box": {
          "id": "obj-19",
          "varname": "demo",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            40,
            92,
            32
          ],
          "mode": 0,
          "text": "Load demo",
          "texton": "Load demo",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            40,
            92,
            32
          ]
        }
      },
      {
        "box": {
          "id": "obj-20",
          "varname": "demo_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            354,
            728,
            68,
            22
          ],
          "text": "sel bang",
          "outlettype": [
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-21",
          "varname": "demo_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            354,
            766,
            140,
            22
          ],
          "text": "load_demo"
        }
      },
      {
        "box": {
          "id": "obj-22",
          "varname": "play",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            256,
            40,
            140,
            32
          ],
          "mode": 0,
          "text": "▶  Play all",
          "texton": "▶  Play all",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            256,
            40,
            140,
            32
          ]
        }
      },
      {
        "box": {
          "id": "obj-23",
          "varname": "play_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            574,
            728,
            68,
            22
          ],
          "text": "sel bang",
          "outlettype": [
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-24",
          "varname": "play_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            574,
            766,
            140,
            22
          ],
          "text": "play_all"
        }
      },
      {
        "box": {
          "id": "obj-25",
          "varname": "stop",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            400,
            40,
            92,
            32
          ],
          "mode": 0,
          "text": "■  Stop all",
          "texton": "■  Stop all",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            400,
            40,
            92,
            32
          ]
        }
      },
      {
        "box": {
          "id": "obj-26",
          "varname": "stop_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            904,
            728,
            68,
            22
          ],
          "text": "sel bang",
          "outlettype": [
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-27",
          "varname": "stop_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            904,
            766,
            140,
            22
          ],
          "text": "stop_all"
        }
      },
      {
        "box": {
          "id": "obj-28",
          "varname": "normal",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            496,
            40,
            92,
            32
          ],
          "mode": 0,
          "text": "Play normal",
          "texton": "Play normal",
          "parameter_enable": 0,
          "hint": "Play the original sample once at normal speed with effects bypassed.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            496,
            40,
            92,
            32
          ]
        }
      },
      {
        "box": {
          "id": "obj-29",
          "varname": "normal_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1124,
            728,
            68,
            22
          ],
          "text": "sel bang",
          "outlettype": [
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-30",
          "varname": "normal_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1124,
            766,
            140,
            22
          ],
          "text": "play_normal"
        }
      },
      {
        "box": {
          "id": "obj-31",
          "varname": "pattern_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            16,
            88,
            92,
            20
          ],
          "text": "Patterns",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            16,
            88,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-32",
          "varname": "pattern_control",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1550,
            2010,
            131,
            22
          ],
          "text": "js fk_patterns.js"
        }
      },
      {
        "box": {
          "id": "obj-33",
          "varname": "pattern_1",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            88,
            44,
            44
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "1",
          "texton": "1",
          "parameter_enable": 0,
          "hint": "Recall pattern 1 if this square has a dot. Click Store pattern first to save here.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            88,
            44,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-34",
          "varname": "pattern_click_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1540,
            1920,
            42,
            22
          ],
          "text": "t b",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-35",
          "varname": "pattern_slot_1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1540,
            1960,
            70,
            22
          ],
          "text": "slot 1"
        }
      },
      {
        "box": {
          "id": "obj-36",
          "varname": "pattern_2",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            88,
            44,
            44
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "2",
          "texton": "2",
          "parameter_enable": 0,
          "hint": "Recall pattern 2 if this square has a dot. Click Store pattern first to save here.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            88,
            44,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-37",
          "varname": "pattern_click_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1652,
            1920,
            42,
            22
          ],
          "text": "t b",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-38",
          "varname": "pattern_slot_2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1652,
            1960,
            70,
            22
          ],
          "text": "slot 2"
        }
      },
      {
        "box": {
          "id": "obj-39",
          "varname": "pattern_3",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            88,
            44,
            44
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "3",
          "texton": "3",
          "parameter_enable": 0,
          "hint": "Recall pattern 3 if this square has a dot. Click Store pattern first to save here.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            88,
            44,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-40",
          "varname": "pattern_click_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1764,
            1920,
            42,
            22
          ],
          "text": "t b",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-41",
          "varname": "pattern_slot_3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1764,
            1960,
            70,
            22
          ],
          "text": "slot 3"
        }
      },
      {
        "box": {
          "id": "obj-42",
          "varname": "pattern_4",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            256,
            88,
            44,
            44
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "4",
          "texton": "4",
          "parameter_enable": 0,
          "hint": "Recall pattern 4 if this square has a dot. Click Store pattern first to save here.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            256,
            88,
            44,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-43",
          "varname": "pattern_click_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1876,
            1920,
            42,
            22
          ],
          "text": "t b",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-44",
          "varname": "pattern_slot_4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1876,
            1960,
            70,
            22
          ],
          "text": "slot 4"
        }
      },
      {
        "box": {
          "id": "obj-45",
          "varname": "pattern_5",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            304,
            88,
            44,
            44
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "5",
          "texton": "5",
          "parameter_enable": 0,
          "hint": "Recall pattern 5 if this square has a dot. Click Store pattern first to save here.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            304,
            88,
            44,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-46",
          "varname": "pattern_click_5",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1988,
            1920,
            42,
            22
          ],
          "text": "t b",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-47",
          "varname": "pattern_slot_5",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1988,
            1960,
            70,
            22
          ],
          "text": "slot 5"
        }
      },
      {
        "box": {
          "id": "obj-48",
          "varname": "pattern_6",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            352,
            88,
            44,
            44
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "6",
          "texton": "6",
          "parameter_enable": 0,
          "hint": "Recall pattern 6 if this square has a dot. Click Store pattern first to save here.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            352,
            88,
            44,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-49",
          "varname": "pattern_click_6",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            1920,
            42,
            22
          ],
          "text": "t b",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-50",
          "varname": "pattern_slot_6",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            1960,
            70,
            22
          ],
          "text": "slot 6"
        }
      },
      {
        "box": {
          "id": "obj-51",
          "varname": "pattern_7",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            400,
            88,
            44,
            44
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "7",
          "texton": "7",
          "parameter_enable": 0,
          "hint": "Recall pattern 7 if this square has a dot. Click Store pattern first to save here.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            400,
            88,
            44,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-52",
          "varname": "pattern_click_7",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2212,
            1920,
            42,
            22
          ],
          "text": "t b",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-53",
          "varname": "pattern_slot_7",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2212,
            1960,
            70,
            22
          ],
          "text": "slot 7"
        }
      },
      {
        "box": {
          "id": "obj-54",
          "varname": "pattern_8",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            448,
            88,
            44,
            44
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "8",
          "texton": "8",
          "parameter_enable": 0,
          "hint": "Recall pattern 8 if this square has a dot. Click Store pattern first to save here.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            448,
            88,
            44,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-55",
          "varname": "pattern_click_8",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2324,
            1920,
            42,
            22
          ],
          "text": "t b",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-56",
          "varname": "pattern_slot_8",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2324,
            1960,
            70,
            22
          ],
          "text": "slot 8"
        }
      },
      {
        "box": {
          "id": "obj-57",
          "varname": "pattern_store",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            496,
            88,
            188,
            44
          ],
          "mode": 0,
          "text": "Store pattern",
          "texton": "Store pattern",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            496,
            88,
            188,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-58",
          "varname": "pattern_store_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1675,
            2000,
            68,
            22
          ],
          "text": "sel bang",
          "outlettype": [
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-59",
          "varname": "pattern_toggle_store",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1675,
            2035,
            100,
            22
          ],
          "text": "toggle_store"
        }
      },
      {
        "box": {
          "id": "obj-60",
          "varname": "pattern_status",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            112,
            380,
            20
          ],
          "text": "Click Store pattern, then choose a square.",
          "presentation": 1,
          "presentation_rect": [
            688,
            112,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-61",
          "varname": "pattern_load",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            688,
            88,
            188,
            20
          ],
          "mode": 0,
          "text": "Load bank…",
          "texton": "Load bank…",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            688,
            88,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-62",
          "varname": "pattern_load_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            2090,
            80,
            22
          ],
          "text": "load_bank"
        }
      },
      {
        "box": {
          "id": "obj-63",
          "varname": "pattern_load_dialog",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1520,
            2125,
            117,
            22
          ],
          "text": "opendialog JSON",
          "outlettype": [
            "",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-64",
          "varname": "pattern_load_result",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            2160,
            131,
            22
          ],
          "text": "prepend read_bank"
        }
      },
      {
        "box": {
          "id": "obj-65",
          "varname": "pattern_save",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            880,
            88,
            188,
            20
          ],
          "mode": 0,
          "text": "Save bank…",
          "texton": "Save bank…",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            880,
            88,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-66",
          "varname": "pattern_save_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            2090,
            80,
            22
          ],
          "text": "save_bank"
        }
      },
      {
        "box": {
          "id": "obj-67",
          "varname": "pattern_save_dialog",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1720,
            2125,
            117,
            22
          ],
          "text": "savedialog JSON",
          "outlettype": [
            "",
            "",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-68",
          "varname": "pattern_save_result",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1720,
            2160,
            138,
            22
          ],
          "text": "prepend write_bank"
        }
      },
      {
        "box": {
          "id": "obj-69",
          "varname": "reset",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            592,
            40,
            92,
            32
          ],
          "mode": 0,
          "text": "Reset",
          "texton": "Reset",
          "parameter_enable": 0,
          "hint": "Stop and restore the default loop, modulation and effects settings. Saved patterns stay in their squares.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            592,
            40,
            92,
            32
          ]
        }
      },
      {
        "box": {
          "id": "obj-70",
          "varname": "reset_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1344,
            728,
            68,
            22
          ],
          "text": "sel bang",
          "outlettype": [
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-71",
          "varname": "reset_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1344,
            766,
            140,
            22
          ],
          "text": "reset"
        }
      },
      {
        "box": {
          "id": "obj-72",
          "varname": "audio_setup",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            928,
            16,
            140,
            20
          ],
          "text": "Audio Setup…",
          "texton": "Audio Setup…",
          "mode": 0,
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            928,
            16,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-73",
          "varname": "open_audio_setup",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1420,
            804,
            110,
            22
          ],
          "text": "; dsp open"
        }
      },
      {
        "box": {
          "id": "obj-74",
          "varname": "master_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            784,
            604,
            92,
            20
          ],
          "text": "Master",
          "presentation": 1,
          "presentation_rect": [
            784,
            604,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-75",
          "varname": "master",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            880,
            604,
            44,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Master",
              "parameter_shortname": "Master",
              "parameter_type": 0,
              "parameter_mmin": -70,
              "parameter_mmax": 0,
              "parameter_initial": [
                -12
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 4
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            880,
            604,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-76",
          "varname": "audio_switch",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            784,
            16,
            140,
            20
          ],
          "text": "Enable audio",
          "texton": "Audio on",
          "mode": 1,
          "hint": "Play starts audio automatically. Click here to enable audio alone or turn audio off.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Audio engine",
              "parameter_shortname": "Audio engine",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Off",
                "On"
              ]
            }
          },
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            784,
            16,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-77",
          "varname": "set_audio",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1270,
            808,
            131,
            22
          ],
          "text": "prepend set_audio"
        }
      },
      {
        "box": {
          "id": "obj-78",
          "varname": "dac",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "patching_rect": [
            360,
            1958,
            68,
            22
          ],
          "text": "dac~ 1 2"
        }
      },
      {
        "box": {
          "id": "obj-79",
          "varname": "mix_meter",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            928,
            604,
            140,
            20
          ],
          "orientation": 1,
          "hint": "Post-effects master peak. Capture records this signal.",
          "outlettype": [
            "float",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            928,
            604,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-80",
          "varname": "mix_peak",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            640,
            1958,
            68,
            22
          ],
          "text": "maximum~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-81",
          "varname": "master_amplitude",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            22,
            1840,
            47,
            22
          ],
          "text": "dbtoa",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-82",
          "varname": "master_ramp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            105,
            1840,
            82,
            22
          ],
          "text": "pack 0. 20"
        }
      },
      {
        "box": {
          "id": "obj-83",
          "varname": "master_gain",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            220,
            1840,
            138,
            22
          ],
          "text": "line~ 0.2511886432",
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-84",
          "varname": "mix_fx",
          "maxclass": "bpatcher",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            16,
            604,
            668,
            116
          ],
          "outlettype": [
            "signal",
            "signal"
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            604,
            668,
            116
          ],
          "name": "fk_fx.maxpat",
          "args": [],
          "offset": [
            0.0,
            0.0
          ],
          "border": 0,
          "clickthrough": 0,
          "enablehscroll": 0,
          "enablevscroll": 0,
          "lockeddragscroll": 0
        }
      },
      {
        "box": {
          "id": "obj-85",
          "varname": "recorder",
          "maxclass": "bpatcher",
          "numinlets": 2,
          "numoutlets": 0,
          "patching_rect": [
            688,
            604,
            380,
            116
          ],
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            688,
            604,
            380,
            116
          ],
          "name": "fk_record.maxpat",
          "args": [],
          "offset": [
            0.0,
            0.0
          ],
          "border": 0,
          "clickthrough": 0,
          "enablehscroll": 0,
          "enablevscroll": 0,
          "lockeddragscroll": 0
        }
      },
      {
        "box": {
          "id": "obj-86",
          "varname": "normal_voice",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1100,
            1800,
            138,
            22
          ],
          "text": "play~ fk-unbound 2",
          "outlettype": [
            "signal",
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-87",
          "varname": "normal_done",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1240,
            1840,
            115,
            22
          ],
          "text": "normal_finished"
        }
      },
      {
        "box": {
          "id": "obj-88",
          "varname": "normal_right_channel",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1100,
            1840,
            103,
            22
          ],
          "text": "selector~ 2 2",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-89",
          "varname": "normal_mix_l",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            820,
            1880,
            103,
            22
          ],
          "text": "selector~ 2 1",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-90",
          "varname": "master_left",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            360,
            1840,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-91",
          "varname": "output_left",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            360,
            1880,
            124,
            22
          ],
          "text": "clip~ -0.99 0.99",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-92",
          "varname": "output_peak_left",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            640,
            1920,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-93",
          "varname": "normal_mix_r",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            960,
            1880,
            103,
            22
          ],
          "text": "selector~ 2 1",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-94",
          "varname": "master_right",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            500,
            1840,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-95",
          "varname": "output_right",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            500,
            1880,
            124,
            22
          ],
          "text": "clip~ -0.99 0.99",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-96",
          "varname": "output_peak_right",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            780,
            1920,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-97",
          "varname": "mixer_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            16,
            148,
            188,
            20
          ],
          "text": "Performance mixer",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            16,
            148,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-98",
          "varname": "mixer_control",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            1560,
            1880,
            110,
            22
          ],
          "text": "js fk_mixer.js"
        }
      },
      {
        "box": {
          "id": "obj-99",
          "varname": "mixer_clear_solo",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            148,
            44,
            20
          ],
          "mode": 0,
          "active": 0,
          "text": "Unsolo",
          "texton": "Unsolo",
          "parameter_enable": 0,
          "hint": "Clear all solo buttons and return to the current mute mix.",
          "outlettype": [
            "bang",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            148,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-100",
          "varname": "mixer_unsolo",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            1910,
            100,
            22
          ],
          "text": "clear_solos"
        }
      },
      {
        "box": {
          "id": "obj-101",
          "varname": "row_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            256,
            148,
            188,
            20
          ],
          "text": "Playback windows",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            256,
            148,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-102",
          "varname": "wave_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            448,
            152,
            236,
            20
          ],
          "text": "Drag a range, release to set the loop",
          "presentation": 1,
          "presentation_rect": [
            448,
            152,
            236,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-103",
          "varname": "inspector_title",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            148,
            380,
            20
          ],
          "text": "Window controls",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            688,
            148,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-104",
          "varname": "inspector_tabs",
          "maxclass": "live.tab",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            688,
            172,
            380,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Edit window",
              "parameter_shortname": "Edit window",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 3,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Window 1",
                "Window 2",
                "Window 3",
                "Window 4"
              ]
            }
          },
          "outlettype": [
            "int",
            "",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            688,
            172,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-105",
          "varname": "choose_window",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1500,
            808,
            166,
            22
          ],
          "text": "prepend inspect_window"
        }
      },
      {
        "box": {
          "id": "obj-106",
          "varname": "inspector_label_14",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            196,
            92,
            20
          ],
          "text": "In %",
          "presentation": 1,
          "presentation_rect": [
            688,
            196,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-107",
          "varname": "inspector_label_16",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            784,
            196,
            92,
            20
          ],
          "text": "Out %",
          "presentation": 1,
          "presentation_rect": [
            784,
            196,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-108",
          "varname": "inspector_label_18",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            880,
            196,
            188,
            20
          ],
          "text": "Direction",
          "presentation": 1,
          "presentation_rect": [
            880,
            196,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-109",
          "varname": "inspect_start",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            688,
            220,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected start",
              "parameter_shortname": "Selected start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_units": "%.2f"
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            688,
            220,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-110",
          "varname": "edit_inspect_start",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            510,
            208,
            22
          ],
          "text": "prepend inspector_edit start"
        }
      },
      {
        "box": {
          "id": "obj-111",
          "varname": "inspect_end",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            784,
            220,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected end",
              "parameter_shortname": "Selected end",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                25
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_units": "%.2f"
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            784,
            220,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-112",
          "varname": "edit_inspect_end",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            539,
            194,
            22
          ],
          "text": "prepend inspector_edit end"
        }
      },
      {
        "box": {
          "id": "obj-113",
          "varname": "inspect_rate",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            688,
            248,
            60,
            88
          ],
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected rate",
              "parameter_shortname": "Speed ×",
              "parameter_type": 0,
              "parameter_mmin": 0.125,
              "parameter_mmax": 4,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_units": "%.2f"
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            688,
            248,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-114",
          "varname": "edit_inspect_rate",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            568,
            201,
            22
          ],
          "text": "prepend inspector_edit rate"
        }
      },
      {
        "box": {
          "id": "obj-115",
          "varname": "inspect_direction",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            880,
            220,
            188,
            20
          ],
          "items": [
            "Forward",
            ",",
            "Reverse",
            ",",
            "Ping-pong"
          ],
          "outlettype": [
            "int",
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            880,
            220,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-116",
          "varname": "edit_inspect_direction",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            597,
            236,
            22
          ],
          "text": "prepend inspector_edit direction"
        }
      },
      {
        "box": {
          "id": "obj-117",
          "varname": "inspect_fade",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            752,
            248,
            60,
            88
          ],
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected fade",
              "parameter_shortname": "Fade ms",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 500,
              "parameter_initial": [
                30
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            752,
            248,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-118",
          "varname": "edit_inspect_fade",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            626,
            201,
            22
          ],
          "text": "prepend inspector_edit fade"
        }
      },
      {
        "box": {
          "id": "obj-119",
          "varname": "inspect_drive",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            816,
            248,
            60,
            88
          ],
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected drive",
              "parameter_shortname": "Drive %",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            816,
            248,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-120",
          "varname": "edit_inspect_drive",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            655,
            208,
            22
          ],
          "text": "prepend inspector_edit drive"
        }
      },
      {
        "box": {
          "id": "obj-121",
          "varname": "inspect_filter",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            880,
            248,
            60,
            88
          ],
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected filter",
              "parameter_shortname": "Filter",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            880,
            248,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-122",
          "varname": "edit_inspect_filter",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            684,
            215,
            22
          ],
          "text": "prepend inspector_edit filter"
        }
      },
      {
        "box": {
          "id": "obj-123",
          "varname": "inspect_level",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            944,
            248,
            60,
            88
          ],
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected level",
              "parameter_shortname": "Level %",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            944,
            248,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-124",
          "varname": "edit_inspect_level",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            713,
            208,
            22
          ],
          "text": "prepend inspector_edit level"
        }
      },
      {
        "box": {
          "id": "obj-125",
          "varname": "inspect_pan",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1008,
            248,
            60,
            88
          ],
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected pan",
              "parameter_shortname": "Pan %",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            1008,
            248,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-126",
          "varname": "edit_inspect_pan",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1600,
            742,
            194,
            22
          ],
          "text": "prepend inspector_edit pan"
        }
      },
      {
        "box": {
          "id": "obj-127",
          "varname": "filter_help",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            340,
            140,
            20
          ],
          "text": "Filter: LP ← 0 → HP",
          "presentation": 1,
          "presentation_rect": [
            688,
            340,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-128",
          "varname": "pitch_scale_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            832,
            340,
            92,
            20
          ],
          "text": "Pitch snap · All",
          "presentation": 1,
          "presentation_rect": [
            832,
            340,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-129",
          "varname": "pitch_scale",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            928,
            340,
            140,
            20
          ],
          "items": [
            "Off",
            ",",
            "Chromatic",
            ",",
            "Major",
            ",",
            "Natural Minor",
            ",",
            "Dorian",
            ",",
            "Major Pentatonic",
            ",",
            "Minor Pentatonic"
          ],
          "pattrmode": 0,
          "hint": "Snap the speed of all four windows to a scale. The original sample at 1× is the tonic.",
          "outlettype": [
            "int",
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            928,
            340,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-130",
          "varname": "pitch_scale_default",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2280,
            805,
            82,
            22
          ],
          "text": "loadmess 0",
          "outlettype": [
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-131",
          "varname": "pitch_scale_signal",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2280,
            845,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-132",
          "varname": "patchbay",
          "maxclass": "bpatcher",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            376,
            1052,
            212
          ],
          "outlettype": [
            "multichannelsignal",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            376,
            1052,
            212
          ],
          "name": "fk_modulation.maxpat",
          "args": [],
          "offset": [
            0.0,
            0.0
          ],
          "border": 0,
          "clickthrough": 0,
          "enablehscroll": 0,
          "enablevscroll": 0,
          "lockeddragscroll": 0
        }
      },
      {
        "box": {
          "id": "obj-133",
          "varname": "mod_signals",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 36,
          "patching_rect": [
            28,
            886,
            1016,
            22
          ],
          "text": "mc.unpack~ 36",
          "outlettype": [
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-134",
          "varname": "watch_target",
          "maxclass": "newobj",
          "numinlets": 37,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            886,
            660,
            22
          ],
          "text": "selector~ 36 1",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-135",
          "varname": "watch_snapshot",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            928,
            96,
            22
          ],
          "text": "snapshot~ 50",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-136",
          "varname": "watch_value",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            965,
            131,
            22
          ],
          "text": "prepend effective"
        }
      },
      {
        "box": {
          "id": "obj-137",
          "varname": "watch_running",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            965,
            117,
            22
          ],
          "text": "prepend running"
        }
      },
      {
        "box": {
          "id": "obj-138",
          "varname": "play_1",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            172,
            92,
            20
          ],
          "text": "01 Stopped",
          "texton": "01 Playing",
          "mode": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Window 1 Play",
              "parameter_shortname": "Window 1 Play",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Off",
                "On"
              ]
            }
          },
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            172,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-139",
          "varname": "wave_1",
          "maxclass": "waveform~",
          "numinlets": 5,
          "numoutlets": 6,
          "patching_rect": [
            256,
            172,
            428,
            44
          ],
          "setmode": 1,
          "outlettype": [
            "float",
            "float",
            "float",
            "float",
            "list",
            "list"
          ],
          "presentation": 1,
          "presentation_rect": [
            256,
            172,
            428,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-140",
          "varname": "voice_1",
          "maxclass": "newobj",
          "numinlets": 13,
          "numoutlets": 12,
          "patching_rect": [
            28,
            1082,
            500,
            22
          ],
          "text": "gen~ fk_voice",
          "outlettype": [
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-141",
          "varname": "run_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            925,
            950,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-142",
          "varname": "wave_edit_revision_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1030,
            1058,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-143",
          "varname": "start_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1690,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 start",
              "parameter_shortname": "W1 start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-144",
          "varname": "base_start_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            28,
            950,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-145",
          "varname": "mod_start_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            982,
            61,
            22
          ],
          "text": "*~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-146",
          "varname": "sum_start_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-147",
          "varname": "unit_start_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1046,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-148",
          "varname": "edit_start_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            950,
            152,
            22
          ],
          "text": "prepend edit_start 1"
        }
      },
      {
        "box": {
          "id": "obj-149",
          "varname": "end_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1786,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 end",
              "parameter_shortname": "W1 end",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                25
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-150",
          "varname": "base_end_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            128,
            950,
            75,
            22
          ],
          "text": "sig~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-151",
          "varname": "mod_end_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            982,
            61,
            22
          ],
          "text": "*~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-152",
          "varname": "sum_end_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-153",
          "varname": "unit_end_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1046,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-154",
          "varname": "edit_end_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            950,
            138,
            22
          ],
          "text": "prepend edit_end 1"
        }
      },
      {
        "box": {
          "id": "obj-155",
          "varname": "rate_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1882,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 rate",
              "parameter_shortname": "W1 rate",
              "parameter_type": 0,
              "parameter_mmin": 0.125,
              "parameter_mmax": 4,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-156",
          "varname": "base_rate_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            228,
            950,
            68,
            22
          ],
          "text": "sig~ 1.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-157",
          "varname": "mod_rate_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            228,
            982,
            54,
            22
          ],
          "text": "*~ 1.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-158",
          "varname": "sum_rate_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-159",
          "varname": "clip_rate_1",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1046,
            110,
            22
          ],
          "text": "clip~ 0.125 4.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-160",
          "varname": "sync_rate_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1882,
            990,
            215,
            22
          ],
          "text": "prepend inspector_sync 1 rate"
        }
      },
      {
        "box": {
          "id": "obj-161",
          "varname": "direction_1",
          "maxclass": "live.menu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1978,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 direction",
              "parameter_shortname": "W1 direction",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 2,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Forward",
                "Reverse",
                "Ping-pong"
              ]
            }
          },
          "outlettype": [
            "",
            "",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-162",
          "varname": "base_direction_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            328,
            950,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-163",
          "varname": "mod_direction_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            328,
            982,
            54,
            22
          ],
          "text": "*~ 2.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-164",
          "varname": "sum_direction_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-165",
          "varname": "sync_direction_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1978,
            990,
            250,
            22
          ],
          "text": "prepend inspector_sync 1 direction"
        }
      },
      {
        "box": {
          "id": "obj-166",
          "varname": "fade_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2074,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 fade",
              "parameter_shortname": "W1 fade",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 500,
              "parameter_initial": [
                30
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-167",
          "varname": "base_fade_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            428,
            950,
            75,
            22
          ],
          "text": "sig~ 30.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-168",
          "varname": "mod_fade_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            428,
            982,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-169",
          "varname": "sum_fade_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-170",
          "varname": "sync_fade_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2074,
            990,
            215,
            22
          ],
          "text": "prepend inspector_sync 1 fade"
        }
      },
      {
        "box": {
          "id": "obj-171",
          "varname": "drive_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2170,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 drive",
              "parameter_shortname": "W1 drive",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-172",
          "varname": "base_drive_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            528,
            950,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-173",
          "varname": "mod_drive_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            982,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-174",
          "varname": "sum_drive_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-175",
          "varname": "unit_drive_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1046,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-176",
          "varname": "sync_drive_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2170,
            990,
            222,
            22
          ],
          "text": "prepend inspector_sync 1 drive"
        }
      },
      {
        "box": {
          "id": "obj-177",
          "varname": "filter_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2266,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 filter",
              "parameter_shortname": "W1 filter",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-178",
          "varname": "base_filter_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            628,
            950,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-179",
          "varname": "mod_filter_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            982,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-180",
          "varname": "sum_filter_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-181",
          "varname": "unit_filter_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1046,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-182",
          "varname": "sync_filter_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2266,
            990,
            229,
            22
          ],
          "text": "prepend inspector_sync 1 filter"
        }
      },
      {
        "box": {
          "id": "obj-183",
          "varname": "level_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2362,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 level",
              "parameter_shortname": "W1 level",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-184",
          "varname": "base_level_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            728,
            950,
            75,
            22
          ],
          "text": "sig~ 70.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-185",
          "varname": "mod_level_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            982,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-186",
          "varname": "sum_level_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-187",
          "varname": "unit_level_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1046,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-188",
          "varname": "sync_level_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2362,
            990,
            222,
            22
          ],
          "text": "prepend inspector_sync 1 level"
        }
      },
      {
        "box": {
          "id": "obj-189",
          "varname": "pan_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2458,
            950,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W1 pan",
              "parameter_shortname": "W1 pan",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                -45
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-190",
          "varname": "base_pan_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            828,
            950,
            82,
            22
          ],
          "text": "sig~ -45.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-191",
          "varname": "mod_pan_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            982,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-192",
          "varname": "sum_pan_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1014,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-193",
          "varname": "unit_pan_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1046,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-194",
          "varname": "sync_pan_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2458,
            990,
            208,
            22
          ],
          "text": "prepend inspector_sync 1 pan"
        }
      },
      {
        "box": {
          "id": "obj-195",
          "varname": "mixer_mute_1",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            172,
            44,
            20
          ],
          "mode": 1,
          "text": "Mute",
          "texton": "Mute",
          "parameter_enable": 0,
          "hint": "Mute this window without stopping the loop.",
          "outlettype": [
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            172,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-196",
          "varname": "mixer_mute_1_msg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            950,
            110,
            22
          ],
          "text": "prepend mute 1"
        }
      },
      {
        "box": {
          "id": "obj-197",
          "varname": "mixer_solo_1",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            172,
            44,
            20
          ],
          "mode": 1,
          "text": "Solo",
          "texton": "Solo",
          "parameter_enable": 0,
          "hint": "Listen to soloed windows. Mute still silences a window.",
          "outlettype": [
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            172,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-198",
          "varname": "mixer_solo_1_msg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            980,
            110,
            22
          ],
          "text": "prepend solo 1"
        }
      },
      {
        "box": {
          "id": "obj-199",
          "varname": "mixer_pan_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            172,
            44,
            20
          ],
          "hint": "Window 1 pan",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer pan 1",
              "parameter_shortname": "Mixer pan 1",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                -45
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 6
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            172,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-200",
          "varname": "mixer_level_1",
          "maxclass": "live.slider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            196,
            140,
            20
          ],
          "orientation": 1,
          "showname": 0,
          "shownumber": 0,
          "relative": 0,
          "tricolor": [
            0.56,
            0.71,
            0.96,
            1.0
          ],
          "trioncolor": [
            0.68,
            0.8,
            0.99,
            1.0
          ],
          "hint": "Window 1 volume. Click or drag to set it directly.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer level 1",
              "parameter_shortname": "Mixer level 1",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            196,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-201",
          "varname": "mixer_level_value_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            198,
            44,
            20
          ],
          "hint": "Window 1 level in percent",
          "parameter_mappable": 0,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer level value 1",
              "parameter_shortname": "Mixer level value 1",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            198,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-202",
          "varname": "meter_1",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            196,
            44,
            20
          ],
          "orientation": 1,
          "hint": "Window 1 peak after mute and solo.",
          "outlettype": [
            "float",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            196,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-203",
          "varname": "mixer_level_1_sync",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1012,
            89,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-204",
          "varname": "mixer_pan_1_sync",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2796,
            1012,
            89,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-205",
          "varname": "mixer_gain_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2680,
            1044,
            68,
            22
          ],
          "text": "line~ 1.",
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-206",
          "varname": "peak_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            1120,
            68,
            22
          ],
          "text": "maximum~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-207",
          "varname": "mixer_left_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1074,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-208",
          "varname": "abs_left_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            780,
            1082,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-209",
          "varname": "mixer_right_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2796,
            1074,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-210",
          "varname": "abs_right_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            880,
            1082,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-211",
          "varname": "track_wave_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            984,
            152,
            22
          ],
          "text": "prepend track_wave 1"
        }
      },
      {
        "box": {
          "id": "obj-212",
          "varname": "wave_mouse_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1052,
            152,
            22
          ],
          "text": "prepend wave_mouse 1"
        }
      },
      {
        "box": {
          "id": "obj-213",
          "varname": "edit_play_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            984,
            145,
            22
          ],
          "text": "prepend edit_play 1"
        }
      },
      {
        "box": {
          "id": "obj-214",
          "varname": "playhead_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1018,
            96,
            22
          ],
          "text": "snapshot~ 50",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-215",
          "varname": "playhead_gate_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1018,
            54,
            22
          ],
          "text": "gate 1"
        }
      },
      {
        "box": {
          "id": "obj-216",
          "varname": "draw_playhead_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1450,
            1018,
            96,
            22
          ],
          "text": "prepend line"
        }
      },
      {
        "box": {
          "id": "obj-217",
          "varname": "play_2",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            220,
            92,
            20
          ],
          "text": "02 Stopped",
          "texton": "02 Playing",
          "mode": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Window 2 Play",
              "parameter_shortname": "Window 2 Play",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Off",
                "On"
              ]
            }
          },
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            220,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-218",
          "varname": "wave_2",
          "maxclass": "waveform~",
          "numinlets": 5,
          "numoutlets": 6,
          "patching_rect": [
            256,
            220,
            428,
            44
          ],
          "setmode": 1,
          "outlettype": [
            "float",
            "float",
            "float",
            "float",
            "list",
            "list"
          ],
          "presentation": 1,
          "presentation_rect": [
            256,
            220,
            428,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-219",
          "varname": "voice_2",
          "maxclass": "newobj",
          "numinlets": 13,
          "numoutlets": 12,
          "patching_rect": [
            28,
            1292,
            500,
            22
          ],
          "text": "gen~ fk_voice",
          "outlettype": [
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-220",
          "varname": "run_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            925,
            1160,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-221",
          "varname": "wave_edit_revision_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1030,
            1268,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-222",
          "varname": "start_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1690,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 start",
              "parameter_shortname": "W2 start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                25
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-223",
          "varname": "base_start_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1160,
            75,
            22
          ],
          "text": "sig~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-224",
          "varname": "mod_start_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1192,
            61,
            22
          ],
          "text": "*~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-225",
          "varname": "sum_start_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-226",
          "varname": "unit_start_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1256,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-227",
          "varname": "edit_start_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1160,
            152,
            22
          ],
          "text": "prepend edit_start 2"
        }
      },
      {
        "box": {
          "id": "obj-228",
          "varname": "end_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1786,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 end",
              "parameter_shortname": "W2 end",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                50
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-229",
          "varname": "base_end_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1160,
            75,
            22
          ],
          "text": "sig~ 50.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-230",
          "varname": "mod_end_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1192,
            61,
            22
          ],
          "text": "*~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-231",
          "varname": "sum_end_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-232",
          "varname": "unit_end_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1256,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-233",
          "varname": "edit_end_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1160,
            138,
            22
          ],
          "text": "prepend edit_end 2"
        }
      },
      {
        "box": {
          "id": "obj-234",
          "varname": "rate_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1882,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 rate",
              "parameter_shortname": "W2 rate",
              "parameter_type": 0,
              "parameter_mmin": 0.125,
              "parameter_mmax": 4,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-235",
          "varname": "base_rate_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1160,
            68,
            22
          ],
          "text": "sig~ 1.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-236",
          "varname": "mod_rate_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1192,
            54,
            22
          ],
          "text": "*~ 1.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-237",
          "varname": "sum_rate_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-238",
          "varname": "clip_rate_2",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1256,
            110,
            22
          ],
          "text": "clip~ 0.125 4.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-239",
          "varname": "sync_rate_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1882,
            1200,
            215,
            22
          ],
          "text": "prepend inspector_sync 2 rate"
        }
      },
      {
        "box": {
          "id": "obj-240",
          "varname": "direction_2",
          "maxclass": "live.menu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1978,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 direction",
              "parameter_shortname": "W2 direction",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 2,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Forward",
                "Reverse",
                "Ping-pong"
              ]
            }
          },
          "outlettype": [
            "",
            "",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-241",
          "varname": "base_direction_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1160,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-242",
          "varname": "mod_direction_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1192,
            54,
            22
          ],
          "text": "*~ 2.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-243",
          "varname": "sum_direction_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-244",
          "varname": "sync_direction_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1978,
            1200,
            250,
            22
          ],
          "text": "prepend inspector_sync 2 direction"
        }
      },
      {
        "box": {
          "id": "obj-245",
          "varname": "fade_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2074,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 fade",
              "parameter_shortname": "W2 fade",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 500,
              "parameter_initial": [
                30
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-246",
          "varname": "base_fade_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1160,
            75,
            22
          ],
          "text": "sig~ 30.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-247",
          "varname": "mod_fade_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1192,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-248",
          "varname": "sum_fade_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-249",
          "varname": "sync_fade_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2074,
            1200,
            215,
            22
          ],
          "text": "prepend inspector_sync 2 fade"
        }
      },
      {
        "box": {
          "id": "obj-250",
          "varname": "drive_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2170,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 drive",
              "parameter_shortname": "W2 drive",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-251",
          "varname": "base_drive_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1160,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-252",
          "varname": "mod_drive_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1192,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-253",
          "varname": "sum_drive_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-254",
          "varname": "unit_drive_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1256,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-255",
          "varname": "sync_drive_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2170,
            1200,
            222,
            22
          ],
          "text": "prepend inspector_sync 2 drive"
        }
      },
      {
        "box": {
          "id": "obj-256",
          "varname": "filter_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2266,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 filter",
              "parameter_shortname": "W2 filter",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-257",
          "varname": "base_filter_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1160,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-258",
          "varname": "mod_filter_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1192,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-259",
          "varname": "sum_filter_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-260",
          "varname": "unit_filter_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1256,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-261",
          "varname": "sync_filter_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2266,
            1200,
            229,
            22
          ],
          "text": "prepend inspector_sync 2 filter"
        }
      },
      {
        "box": {
          "id": "obj-262",
          "varname": "level_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2362,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 level",
              "parameter_shortname": "W2 level",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-263",
          "varname": "base_level_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1160,
            75,
            22
          ],
          "text": "sig~ 70.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-264",
          "varname": "mod_level_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1192,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-265",
          "varname": "sum_level_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-266",
          "varname": "unit_level_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1256,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-267",
          "varname": "sync_level_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2362,
            1200,
            222,
            22
          ],
          "text": "prepend inspector_sync 2 level"
        }
      },
      {
        "box": {
          "id": "obj-268",
          "varname": "pan_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2458,
            1160,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W2 pan",
              "parameter_shortname": "W2 pan",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                -15
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-269",
          "varname": "base_pan_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1160,
            82,
            22
          ],
          "text": "sig~ -15.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-270",
          "varname": "mod_pan_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1192,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-271",
          "varname": "sum_pan_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1224,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-272",
          "varname": "unit_pan_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1256,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-273",
          "varname": "sync_pan_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2458,
            1200,
            208,
            22
          ],
          "text": "prepend inspector_sync 2 pan"
        }
      },
      {
        "box": {
          "id": "obj-274",
          "varname": "mixer_mute_2",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            220,
            44,
            20
          ],
          "mode": 1,
          "text": "Mute",
          "texton": "Mute",
          "parameter_enable": 0,
          "hint": "Mute this window without stopping the loop.",
          "outlettype": [
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            220,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-275",
          "varname": "mixer_mute_2_msg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1160,
            110,
            22
          ],
          "text": "prepend mute 2"
        }
      },
      {
        "box": {
          "id": "obj-276",
          "varname": "mixer_solo_2",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            220,
            44,
            20
          ],
          "mode": 1,
          "text": "Solo",
          "texton": "Solo",
          "parameter_enable": 0,
          "hint": "Listen to soloed windows. Mute still silences a window.",
          "outlettype": [
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            220,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-277",
          "varname": "mixer_solo_2_msg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1190,
            110,
            22
          ],
          "text": "prepend solo 2"
        }
      },
      {
        "box": {
          "id": "obj-278",
          "varname": "mixer_pan_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            220,
            44,
            20
          ],
          "hint": "Window 2 pan",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer pan 2",
              "parameter_shortname": "Mixer pan 2",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                -15
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 6
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            220,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-279",
          "varname": "mixer_level_2",
          "maxclass": "live.slider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            244,
            140,
            20
          ],
          "orientation": 1,
          "showname": 0,
          "shownumber": 0,
          "relative": 0,
          "tricolor": [
            0.56,
            0.71,
            0.96,
            1.0
          ],
          "trioncolor": [
            0.68,
            0.8,
            0.99,
            1.0
          ],
          "hint": "Window 2 volume. Click or drag to set it directly.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer level 2",
              "parameter_shortname": "Mixer level 2",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            244,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-280",
          "varname": "mixer_level_value_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            246,
            44,
            20
          ],
          "hint": "Window 2 level in percent",
          "parameter_mappable": 0,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer level value 2",
              "parameter_shortname": "Mixer level value 2",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            246,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-281",
          "varname": "meter_2",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            244,
            44,
            20
          ],
          "orientation": 1,
          "hint": "Window 2 peak after mute and solo.",
          "outlettype": [
            "float",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            244,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-282",
          "varname": "mixer_level_2_sync",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1222,
            89,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-283",
          "varname": "mixer_pan_2_sync",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2796,
            1222,
            89,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-284",
          "varname": "mixer_gain_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2680,
            1254,
            68,
            22
          ],
          "text": "line~ 1.",
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-285",
          "varname": "peak_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            1330,
            68,
            22
          ],
          "text": "maximum~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-286",
          "varname": "mixer_left_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1284,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-287",
          "varname": "abs_left_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            780,
            1292,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-288",
          "varname": "mixer_right_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2796,
            1284,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-289",
          "varname": "abs_right_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            880,
            1292,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-290",
          "varname": "track_wave_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1194,
            152,
            22
          ],
          "text": "prepend track_wave 2"
        }
      },
      {
        "box": {
          "id": "obj-291",
          "varname": "wave_mouse_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1262,
            152,
            22
          ],
          "text": "prepend wave_mouse 2"
        }
      },
      {
        "box": {
          "id": "obj-292",
          "varname": "edit_play_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1194,
            145,
            22
          ],
          "text": "prepend edit_play 2"
        }
      },
      {
        "box": {
          "id": "obj-293",
          "varname": "playhead_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1228,
            96,
            22
          ],
          "text": "snapshot~ 50",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-294",
          "varname": "playhead_gate_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1228,
            54,
            22
          ],
          "text": "gate 1"
        }
      },
      {
        "box": {
          "id": "obj-295",
          "varname": "draw_playhead_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1450,
            1228,
            96,
            22
          ],
          "text": "prepend line"
        }
      },
      {
        "box": {
          "id": "obj-296",
          "varname": "play_3",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            268,
            92,
            20
          ],
          "text": "03 Stopped",
          "texton": "03 Playing",
          "mode": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Window 3 Play",
              "parameter_shortname": "Window 3 Play",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Off",
                "On"
              ]
            }
          },
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            268,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-297",
          "varname": "wave_3",
          "maxclass": "waveform~",
          "numinlets": 5,
          "numoutlets": 6,
          "patching_rect": [
            256,
            268,
            428,
            44
          ],
          "setmode": 1,
          "outlettype": [
            "float",
            "float",
            "float",
            "float",
            "list",
            "list"
          ],
          "presentation": 1,
          "presentation_rect": [
            256,
            268,
            428,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-298",
          "varname": "voice_3",
          "maxclass": "newobj",
          "numinlets": 13,
          "numoutlets": 12,
          "patching_rect": [
            28,
            1502,
            500,
            22
          ],
          "text": "gen~ fk_voice",
          "outlettype": [
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-299",
          "varname": "run_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            925,
            1370,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-300",
          "varname": "wave_edit_revision_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1030,
            1478,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-301",
          "varname": "start_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1690,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 start",
              "parameter_shortname": "W3 start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                50
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-302",
          "varname": "base_start_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1370,
            75,
            22
          ],
          "text": "sig~ 50.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-303",
          "varname": "mod_start_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1402,
            61,
            22
          ],
          "text": "*~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-304",
          "varname": "sum_start_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-305",
          "varname": "unit_start_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1466,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-306",
          "varname": "edit_start_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1370,
            152,
            22
          ],
          "text": "prepend edit_start 3"
        }
      },
      {
        "box": {
          "id": "obj-307",
          "varname": "end_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1786,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 end",
              "parameter_shortname": "W3 end",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                75
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-308",
          "varname": "base_end_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1370,
            75,
            22
          ],
          "text": "sig~ 75.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-309",
          "varname": "mod_end_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1402,
            61,
            22
          ],
          "text": "*~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-310",
          "varname": "sum_end_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-311",
          "varname": "unit_end_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1466,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-312",
          "varname": "edit_end_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1370,
            138,
            22
          ],
          "text": "prepend edit_end 3"
        }
      },
      {
        "box": {
          "id": "obj-313",
          "varname": "rate_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1882,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 rate",
              "parameter_shortname": "W3 rate",
              "parameter_type": 0,
              "parameter_mmin": 0.125,
              "parameter_mmax": 4,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-314",
          "varname": "base_rate_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1370,
            68,
            22
          ],
          "text": "sig~ 1.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-315",
          "varname": "mod_rate_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1402,
            54,
            22
          ],
          "text": "*~ 1.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-316",
          "varname": "sum_rate_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-317",
          "varname": "clip_rate_3",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1466,
            110,
            22
          ],
          "text": "clip~ 0.125 4.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-318",
          "varname": "sync_rate_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1882,
            1410,
            215,
            22
          ],
          "text": "prepend inspector_sync 3 rate"
        }
      },
      {
        "box": {
          "id": "obj-319",
          "varname": "direction_3",
          "maxclass": "live.menu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1978,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 direction",
              "parameter_shortname": "W3 direction",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 2,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Forward",
                "Reverse",
                "Ping-pong"
              ]
            }
          },
          "outlettype": [
            "",
            "",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-320",
          "varname": "base_direction_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1370,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-321",
          "varname": "mod_direction_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1402,
            54,
            22
          ],
          "text": "*~ 2.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-322",
          "varname": "sum_direction_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-323",
          "varname": "sync_direction_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1978,
            1410,
            250,
            22
          ],
          "text": "prepend inspector_sync 3 direction"
        }
      },
      {
        "box": {
          "id": "obj-324",
          "varname": "fade_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2074,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 fade",
              "parameter_shortname": "W3 fade",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 500,
              "parameter_initial": [
                30
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-325",
          "varname": "base_fade_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1370,
            75,
            22
          ],
          "text": "sig~ 30.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-326",
          "varname": "mod_fade_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1402,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-327",
          "varname": "sum_fade_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-328",
          "varname": "sync_fade_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2074,
            1410,
            215,
            22
          ],
          "text": "prepend inspector_sync 3 fade"
        }
      },
      {
        "box": {
          "id": "obj-329",
          "varname": "drive_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2170,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 drive",
              "parameter_shortname": "W3 drive",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-330",
          "varname": "base_drive_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1370,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-331",
          "varname": "mod_drive_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1402,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-332",
          "varname": "sum_drive_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-333",
          "varname": "unit_drive_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1466,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-334",
          "varname": "sync_drive_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2170,
            1410,
            222,
            22
          ],
          "text": "prepend inspector_sync 3 drive"
        }
      },
      {
        "box": {
          "id": "obj-335",
          "varname": "filter_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2266,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 filter",
              "parameter_shortname": "W3 filter",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-336",
          "varname": "base_filter_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1370,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-337",
          "varname": "mod_filter_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1402,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-338",
          "varname": "sum_filter_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-339",
          "varname": "unit_filter_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1466,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-340",
          "varname": "sync_filter_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2266,
            1410,
            229,
            22
          ],
          "text": "prepend inspector_sync 3 filter"
        }
      },
      {
        "box": {
          "id": "obj-341",
          "varname": "level_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2362,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 level",
              "parameter_shortname": "W3 level",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-342",
          "varname": "base_level_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1370,
            75,
            22
          ],
          "text": "sig~ 70.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-343",
          "varname": "mod_level_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1402,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-344",
          "varname": "sum_level_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-345",
          "varname": "unit_level_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1466,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-346",
          "varname": "sync_level_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2362,
            1410,
            222,
            22
          ],
          "text": "prepend inspector_sync 3 level"
        }
      },
      {
        "box": {
          "id": "obj-347",
          "varname": "pan_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2458,
            1370,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W3 pan",
              "parameter_shortname": "W3 pan",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                15
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-348",
          "varname": "base_pan_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1370,
            75,
            22
          ],
          "text": "sig~ 15.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-349",
          "varname": "mod_pan_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1402,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-350",
          "varname": "sum_pan_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1434,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-351",
          "varname": "unit_pan_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1466,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-352",
          "varname": "sync_pan_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2458,
            1410,
            208,
            22
          ],
          "text": "prepend inspector_sync 3 pan"
        }
      },
      {
        "box": {
          "id": "obj-353",
          "varname": "mixer_mute_3",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            268,
            44,
            20
          ],
          "mode": 1,
          "text": "Mute",
          "texton": "Mute",
          "parameter_enable": 0,
          "hint": "Mute this window without stopping the loop.",
          "outlettype": [
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            268,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-354",
          "varname": "mixer_mute_3_msg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1370,
            110,
            22
          ],
          "text": "prepend mute 3"
        }
      },
      {
        "box": {
          "id": "obj-355",
          "varname": "mixer_solo_3",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            268,
            44,
            20
          ],
          "mode": 1,
          "text": "Solo",
          "texton": "Solo",
          "parameter_enable": 0,
          "hint": "Listen to soloed windows. Mute still silences a window.",
          "outlettype": [
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            268,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-356",
          "varname": "mixer_solo_3_msg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1400,
            110,
            22
          ],
          "text": "prepend solo 3"
        }
      },
      {
        "box": {
          "id": "obj-357",
          "varname": "mixer_pan_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            268,
            44,
            20
          ],
          "hint": "Window 3 pan",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer pan 3",
              "parameter_shortname": "Mixer pan 3",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                15
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 6
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            268,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-358",
          "varname": "mixer_level_3",
          "maxclass": "live.slider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            292,
            140,
            20
          ],
          "orientation": 1,
          "showname": 0,
          "shownumber": 0,
          "relative": 0,
          "tricolor": [
            0.56,
            0.71,
            0.96,
            1.0
          ],
          "trioncolor": [
            0.68,
            0.8,
            0.99,
            1.0
          ],
          "hint": "Window 3 volume. Click or drag to set it directly.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer level 3",
              "parameter_shortname": "Mixer level 3",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            292,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-359",
          "varname": "mixer_level_value_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            294,
            44,
            20
          ],
          "hint": "Window 3 level in percent",
          "parameter_mappable": 0,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer level value 3",
              "parameter_shortname": "Mixer level value 3",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            294,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-360",
          "varname": "meter_3",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            292,
            44,
            20
          ],
          "orientation": 1,
          "hint": "Window 3 peak after mute and solo.",
          "outlettype": [
            "float",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            292,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-361",
          "varname": "mixer_level_3_sync",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1432,
            89,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-362",
          "varname": "mixer_pan_3_sync",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2796,
            1432,
            89,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-363",
          "varname": "mixer_gain_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2680,
            1464,
            68,
            22
          ],
          "text": "line~ 1.",
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-364",
          "varname": "peak_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            1540,
            68,
            22
          ],
          "text": "maximum~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-365",
          "varname": "mixer_left_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1494,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-366",
          "varname": "abs_left_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            780,
            1502,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-367",
          "varname": "mixer_right_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2796,
            1494,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-368",
          "varname": "abs_right_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            880,
            1502,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-369",
          "varname": "track_wave_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1404,
            152,
            22
          ],
          "text": "prepend track_wave 3"
        }
      },
      {
        "box": {
          "id": "obj-370",
          "varname": "wave_mouse_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1472,
            152,
            22
          ],
          "text": "prepend wave_mouse 3"
        }
      },
      {
        "box": {
          "id": "obj-371",
          "varname": "edit_play_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1404,
            145,
            22
          ],
          "text": "prepend edit_play 3"
        }
      },
      {
        "box": {
          "id": "obj-372",
          "varname": "playhead_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1438,
            96,
            22
          ],
          "text": "snapshot~ 50",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-373",
          "varname": "playhead_gate_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1438,
            54,
            22
          ],
          "text": "gate 1"
        }
      },
      {
        "box": {
          "id": "obj-374",
          "varname": "draw_playhead_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1450,
            1438,
            96,
            22
          ],
          "text": "prepend line"
        }
      },
      {
        "box": {
          "id": "obj-375",
          "varname": "play_4",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            316,
            92,
            20
          ],
          "text": "04 Stopped",
          "texton": "04 Playing",
          "mode": 1,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Window 4 Play",
              "parameter_shortname": "Window 4 Play",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Off",
                "On"
              ]
            }
          },
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            316,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-376",
          "varname": "wave_4",
          "maxclass": "waveform~",
          "numinlets": 5,
          "numoutlets": 6,
          "patching_rect": [
            256,
            316,
            428,
            44
          ],
          "setmode": 1,
          "outlettype": [
            "float",
            "float",
            "float",
            "float",
            "list",
            "list"
          ],
          "presentation": 1,
          "presentation_rect": [
            256,
            316,
            428,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-377",
          "varname": "voice_4",
          "maxclass": "newobj",
          "numinlets": 13,
          "numoutlets": 12,
          "patching_rect": [
            28,
            1712,
            500,
            22
          ],
          "text": "gen~ fk_voice",
          "outlettype": [
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-378",
          "varname": "run_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            925,
            1580,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-379",
          "varname": "wave_edit_revision_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1030,
            1688,
            61,
            22
          ],
          "text": "sig~ 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-380",
          "varname": "start_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1690,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 start",
              "parameter_shortname": "W4 start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                75
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-381",
          "varname": "base_start_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1580,
            75,
            22
          ],
          "text": "sig~ 75.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-382",
          "varname": "mod_start_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1612,
            61,
            22
          ],
          "text": "*~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-383",
          "varname": "sum_start_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-384",
          "varname": "unit_start_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            28,
            1676,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-385",
          "varname": "edit_start_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1580,
            152,
            22
          ],
          "text": "prepend edit_start 4"
        }
      },
      {
        "box": {
          "id": "obj-386",
          "varname": "end_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1786,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 end",
              "parameter_shortname": "W4 end",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                100
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-387",
          "varname": "base_end_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1580,
            82,
            22
          ],
          "text": "sig~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-388",
          "varname": "mod_end_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1612,
            61,
            22
          ],
          "text": "*~ 25.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-389",
          "varname": "sum_end_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-390",
          "varname": "unit_end_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            128,
            1676,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-391",
          "varname": "edit_end_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1580,
            138,
            22
          ],
          "text": "prepend edit_end 4"
        }
      },
      {
        "box": {
          "id": "obj-392",
          "varname": "rate_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1882,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 rate",
              "parameter_shortname": "W4 rate",
              "parameter_type": 0,
              "parameter_mmin": 0.125,
              "parameter_mmax": 4,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-393",
          "varname": "base_rate_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1580,
            68,
            22
          ],
          "text": "sig~ 1.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-394",
          "varname": "mod_rate_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1612,
            54,
            22
          ],
          "text": "*~ 1.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-395",
          "varname": "sum_rate_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-396",
          "varname": "clip_rate_4",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            228,
            1676,
            110,
            22
          ],
          "text": "clip~ 0.125 4.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-397",
          "varname": "sync_rate_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1882,
            1620,
            215,
            22
          ],
          "text": "prepend inspector_sync 4 rate"
        }
      },
      {
        "box": {
          "id": "obj-398",
          "varname": "direction_4",
          "maxclass": "live.menu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1978,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 direction",
              "parameter_shortname": "W4 direction",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 2,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_enum": [
                "Forward",
                "Reverse",
                "Ping-pong"
              ]
            }
          },
          "outlettype": [
            "",
            "",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-399",
          "varname": "base_direction_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1580,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-400",
          "varname": "mod_direction_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1612,
            54,
            22
          ],
          "text": "*~ 2.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-401",
          "varname": "sum_direction_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            328,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-402",
          "varname": "sync_direction_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1978,
            1620,
            250,
            22
          ],
          "text": "prepend inspector_sync 4 direction"
        }
      },
      {
        "box": {
          "id": "obj-403",
          "varname": "fade_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2074,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 fade",
              "parameter_shortname": "W4 fade",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 500,
              "parameter_initial": [
                30
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-404",
          "varname": "base_fade_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1580,
            75,
            22
          ],
          "text": "sig~ 30.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-405",
          "varname": "mod_fade_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1612,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-406",
          "varname": "sum_fade_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            428,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-407",
          "varname": "sync_fade_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2074,
            1620,
            215,
            22
          ],
          "text": "prepend inspector_sync 4 fade"
        }
      },
      {
        "box": {
          "id": "obj-408",
          "varname": "drive_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2170,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 drive",
              "parameter_shortname": "W4 drive",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-409",
          "varname": "base_drive_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1580,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-410",
          "varname": "mod_drive_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1612,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-411",
          "varname": "sum_drive_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-412",
          "varname": "unit_drive_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            1676,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-413",
          "varname": "sync_drive_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2170,
            1620,
            222,
            22
          ],
          "text": "prepend inspector_sync 4 drive"
        }
      },
      {
        "box": {
          "id": "obj-414",
          "varname": "filter_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2266,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 filter",
              "parameter_shortname": "W4 filter",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-415",
          "varname": "base_filter_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1580,
            68,
            22
          ],
          "text": "sig~ 0.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-416",
          "varname": "mod_filter_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1612,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-417",
          "varname": "sum_filter_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-418",
          "varname": "unit_filter_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            628,
            1676,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-419",
          "varname": "sync_filter_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2266,
            1620,
            229,
            22
          ],
          "text": "prepend inspector_sync 4 filter"
        }
      },
      {
        "box": {
          "id": "obj-420",
          "varname": "level_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2362,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 level",
              "parameter_shortname": "W4 level",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-421",
          "varname": "base_level_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1580,
            75,
            22
          ],
          "text": "sig~ 70.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-422",
          "varname": "mod_level_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1612,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-423",
          "varname": "sum_level_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-424",
          "varname": "unit_level_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            728,
            1676,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-425",
          "varname": "sync_level_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2362,
            1620,
            222,
            22
          ],
          "text": "prepend inspector_sync 4 level"
        }
      },
      {
        "box": {
          "id": "obj-426",
          "varname": "pan_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2458,
            1580,
            92,
            20
          ],
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "W4 pan",
              "parameter_shortname": "W4 pan",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                45
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0
            }
          },
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-427",
          "varname": "base_pan_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1580,
            75,
            22
          ],
          "text": "sig~ 45.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-428",
          "varname": "mod_pan_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1612,
            68,
            22
          ],
          "text": "*~ 100.0",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-429",
          "varname": "sum_pan_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1644,
            42,
            22
          ],
          "text": "+~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-430",
          "varname": "unit_pan_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            828,
            1676,
            61,
            22
          ],
          "text": "*~ 0.01",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-431",
          "varname": "sync_pan_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2458,
            1620,
            208,
            22
          ],
          "text": "prepend inspector_sync 4 pan"
        }
      },
      {
        "box": {
          "id": "obj-432",
          "varname": "mixer_mute_4",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            316,
            44,
            20
          ],
          "mode": 1,
          "text": "Mute",
          "texton": "Mute",
          "parameter_enable": 0,
          "hint": "Mute this window without stopping the loop.",
          "outlettype": [
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            316,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-433",
          "varname": "mixer_mute_4_msg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1580,
            110,
            22
          ],
          "text": "prepend mute 4"
        }
      },
      {
        "box": {
          "id": "obj-434",
          "varname": "mixer_solo_4",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            316,
            44,
            20
          ],
          "mode": 1,
          "text": "Solo",
          "texton": "Solo",
          "parameter_enable": 0,
          "hint": "Listen to soloed windows. Mute still silences a window.",
          "outlettype": [
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            316,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-435",
          "varname": "mixer_solo_4_msg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1610,
            110,
            22
          ],
          "text": "prepend solo 4"
        }
      },
      {
        "box": {
          "id": "obj-436",
          "varname": "mixer_pan_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            316,
            44,
            20
          ],
          "hint": "Window 4 pan",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer pan 4",
              "parameter_shortname": "Mixer pan 4",
              "parameter_type": 0,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                45
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 6
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            316,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-437",
          "varname": "mixer_level_4",
          "maxclass": "live.slider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            340,
            140,
            20
          ],
          "orientation": 1,
          "showname": 0,
          "shownumber": 0,
          "relative": 0,
          "tricolor": [
            0.56,
            0.71,
            0.96,
            1.0
          ],
          "trioncolor": [
            0.68,
            0.8,
            0.99,
            1.0
          ],
          "hint": "Window 4 volume. Click or drag to set it directly.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer level 4",
              "parameter_shortname": "Mixer level 4",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            340,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-438",
          "varname": "mixer_level_value_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            342,
            44,
            20
          ],
          "hint": "Window 4 level in percent",
          "parameter_mappable": 0,
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Mixer level value 4",
              "parameter_shortname": "Mixer level value 4",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                70
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 5
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            342,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-439",
          "varname": "meter_4",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            340,
            44,
            20
          ],
          "orientation": 1,
          "hint": "Window 4 peak after mute and solo.",
          "outlettype": [
            "float",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            340,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-440",
          "varname": "mixer_level_4_sync",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1642,
            89,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-441",
          "varname": "mixer_pan_4_sync",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2796,
            1642,
            89,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-442",
          "varname": "mixer_gain_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2680,
            1674,
            68,
            22
          ],
          "text": "line~ 1.",
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-443",
          "varname": "peak_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            1750,
            68,
            22
          ],
          "text": "maximum~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-444",
          "varname": "mixer_left_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2680,
            1704,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-445",
          "varname": "abs_left_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            780,
            1712,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-446",
          "varname": "mixer_right_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2796,
            1704,
            42,
            22
          ],
          "text": "*~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-447",
          "varname": "abs_right_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            880,
            1712,
            42,
            22
          ],
          "text": "abs~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-448",
          "varname": "track_wave_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1614,
            152,
            22
          ],
          "text": "prepend track_wave 4"
        }
      },
      {
        "box": {
          "id": "obj-449",
          "varname": "wave_mouse_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1682,
            152,
            22
          ],
          "text": "prepend wave_mouse 4"
        }
      },
      {
        "box": {
          "id": "obj-450",
          "varname": "edit_play_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1614,
            145,
            22
          ],
          "text": "prepend edit_play 4"
        }
      },
      {
        "box": {
          "id": "obj-451",
          "varname": "playhead_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1110,
            1648,
            96,
            22
          ],
          "text": "snapshot~ 50",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-452",
          "varname": "playhead_gate_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1290,
            1648,
            54,
            22
          ],
          "text": "gate 1"
        }
      },
      {
        "box": {
          "id": "obj-453",
          "varname": "draw_playhead_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1450,
            1648,
            96,
            22
          ],
          "text": "prepend line"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-7",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-8",
            0
          ],
          "destination": [
            "obj-9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-9",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
            1
          ],
          "destination": [
            "obj-11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-11",
            0
          ],
          "destination": [
            "obj-12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-12",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-13",
            0
          ],
          "destination": [
            "obj-14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-14",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-11",
            0
          ],
          "destination": [
            "obj-15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-16",
            0
          ],
          "destination": [
            "obj-17",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-17",
            0
          ],
          "destination": [
            "obj-18",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-18",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-19",
            0
          ],
          "destination": [
            "obj-20",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-20",
            0
          ],
          "destination": [
            "obj-21",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-21",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-22",
            0
          ],
          "destination": [
            "obj-23",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-23",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-24",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-25",
            0
          ],
          "destination": [
            "obj-26",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-26",
            0
          ],
          "destination": [
            "obj-27",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-27",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-28",
            0
          ],
          "destination": [
            "obj-29",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-29",
            0
          ],
          "destination": [
            "obj-30",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-30",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-33",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-34",
            0
          ],
          "destination": [
            "obj-35",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-35",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-36",
            0
          ],
          "destination": [
            "obj-37",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-37",
            0
          ],
          "destination": [
            "obj-38",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-38",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-39",
            0
          ],
          "destination": [
            "obj-40",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-40",
            0
          ],
          "destination": [
            "obj-41",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-41",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-42",
            0
          ],
          "destination": [
            "obj-43",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-43",
            0
          ],
          "destination": [
            "obj-44",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-44",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-45",
            0
          ],
          "destination": [
            "obj-46",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            0
          ],
          "destination": [
            "obj-47",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-47",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-48",
            0
          ],
          "destination": [
            "obj-49",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-49",
            0
          ],
          "destination": [
            "obj-50",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-50",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            0
          ],
          "destination": [
            "obj-52",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            0
          ],
          "destination": [
            "obj-53",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-53",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-54",
            0
          ],
          "destination": [
            "obj-55",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-55",
            0
          ],
          "destination": [
            "obj-56",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-56",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-57",
            0
          ],
          "destination": [
            "obj-58",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-58",
            0
          ],
          "destination": [
            "obj-59",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-59",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-61",
            0
          ],
          "destination": [
            "obj-62",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-62",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-63",
            0
          ],
          "destination": [
            "obj-64",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-64",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-65",
            0
          ],
          "destination": [
            "obj-66",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-66",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-67",
            0
          ],
          "destination": [
            "obj-68",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-68",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-69",
            0
          ],
          "destination": [
            "obj-70",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-70",
            0
          ],
          "destination": [
            "obj-71",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-71",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-72",
            0
          ],
          "destination": [
            "obj-73",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-76",
            0
          ],
          "destination": [
            "obj-77",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-77",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-80",
            0
          ],
          "destination": [
            "obj-79",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-75",
            0
          ],
          "destination": [
            "obj-81",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-81",
            0
          ],
          "destination": [
            "obj-82",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-82",
            0
          ],
          "destination": [
            "obj-83",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-86",
            2
          ],
          "destination": [
            "obj-87",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-87",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-86",
            0
          ],
          "destination": [
            "obj-88",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-86",
            1
          ],
          "destination": [
            "obj-88",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-84",
            0
          ],
          "destination": [
            "obj-89",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-86",
            0
          ],
          "destination": [
            "obj-89",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-89",
            0
          ],
          "destination": [
            "obj-90",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-83",
            0
          ],
          "destination": [
            "obj-90",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-90",
            0
          ],
          "destination": [
            "obj-91",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-91",
            0
          ],
          "destination": [
            "obj-78",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-91",
            0
          ],
          "destination": [
            "obj-85",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-91",
            0
          ],
          "destination": [
            "obj-92",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-92",
            0
          ],
          "destination": [
            "obj-80",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-84",
            1
          ],
          "destination": [
            "obj-93",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-88",
            0
          ],
          "destination": [
            "obj-93",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-93",
            0
          ],
          "destination": [
            "obj-94",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-83",
            0
          ],
          "destination": [
            "obj-94",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-94",
            0
          ],
          "destination": [
            "obj-95",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-95",
            0
          ],
          "destination": [
            "obj-78",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-95",
            0
          ],
          "destination": [
            "obj-85",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-95",
            0
          ],
          "destination": [
            "obj-96",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-96",
            0
          ],
          "destination": [
            "obj-80",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-14",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-99",
            0
          ],
          "destination": [
            "obj-100",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-100",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-104",
            0
          ],
          "destination": [
            "obj-105",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-105",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-109",
            0
          ],
          "destination": [
            "obj-110",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-110",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-111",
            0
          ],
          "destination": [
            "obj-112",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-112",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-113",
            0
          ],
          "destination": [
            "obj-114",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-114",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-115",
            0
          ],
          "destination": [
            "obj-116",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-116",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            0
          ],
          "destination": [
            "obj-118",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-118",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-119",
            0
          ],
          "destination": [
            "obj-120",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-120",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-121",
            0
          ],
          "destination": [
            "obj-122",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-122",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-123",
            0
          ],
          "destination": [
            "obj-124",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-124",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-125",
            0
          ],
          "destination": [
            "obj-126",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-126",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-130",
            0
          ],
          "destination": [
            "obj-129",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-129",
            0
          ],
          "destination": [
            "obj-131",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-132",
            0
          ],
          "destination": [
            "obj-133",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-132",
            1
          ],
          "destination": [
            "obj-134",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-134",
            0
          ],
          "destination": [
            "obj-135",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-135",
            0
          ],
          "destination": [
            "obj-136",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-136",
            0
          ],
          "destination": [
            "obj-132",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-13",
            0
          ],
          "destination": [
            "obj-137",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-137",
            0
          ],
          "destination": [
            "obj-132",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-6",
            0
          ],
          "destination": [
            "obj-139",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-141",
            0
          ],
          "destination": [
            "obj-140",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-15",
            0
          ],
          "destination": [
            "obj-140",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-131",
            0
          ],
          "destination": [
            "obj-140",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-142",
            0
          ],
          "destination": [
            "obj-140",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            0
          ],
          "destination": [
            "obj-145",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-144",
            0
          ],
          "destination": [
            "obj-146",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-145",
            0
          ],
          "destination": [
            "obj-146",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-146",
            0
          ],
          "destination": [
            "obj-147",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-147",
            0
          ],
          "destination": [
            "obj-140",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            3
          ],
          "destination": [
            "obj-134",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-143",
            0
          ],
          "destination": [
            "obj-148",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-148",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            1
          ],
          "destination": [
            "obj-151",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-150",
            0
          ],
          "destination": [
            "obj-152",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-151",
            0
          ],
          "destination": [
            "obj-152",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-152",
            0
          ],
          "destination": [
            "obj-153",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-153",
            0
          ],
          "destination": [
            "obj-140",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            4
          ],
          "destination": [
            "obj-134",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-149",
            0
          ],
          "destination": [
            "obj-154",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-154",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            2
          ],
          "destination": [
            "obj-157",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-156",
            0
          ],
          "destination": [
            "obj-158",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-157",
            0
          ],
          "destination": [
            "obj-158",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-158",
            0
          ],
          "destination": [
            "obj-159",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-159",
            0
          ],
          "destination": [
            "obj-140",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            5
          ],
          "destination": [
            "obj-134",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-155",
            0
          ],
          "destination": [
            "obj-156",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-155",
            0
          ],
          "destination": [
            "obj-160",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-160",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            3
          ],
          "destination": [
            "obj-163",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-162",
            0
          ],
          "destination": [
            "obj-164",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-163",
            0
          ],
          "destination": [
            "obj-164",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-164",
            0
          ],
          "destination": [
            "obj-140",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            6
          ],
          "destination": [
            "obj-134",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-161",
            0
          ],
          "destination": [
            "obj-162",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-161",
            0
          ],
          "destination": [
            "obj-165",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-165",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            4
          ],
          "destination": [
            "obj-168",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-167",
            0
          ],
          "destination": [
            "obj-169",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-168",
            0
          ],
          "destination": [
            "obj-169",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-169",
            0
          ],
          "destination": [
            "obj-140",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            7
          ],
          "destination": [
            "obj-134",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-166",
            0
          ],
          "destination": [
            "obj-167",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-166",
            0
          ],
          "destination": [
            "obj-170",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-170",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            5
          ],
          "destination": [
            "obj-173",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-172",
            0
          ],
          "destination": [
            "obj-174",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-173",
            0
          ],
          "destination": [
            "obj-174",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            0
          ],
          "destination": [
            "obj-175",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-175",
            0
          ],
          "destination": [
            "obj-140",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            8
          ],
          "destination": [
            "obj-134",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-171",
            0
          ],
          "destination": [
            "obj-172",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-171",
            0
          ],
          "destination": [
            "obj-176",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-176",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            6
          ],
          "destination": [
            "obj-179",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-178",
            0
          ],
          "destination": [
            "obj-180",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-179",
            0
          ],
          "destination": [
            "obj-180",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-180",
            0
          ],
          "destination": [
            "obj-181",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            0
          ],
          "destination": [
            "obj-140",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            9
          ],
          "destination": [
            "obj-134",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-177",
            0
          ],
          "destination": [
            "obj-178",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-177",
            0
          ],
          "destination": [
            "obj-182",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-182",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            7
          ],
          "destination": [
            "obj-185",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-184",
            0
          ],
          "destination": [
            "obj-186",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-185",
            0
          ],
          "destination": [
            "obj-186",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-186",
            0
          ],
          "destination": [
            "obj-187",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-187",
            0
          ],
          "destination": [
            "obj-140",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            10
          ],
          "destination": [
            "obj-134",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-183",
            0
          ],
          "destination": [
            "obj-184",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-183",
            0
          ],
          "destination": [
            "obj-188",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-188",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            8
          ],
          "destination": [
            "obj-191",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-190",
            0
          ],
          "destination": [
            "obj-192",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-191",
            0
          ],
          "destination": [
            "obj-192",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-192",
            0
          ],
          "destination": [
            "obj-193",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-193",
            0
          ],
          "destination": [
            "obj-140",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            11
          ],
          "destination": [
            "obj-134",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-189",
            0
          ],
          "destination": [
            "obj-190",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-189",
            0
          ],
          "destination": [
            "obj-194",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-194",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-195",
            0
          ],
          "destination": [
            "obj-196",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-196",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-197",
            0
          ],
          "destination": [
            "obj-198",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-198",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-201",
            0
          ],
          "destination": [
            "obj-183",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-200",
            0
          ],
          "destination": [
            "obj-183",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-183",
            0
          ],
          "destination": [
            "obj-203",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-203",
            0
          ],
          "destination": [
            "obj-200",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-199",
            0
          ],
          "destination": [
            "obj-189",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-189",
            0
          ],
          "destination": [
            "obj-204",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-204",
            0
          ],
          "destination": [
            "obj-199",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-203",
            0
          ],
          "destination": [
            "obj-201",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-206",
            0
          ],
          "destination": [
            "obj-202",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            0
          ],
          "destination": [
            "obj-207",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-205",
            0
          ],
          "destination": [
            "obj-207",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-207",
            0
          ],
          "destination": [
            "obj-84",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-207",
            0
          ],
          "destination": [
            "obj-208",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-208",
            0
          ],
          "destination": [
            "obj-206",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            1
          ],
          "destination": [
            "obj-209",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-205",
            0
          ],
          "destination": [
            "obj-209",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-209",
            0
          ],
          "destination": [
            "obj-84",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-209",
            0
          ],
          "destination": [
            "obj-210",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-210",
            0
          ],
          "destination": [
            "obj-206",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-139",
            5
          ],
          "destination": [
            "obj-211",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-211",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-139",
            4
          ],
          "destination": [
            "obj-212",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-212",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-138",
            0
          ],
          "destination": [
            "obj-213",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-213",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-140",
            2
          ],
          "destination": [
            "obj-214",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-214",
            0
          ],
          "destination": [
            "obj-215",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-215",
            0
          ],
          "destination": [
            "obj-216",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-216",
            0
          ],
          "destination": [
            "obj-139",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-6",
            1
          ],
          "destination": [
            "obj-218",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-220",
            0
          ],
          "destination": [
            "obj-219",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-15",
            0
          ],
          "destination": [
            "obj-219",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-131",
            0
          ],
          "destination": [
            "obj-219",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-221",
            0
          ],
          "destination": [
            "obj-219",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            9
          ],
          "destination": [
            "obj-224",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-223",
            0
          ],
          "destination": [
            "obj-225",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-224",
            0
          ],
          "destination": [
            "obj-225",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-225",
            0
          ],
          "destination": [
            "obj-226",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-226",
            0
          ],
          "destination": [
            "obj-219",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            3
          ],
          "destination": [
            "obj-134",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-222",
            0
          ],
          "destination": [
            "obj-227",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-227",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            10
          ],
          "destination": [
            "obj-230",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-229",
            0
          ],
          "destination": [
            "obj-231",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-230",
            0
          ],
          "destination": [
            "obj-231",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-231",
            0
          ],
          "destination": [
            "obj-232",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-232",
            0
          ],
          "destination": [
            "obj-219",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            4
          ],
          "destination": [
            "obj-134",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-228",
            0
          ],
          "destination": [
            "obj-233",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-233",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            11
          ],
          "destination": [
            "obj-236",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-235",
            0
          ],
          "destination": [
            "obj-237",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-236",
            0
          ],
          "destination": [
            "obj-237",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-237",
            0
          ],
          "destination": [
            "obj-238",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-238",
            0
          ],
          "destination": [
            "obj-219",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            5
          ],
          "destination": [
            "obj-134",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-234",
            0
          ],
          "destination": [
            "obj-235",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-234",
            0
          ],
          "destination": [
            "obj-239",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-239",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            12
          ],
          "destination": [
            "obj-242",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-241",
            0
          ],
          "destination": [
            "obj-243",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-242",
            0
          ],
          "destination": [
            "obj-243",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-243",
            0
          ],
          "destination": [
            "obj-219",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            6
          ],
          "destination": [
            "obj-134",
            13
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-240",
            0
          ],
          "destination": [
            "obj-241",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-240",
            0
          ],
          "destination": [
            "obj-244",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-244",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            13
          ],
          "destination": [
            "obj-247",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-246",
            0
          ],
          "destination": [
            "obj-248",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-247",
            0
          ],
          "destination": [
            "obj-248",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-248",
            0
          ],
          "destination": [
            "obj-219",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            7
          ],
          "destination": [
            "obj-134",
            14
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-245",
            0
          ],
          "destination": [
            "obj-246",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-245",
            0
          ],
          "destination": [
            "obj-249",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-249",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            14
          ],
          "destination": [
            "obj-252",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-251",
            0
          ],
          "destination": [
            "obj-253",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-252",
            0
          ],
          "destination": [
            "obj-253",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-253",
            0
          ],
          "destination": [
            "obj-254",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-254",
            0
          ],
          "destination": [
            "obj-219",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            8
          ],
          "destination": [
            "obj-134",
            15
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-250",
            0
          ],
          "destination": [
            "obj-251",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-250",
            0
          ],
          "destination": [
            "obj-255",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-255",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            15
          ],
          "destination": [
            "obj-258",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-257",
            0
          ],
          "destination": [
            "obj-259",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-258",
            0
          ],
          "destination": [
            "obj-259",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-259",
            0
          ],
          "destination": [
            "obj-260",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            0
          ],
          "destination": [
            "obj-219",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            9
          ],
          "destination": [
            "obj-134",
            16
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-256",
            0
          ],
          "destination": [
            "obj-257",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-256",
            0
          ],
          "destination": [
            "obj-261",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-261",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            16
          ],
          "destination": [
            "obj-264",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-263",
            0
          ],
          "destination": [
            "obj-265",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-264",
            0
          ],
          "destination": [
            "obj-265",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-265",
            0
          ],
          "destination": [
            "obj-266",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-266",
            0
          ],
          "destination": [
            "obj-219",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            10
          ],
          "destination": [
            "obj-134",
            17
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-262",
            0
          ],
          "destination": [
            "obj-263",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-262",
            0
          ],
          "destination": [
            "obj-267",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-267",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            17
          ],
          "destination": [
            "obj-270",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-269",
            0
          ],
          "destination": [
            "obj-271",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-270",
            0
          ],
          "destination": [
            "obj-271",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-271",
            0
          ],
          "destination": [
            "obj-272",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-272",
            0
          ],
          "destination": [
            "obj-219",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            11
          ],
          "destination": [
            "obj-134",
            18
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-268",
            0
          ],
          "destination": [
            "obj-269",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-268",
            0
          ],
          "destination": [
            "obj-273",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-273",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-274",
            0
          ],
          "destination": [
            "obj-275",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-275",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-276",
            0
          ],
          "destination": [
            "obj-277",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-277",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-280",
            0
          ],
          "destination": [
            "obj-262",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-279",
            0
          ],
          "destination": [
            "obj-262",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-262",
            0
          ],
          "destination": [
            "obj-282",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-282",
            0
          ],
          "destination": [
            "obj-279",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-278",
            0
          ],
          "destination": [
            "obj-268",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-268",
            0
          ],
          "destination": [
            "obj-283",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-283",
            0
          ],
          "destination": [
            "obj-278",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-282",
            0
          ],
          "destination": [
            "obj-280",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-285",
            0
          ],
          "destination": [
            "obj-281",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            0
          ],
          "destination": [
            "obj-286",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-284",
            0
          ],
          "destination": [
            "obj-286",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-286",
            0
          ],
          "destination": [
            "obj-84",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-286",
            0
          ],
          "destination": [
            "obj-287",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-287",
            0
          ],
          "destination": [
            "obj-285",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            1
          ],
          "destination": [
            "obj-288",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-284",
            0
          ],
          "destination": [
            "obj-288",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-288",
            0
          ],
          "destination": [
            "obj-84",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-288",
            0
          ],
          "destination": [
            "obj-289",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-289",
            0
          ],
          "destination": [
            "obj-285",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-218",
            5
          ],
          "destination": [
            "obj-290",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-290",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-218",
            4
          ],
          "destination": [
            "obj-291",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-291",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-217",
            0
          ],
          "destination": [
            "obj-292",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-292",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-219",
            2
          ],
          "destination": [
            "obj-293",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-293",
            0
          ],
          "destination": [
            "obj-294",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-294",
            0
          ],
          "destination": [
            "obj-295",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-295",
            0
          ],
          "destination": [
            "obj-218",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-6",
            2
          ],
          "destination": [
            "obj-297",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-299",
            0
          ],
          "destination": [
            "obj-298",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-15",
            0
          ],
          "destination": [
            "obj-298",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-131",
            0
          ],
          "destination": [
            "obj-298",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-300",
            0
          ],
          "destination": [
            "obj-298",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            18
          ],
          "destination": [
            "obj-303",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-302",
            0
          ],
          "destination": [
            "obj-304",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-303",
            0
          ],
          "destination": [
            "obj-304",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-304",
            0
          ],
          "destination": [
            "obj-305",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-305",
            0
          ],
          "destination": [
            "obj-298",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            3
          ],
          "destination": [
            "obj-134",
            19
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-301",
            0
          ],
          "destination": [
            "obj-306",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-306",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            19
          ],
          "destination": [
            "obj-309",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-308",
            0
          ],
          "destination": [
            "obj-310",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-309",
            0
          ],
          "destination": [
            "obj-310",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-310",
            0
          ],
          "destination": [
            "obj-311",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-311",
            0
          ],
          "destination": [
            "obj-298",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            4
          ],
          "destination": [
            "obj-134",
            20
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-307",
            0
          ],
          "destination": [
            "obj-312",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-312",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            20
          ],
          "destination": [
            "obj-315",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-314",
            0
          ],
          "destination": [
            "obj-316",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-315",
            0
          ],
          "destination": [
            "obj-316",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-316",
            0
          ],
          "destination": [
            "obj-317",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-317",
            0
          ],
          "destination": [
            "obj-298",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            5
          ],
          "destination": [
            "obj-134",
            21
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-313",
            0
          ],
          "destination": [
            "obj-314",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-313",
            0
          ],
          "destination": [
            "obj-318",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-318",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            21
          ],
          "destination": [
            "obj-321",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-320",
            0
          ],
          "destination": [
            "obj-322",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-321",
            0
          ],
          "destination": [
            "obj-322",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-322",
            0
          ],
          "destination": [
            "obj-298",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            6
          ],
          "destination": [
            "obj-134",
            22
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-319",
            0
          ],
          "destination": [
            "obj-320",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-319",
            0
          ],
          "destination": [
            "obj-323",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-323",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            22
          ],
          "destination": [
            "obj-326",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-325",
            0
          ],
          "destination": [
            "obj-327",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-326",
            0
          ],
          "destination": [
            "obj-327",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-327",
            0
          ],
          "destination": [
            "obj-298",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            7
          ],
          "destination": [
            "obj-134",
            23
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-324",
            0
          ],
          "destination": [
            "obj-325",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-324",
            0
          ],
          "destination": [
            "obj-328",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-328",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            23
          ],
          "destination": [
            "obj-331",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-330",
            0
          ],
          "destination": [
            "obj-332",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-331",
            0
          ],
          "destination": [
            "obj-332",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-332",
            0
          ],
          "destination": [
            "obj-333",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-333",
            0
          ],
          "destination": [
            "obj-298",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            8
          ],
          "destination": [
            "obj-134",
            24
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-329",
            0
          ],
          "destination": [
            "obj-330",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-329",
            0
          ],
          "destination": [
            "obj-334",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-334",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            24
          ],
          "destination": [
            "obj-337",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-336",
            0
          ],
          "destination": [
            "obj-338",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-337",
            0
          ],
          "destination": [
            "obj-338",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-338",
            0
          ],
          "destination": [
            "obj-339",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            0
          ],
          "destination": [
            "obj-298",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            9
          ],
          "destination": [
            "obj-134",
            25
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-335",
            0
          ],
          "destination": [
            "obj-336",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-335",
            0
          ],
          "destination": [
            "obj-340",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-340",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            25
          ],
          "destination": [
            "obj-343",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-342",
            0
          ],
          "destination": [
            "obj-344",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-343",
            0
          ],
          "destination": [
            "obj-344",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-344",
            0
          ],
          "destination": [
            "obj-345",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-345",
            0
          ],
          "destination": [
            "obj-298",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            10
          ],
          "destination": [
            "obj-134",
            26
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-341",
            0
          ],
          "destination": [
            "obj-342",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-341",
            0
          ],
          "destination": [
            "obj-346",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-346",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            26
          ],
          "destination": [
            "obj-349",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-348",
            0
          ],
          "destination": [
            "obj-350",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-349",
            0
          ],
          "destination": [
            "obj-350",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-350",
            0
          ],
          "destination": [
            "obj-351",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-351",
            0
          ],
          "destination": [
            "obj-298",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            11
          ],
          "destination": [
            "obj-134",
            27
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-347",
            0
          ],
          "destination": [
            "obj-348",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-347",
            0
          ],
          "destination": [
            "obj-352",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-352",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-353",
            0
          ],
          "destination": [
            "obj-354",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-354",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-355",
            0
          ],
          "destination": [
            "obj-356",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-356",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-359",
            0
          ],
          "destination": [
            "obj-341",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-358",
            0
          ],
          "destination": [
            "obj-341",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-341",
            0
          ],
          "destination": [
            "obj-361",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-361",
            0
          ],
          "destination": [
            "obj-358",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-357",
            0
          ],
          "destination": [
            "obj-347",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-347",
            0
          ],
          "destination": [
            "obj-362",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-362",
            0
          ],
          "destination": [
            "obj-357",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-361",
            0
          ],
          "destination": [
            "obj-359",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-364",
            0
          ],
          "destination": [
            "obj-360",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            0
          ],
          "destination": [
            "obj-365",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-363",
            0
          ],
          "destination": [
            "obj-365",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-365",
            0
          ],
          "destination": [
            "obj-84",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-365",
            0
          ],
          "destination": [
            "obj-366",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-366",
            0
          ],
          "destination": [
            "obj-364",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            1
          ],
          "destination": [
            "obj-367",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-363",
            0
          ],
          "destination": [
            "obj-367",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-367",
            0
          ],
          "destination": [
            "obj-84",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-367",
            0
          ],
          "destination": [
            "obj-368",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-368",
            0
          ],
          "destination": [
            "obj-364",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-297",
            5
          ],
          "destination": [
            "obj-369",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-369",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-297",
            4
          ],
          "destination": [
            "obj-370",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-370",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-296",
            0
          ],
          "destination": [
            "obj-371",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-371",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-298",
            2
          ],
          "destination": [
            "obj-372",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-372",
            0
          ],
          "destination": [
            "obj-373",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-373",
            0
          ],
          "destination": [
            "obj-374",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-374",
            0
          ],
          "destination": [
            "obj-297",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-6",
            3
          ],
          "destination": [
            "obj-376",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-378",
            0
          ],
          "destination": [
            "obj-377",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-15",
            0
          ],
          "destination": [
            "obj-377",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-131",
            0
          ],
          "destination": [
            "obj-377",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-379",
            0
          ],
          "destination": [
            "obj-377",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            27
          ],
          "destination": [
            "obj-382",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-381",
            0
          ],
          "destination": [
            "obj-383",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-382",
            0
          ],
          "destination": [
            "obj-383",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-383",
            0
          ],
          "destination": [
            "obj-384",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-384",
            0
          ],
          "destination": [
            "obj-377",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            3
          ],
          "destination": [
            "obj-134",
            28
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-380",
            0
          ],
          "destination": [
            "obj-385",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-385",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            28
          ],
          "destination": [
            "obj-388",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-387",
            0
          ],
          "destination": [
            "obj-389",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-388",
            0
          ],
          "destination": [
            "obj-389",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-389",
            0
          ],
          "destination": [
            "obj-390",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-390",
            0
          ],
          "destination": [
            "obj-377",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            4
          ],
          "destination": [
            "obj-134",
            29
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-386",
            0
          ],
          "destination": [
            "obj-391",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-391",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            29
          ],
          "destination": [
            "obj-394",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-393",
            0
          ],
          "destination": [
            "obj-395",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-394",
            0
          ],
          "destination": [
            "obj-395",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-395",
            0
          ],
          "destination": [
            "obj-396",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-396",
            0
          ],
          "destination": [
            "obj-377",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            5
          ],
          "destination": [
            "obj-134",
            30
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-392",
            0
          ],
          "destination": [
            "obj-393",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-392",
            0
          ],
          "destination": [
            "obj-397",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-397",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            30
          ],
          "destination": [
            "obj-400",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-399",
            0
          ],
          "destination": [
            "obj-401",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-400",
            0
          ],
          "destination": [
            "obj-401",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-401",
            0
          ],
          "destination": [
            "obj-377",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            6
          ],
          "destination": [
            "obj-134",
            31
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-398",
            0
          ],
          "destination": [
            "obj-399",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-398",
            0
          ],
          "destination": [
            "obj-402",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-402",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            31
          ],
          "destination": [
            "obj-405",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-404",
            0
          ],
          "destination": [
            "obj-406",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-405",
            0
          ],
          "destination": [
            "obj-406",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-406",
            0
          ],
          "destination": [
            "obj-377",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            7
          ],
          "destination": [
            "obj-134",
            32
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-403",
            0
          ],
          "destination": [
            "obj-404",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-403",
            0
          ],
          "destination": [
            "obj-407",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-407",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            32
          ],
          "destination": [
            "obj-410",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-409",
            0
          ],
          "destination": [
            "obj-411",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-410",
            0
          ],
          "destination": [
            "obj-411",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-411",
            0
          ],
          "destination": [
            "obj-412",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-412",
            0
          ],
          "destination": [
            "obj-377",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            8
          ],
          "destination": [
            "obj-134",
            33
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-408",
            0
          ],
          "destination": [
            "obj-409",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-408",
            0
          ],
          "destination": [
            "obj-413",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-413",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            33
          ],
          "destination": [
            "obj-416",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-415",
            0
          ],
          "destination": [
            "obj-417",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-416",
            0
          ],
          "destination": [
            "obj-417",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-417",
            0
          ],
          "destination": [
            "obj-418",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            0
          ],
          "destination": [
            "obj-377",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            9
          ],
          "destination": [
            "obj-134",
            34
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-414",
            0
          ],
          "destination": [
            "obj-415",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-414",
            0
          ],
          "destination": [
            "obj-419",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-419",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            34
          ],
          "destination": [
            "obj-422",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-421",
            0
          ],
          "destination": [
            "obj-423",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-422",
            0
          ],
          "destination": [
            "obj-423",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-423",
            0
          ],
          "destination": [
            "obj-424",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-424",
            0
          ],
          "destination": [
            "obj-377",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            10
          ],
          "destination": [
            "obj-134",
            35
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-420",
            0
          ],
          "destination": [
            "obj-421",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-420",
            0
          ],
          "destination": [
            "obj-425",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-425",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-133",
            35
          ],
          "destination": [
            "obj-428",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-427",
            0
          ],
          "destination": [
            "obj-429",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-428",
            0
          ],
          "destination": [
            "obj-429",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-429",
            0
          ],
          "destination": [
            "obj-430",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-430",
            0
          ],
          "destination": [
            "obj-377",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            11
          ],
          "destination": [
            "obj-134",
            36
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-426",
            0
          ],
          "destination": [
            "obj-427",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-426",
            0
          ],
          "destination": [
            "obj-431",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-431",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-432",
            0
          ],
          "destination": [
            "obj-433",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-433",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-434",
            0
          ],
          "destination": [
            "obj-435",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-435",
            0
          ],
          "destination": [
            "obj-98",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-438",
            0
          ],
          "destination": [
            "obj-420",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-437",
            0
          ],
          "destination": [
            "obj-420",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-420",
            0
          ],
          "destination": [
            "obj-440",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-440",
            0
          ],
          "destination": [
            "obj-437",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-436",
            0
          ],
          "destination": [
            "obj-426",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-426",
            0
          ],
          "destination": [
            "obj-441",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-441",
            0
          ],
          "destination": [
            "obj-436",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-440",
            0
          ],
          "destination": [
            "obj-438",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-443",
            0
          ],
          "destination": [
            "obj-439",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            0
          ],
          "destination": [
            "obj-444",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-442",
            0
          ],
          "destination": [
            "obj-444",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-444",
            0
          ],
          "destination": [
            "obj-84",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-444",
            0
          ],
          "destination": [
            "obj-445",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-445",
            0
          ],
          "destination": [
            "obj-443",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            1
          ],
          "destination": [
            "obj-446",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-442",
            0
          ],
          "destination": [
            "obj-446",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-446",
            0
          ],
          "destination": [
            "obj-84",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-446",
            0
          ],
          "destination": [
            "obj-447",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-447",
            0
          ],
          "destination": [
            "obj-443",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-376",
            5
          ],
          "destination": [
            "obj-448",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-448",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-376",
            4
          ],
          "destination": [
            "obj-449",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-449",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-375",
            0
          ],
          "destination": [
            "obj-450",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-450",
            0
          ],
          "destination": [
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-377",
            2
          ],
          "destination": [
            "obj-451",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-451",
            0
          ],
          "destination": [
            "obj-452",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-452",
            0
          ],
          "destination": [
            "obj-453",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-453",
            0
          ],
          "destination": [
            "obj-376",
            0
          ]
        }
      }
    ]
  }
}
