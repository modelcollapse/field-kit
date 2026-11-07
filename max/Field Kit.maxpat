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
      818
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
          "text": "Audio I/O",
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
          "varname": "set_buffer",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            630,
            2180,
            166,
            22
          ],
          "text": "buffer~ fk-unbound-set",
          "outlettype": [
            "float",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-14",
          "varname": "set_source_info",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 10,
          "patching_rect": [
            810,
            2180,
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
          "id": "obj-15",
          "varname": "set_buffer_complete",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            935,
            2180,
            173,
            22
          ],
          "text": "prepend set_source_read"
        }
      },
      {
        "box": {
          "id": "obj-16",
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
          "id": "obj-17",
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
          "id": "obj-18",
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
          "id": "obj-19",
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
          "id": "obj-20",
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
          "id": "obj-21",
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
          "id": "obj-22",
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
          "id": "obj-23",
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
          "id": "obj-24",
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
          "id": "obj-25",
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
          "id": "obj-26",
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
          "id": "obj-27",
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
          "id": "obj-28",
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
          "id": "obj-29",
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
          "id": "obj-30",
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
          "id": "obj-31",
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
          "id": "obj-32",
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
          "id": "obj-33",
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
          "id": "obj-34",
          "varname": "pattern_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            16,
            174,
            92,
            20
          ],
          "text": "Patterns",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            16,
            174,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-35",
          "varname": "set_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            174,
            92,
            20
          ],
          "text": "Set files",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            688,
            174,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-36",
          "varname": "set_divider",
          "maxclass": "panel",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            681,
            170,
            1,
            48
          ],
          "background": 1,
          "border": 0,
          "rounded": 0,
          "bgcolor": [
            0.37,
            0.37,
            0.37,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            681,
            170,
            1,
            48
          ]
        }
      },
      {
        "box": {
          "id": "obj-37",
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
          "id": "obj-38",
          "varname": "pattern_gain",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1550,
            2120,
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
          "id": "obj-39",
          "varname": "pattern_gain_sample",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1550,
            2155,
            159,
            22
          ],
          "text": "snapshot~ 5 @active 0",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-40",
          "varname": "pattern_gain_zero",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1550,
            2190,
            54,
            22
          ],
          "text": "sel 0.",
          "outlettype": [
            "bang",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-41",
          "varname": "pattern_gain_defer",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1550,
            2225,
            68,
            22
          ],
          "text": "deferlow",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-42",
          "varname": "pattern_gain_ready",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1550,
            2260,
            95,
            22
          ],
          "text": "recall_silent"
        }
      },
      {
        "box": {
          "id": "obj-43",
          "varname": "pattern_dsp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1550,
            2295,
            138,
            22
          ],
          "text": "prepend recall_dsp"
        }
      },
      {
        "box": {
          "id": "obj-44",
          "varname": "pattern_slot_trigger",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2460,
            2000,
            47,
            22
          ],
          "text": "t i b",
          "outlettype": [
            "int",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-45",
          "varname": "pattern_modifiers",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 5,
          "patching_rect": [
            2580,
            2000,
            75,
            22
          ],
          "text": "modifiers",
          "outlettype": [
            "int",
            "int",
            "int",
            "int",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-46",
          "varname": "pattern_slot_and_shift",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2460,
            2035,
            68,
            22
          ],
          "text": "pack 0 0"
        }
      },
      {
        "box": {
          "id": "obj-47",
          "varname": "pattern_slot_command",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2460,
            2070,
            96,
            22
          ],
          "text": "prepend slot"
        }
      },
      {
        "box": {
          "id": "obj-48",
          "varname": "pattern_1",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            170,
            44,
            30
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "1",
          "texton": "1",
          "parameter_enable": 0,
          "hint": "Click to recall pattern 1. Shift-click to store or replace it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            170,
            44,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-49",
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
          "id": "obj-50",
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
          "text": "1"
        }
      },
      {
        "box": {
          "id": "obj-51",
          "varname": "pattern_2",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            170,
            44,
            30
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "2",
          "texton": "2",
          "parameter_enable": 0,
          "hint": "Click to recall pattern 2. Shift-click to store or replace it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            160,
            170,
            44,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-52",
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
          "id": "obj-53",
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
          "text": "2"
        }
      },
      {
        "box": {
          "id": "obj-54",
          "varname": "pattern_3",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            170,
            44,
            30
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "3",
          "texton": "3",
          "parameter_enable": 0,
          "hint": "Click to recall pattern 3. Shift-click to store or replace it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            208,
            170,
            44,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-55",
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
          "id": "obj-56",
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
          "text": "3"
        }
      },
      {
        "box": {
          "id": "obj-57",
          "varname": "pattern_4",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            256,
            170,
            44,
            30
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "4",
          "texton": "4",
          "parameter_enable": 0,
          "hint": "Click to recall pattern 4. Shift-click to store or replace it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            256,
            170,
            44,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-58",
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
          "id": "obj-59",
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
          "text": "4"
        }
      },
      {
        "box": {
          "id": "obj-60",
          "varname": "pattern_5",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            304,
            170,
            44,
            30
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "5",
          "texton": "5",
          "parameter_enable": 0,
          "hint": "Click to recall pattern 5. Shift-click to store or replace it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            304,
            170,
            44,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-61",
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
          "id": "obj-62",
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
          "text": "5"
        }
      },
      {
        "box": {
          "id": "obj-63",
          "varname": "pattern_6",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            352,
            170,
            44,
            30
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "6",
          "texton": "6",
          "parameter_enable": 0,
          "hint": "Click to recall pattern 6. Shift-click to store or replace it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            352,
            170,
            44,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-64",
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
          "id": "obj-65",
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
          "text": "6"
        }
      },
      {
        "box": {
          "id": "obj-66",
          "varname": "pattern_7",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            400,
            170,
            44,
            30
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "7",
          "texton": "7",
          "parameter_enable": 0,
          "hint": "Click to recall pattern 7. Shift-click to store or replace it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            400,
            170,
            44,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-67",
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
          "id": "obj-68",
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
          "text": "7"
        }
      },
      {
        "box": {
          "id": "obj-69",
          "varname": "pattern_8",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            448,
            170,
            44,
            30
          ],
          "mode": 1,
          "outputmode": 1,
          "text": "8",
          "texton": "8",
          "parameter_enable": 0,
          "hint": "Click to recall pattern 8. Shift-click to store or replace it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            448,
            170,
            44,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-70",
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
          "id": "obj-71",
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
          "text": "8"
        }
      },
      {
        "box": {
          "id": "obj-72",
          "varname": "pattern_store",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            496,
            170,
            92,
            30
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
            170,
            92,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-73",
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
          "id": "obj-74",
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
          "id": "obj-75",
          "varname": "pattern_status",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            16,
            202,
            668,
            20
          ],
          "text": "Click to recall. Shift-click to store.",
          "presentation": 1,
          "presentation_rect": [
            16,
            202,
            668,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-76",
          "varname": "set_status",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            202,
            380,
            20
          ],
          "text": "Saves the sample location, patterns, and current mix.",
          "presentation": 1,
          "presentation_rect": [
            688,
            202,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-77",
          "varname": "pattern_banks",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            592,
            174,
            86,
            22
          ],
          "items": [
            "Banks…",
            ",",
            "Load Bank…",
            ",",
            "Save Bank…"
          ],
          "align": 1,
          "allowdrag": 0,
          "parameter_enable": 0,
          "hint": "Load or save a bank of pattern slots.",
          "outlettype": [
            "int",
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            592,
            174,
            86,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-78",
          "varname": "pattern_bank_action",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1955,
            2010,
            47,
            22
          ],
          "text": "t i b",
          "outlettype": [
            "int",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-79",
          "varname": "pattern_bank_label",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2050,
            2040,
            58,
            22
          ],
          "text": "set 0"
        }
      },
      {
        "box": {
          "id": "obj-80",
          "varname": "pattern_bank_choice",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1955,
            2040,
            61,
            22
          ],
          "text": "sel 1 2",
          "outlettype": [
            "bang",
            "bang",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-81",
          "varname": "set_open",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            784,
            170,
            140,
            30
          ],
          "mode": 0,
          "text": "Open Set…",
          "texton": "Open Set…",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            784,
            170,
            140,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-82",
          "varname": "set_open_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            2090,
            80,
            22
          ],
          "text": "open_set"
        }
      },
      {
        "box": {
          "id": "obj-83",
          "varname": "set_open_dialog",
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
          "id": "obj-84",
          "varname": "set_open_result",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            2160,
            124,
            22
          ],
          "text": "prepend read_set"
        }
      },
      {
        "box": {
          "id": "obj-85",
          "varname": "set_save",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            928,
            170,
            140,
            30
          ],
          "mode": 0,
          "text": "Save Set…",
          "texton": "Save Set…",
          "parameter_enable": 0,
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            928,
            170,
            140,
            30
          ]
        }
      },
      {
        "box": {
          "id": "obj-86",
          "varname": "set_save_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1665,
            2090,
            80,
            22
          ],
          "text": "save_set"
        }
      },
      {
        "box": {
          "id": "obj-87",
          "varname": "set_save_dialog",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1665,
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
          "id": "obj-88",
          "varname": "set_save_result",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1665,
            2160,
            131,
            22
          ],
          "text": "prepend write_set"
        }
      },
      {
        "box": {
          "id": "obj-89",
          "varname": "pattern_load_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            2090,
            80,
            22
          ],
          "text": "load_bank"
        }
      },
      {
        "box": {
          "id": "obj-90",
          "varname": "pattern_load_dialog",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1810,
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
          "id": "obj-91",
          "varname": "pattern_load_result",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1810,
            2160,
            131,
            22
          ],
          "text": "prepend read_bank"
        }
      },
      {
        "box": {
          "id": "obj-92",
          "varname": "pattern_save_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1955,
            2090,
            80,
            22
          ],
          "text": "save_bank"
        }
      },
      {
        "box": {
          "id": "obj-93",
          "varname": "pattern_save_dialog",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            1955,
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
          "id": "obj-94",
          "varname": "pattern_save_result",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1955,
            2160,
            138,
            22
          ],
          "text": "prepend write_bank"
        }
      },
      {
        "box": {
          "id": "obj-95",
          "varname": "set_relink_dialog",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2125,
            2125,
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
          "id": "obj-96",
          "varname": "set_relink_result",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2125,
            2160,
            138,
            22
          ],
          "text": "prepend relink_set"
        }
      },
      {
        "box": {
          "id": "obj-97",
          "varname": "set_relink_cancel",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2280,
            2160,
            100,
            22
          ],
          "text": "cancel_relink"
        }
      },
      {
        "box": {
          "id": "obj-98",
          "varname": "set_writer",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2425,
            2125,
            299,
            22
          ],
          "text": "node.script fk_set_writer.js @autostart 1"
        }
      },
      {
        "box": {
          "id": "obj-99",
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
          "id": "obj-100",
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
          "id": "obj-101",
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
          "id": "obj-102",
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
          "id": "obj-103",
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
          "id": "obj-104",
          "varname": "master_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            784,
            686,
            92,
            20
          ],
          "text": "Master",
          "presentation": 1,
          "presentation_rect": [
            784,
            686,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-105",
          "varname": "master",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            880,
            686,
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
            686,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-106",
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
          "id": "obj-107",
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
          "id": "obj-108",
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
          "id": "obj-109",
          "varname": "mix_meter",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            928,
            686,
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
            686,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-110",
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
          "id": "obj-111",
          "varname": "master_ramp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            22,
            1840,
            96,
            22
          ],
          "text": "pack -12. 20"
        }
      },
      {
        "box": {
          "id": "obj-112",
          "varname": "master_base",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            22,
            1872,
            82,
            22
          ],
          "text": "line~ -12.",
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-113",
          "varname": "master_mod",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            127,
            1872,
            54,
            22
          ],
          "text": "*~ 36.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-114",
          "varname": "master_sum",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            22,
            1904,
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
          "id": "obj-115",
          "varname": "master_effective",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            22,
            1936,
            103,
            22
          ],
          "text": "clip~ -70. 0.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-116",
          "varname": "master_gain",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            22,
            1968,
            54,
            22
          ],
          "text": "dbtoa~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-117",
          "varname": "mix_fx",
          "maxclass": "bpatcher",
          "numinlets": 8,
          "numoutlets": 8,
          "patching_rect": [
            16,
            686,
            668,
            116
          ],
          "outlettype": [
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal"
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            686,
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
          "id": "obj-118",
          "varname": "recorder",
          "maxclass": "bpatcher",
          "numinlets": 2,
          "numoutlets": 0,
          "patching_rect": [
            688,
            686,
            380,
            116
          ],
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            688,
            686,
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
          "id": "obj-119",
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
          "id": "obj-120",
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
          "id": "obj-121",
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
          "id": "obj-122",
          "varname": "normal_blend",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1100,
            1880,
            68,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-123",
          "varname": "normal_fade_done",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1240,
            1880,
            115,
            22
          ],
          "text": "normal_faded"
        }
      },
      {
        "box": {
          "id": "obj-124",
          "varname": "normal_difference_left",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            1840,
            42,
            22
          ],
          "text": "-~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-125",
          "varname": "normal_blend_left",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            1880,
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
          "id": "obj-126",
          "varname": "normal_mix_l",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            1920,
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
          "id": "obj-127",
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
          "id": "obj-128",
          "varname": "pattern_level_left",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            360,
            1862,
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
          "id": "obj-129",
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
          "id": "obj-130",
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
          "id": "obj-131",
          "varname": "normal_difference_right",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            960,
            1840,
            42,
            22
          ],
          "text": "-~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-132",
          "varname": "normal_blend_right",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            960,
            1880,
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
          "id": "obj-133",
          "varname": "normal_mix_r",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            960,
            1920,
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
          "id": "obj-134",
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
          "id": "obj-135",
          "varname": "pattern_level_right",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            500,
            1862,
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
          "id": "obj-136",
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
          "id": "obj-137",
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
          "id": "obj-138",
          "varname": "mixer_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            16,
            230,
            92,
            20
          ],
          "text": "Mixer",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            16,
            230,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-139",
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
          "id": "obj-140",
          "varname": "mixer_clear_solo",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            230,
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
            230,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-141",
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
          "id": "obj-142",
          "varname": "row_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            256,
            230,
            188,
            20
          ],
          "text": "Playback windows",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            256,
            230,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-143",
          "varname": "wave_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            448,
            234,
            236,
            20
          ],
          "text": "Drag a range, release to set the loop",
          "presentation": 1,
          "presentation_rect": [
            448,
            234,
            236,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-144",
          "varname": "inspector_title",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            230,
            380,
            20
          ],
          "text": "Window controls",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            688,
            230,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-145",
          "varname": "inspector_tabs",
          "maxclass": "live.tab",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            688,
            254,
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
            254,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-146",
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
          "id": "obj-147",
          "varname": "inspector_label_14",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            278,
            92,
            20
          ],
          "text": "In %",
          "presentation": 1,
          "presentation_rect": [
            688,
            278,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-148",
          "varname": "inspector_label_16",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            784,
            278,
            92,
            20
          ],
          "text": "Out %",
          "presentation": 1,
          "presentation_rect": [
            784,
            278,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-149",
          "varname": "inspector_label_18",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            880,
            278,
            188,
            20
          ],
          "text": "Direction",
          "presentation": 1,
          "presentation_rect": [
            880,
            278,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-150",
          "varname": "inspect_start",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            688,
            302,
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
            302,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-151",
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
          "id": "obj-152",
          "varname": "inspect_end",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            784,
            302,
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
            302,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-153",
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
          "id": "obj-154",
          "varname": "inspect_rate",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            688,
            330,
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
            330,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-155",
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
          "id": "obj-156",
          "varname": "inspect_direction",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            880,
            302,
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
            302,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-157",
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
          "id": "obj-158",
          "varname": "inspect_fade",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            752,
            330,
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
            330,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-159",
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
          "id": "obj-160",
          "varname": "inspect_drive",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            816,
            330,
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
            330,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-161",
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
          "id": "obj-162",
          "varname": "inspect_filter",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            880,
            330,
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
            330,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-163",
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
          "id": "obj-164",
          "varname": "inspect_level",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            944,
            330,
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
            330,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-165",
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
          "id": "obj-166",
          "varname": "inspect_pan",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1008,
            330,
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
            330,
            60,
            88
          ]
        }
      },
      {
        "box": {
          "id": "obj-167",
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
          "id": "obj-168",
          "varname": "filter_help",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            688,
            422,
            140,
            20
          ],
          "text": "Filter: LP ← 0 → HP",
          "presentation": 1,
          "presentation_rect": [
            688,
            422,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-169",
          "varname": "pitch_scale_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            832,
            422,
            92,
            20
          ],
          "text": "Pitch snap · All",
          "presentation": 1,
          "presentation_rect": [
            832,
            422,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-170",
          "varname": "pitch_scale",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            928,
            422,
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
            422,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-171",
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
          "id": "obj-172",
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
          "id": "obj-173",
          "varname": "patchbay",
          "maxclass": "bpatcher",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            458,
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
            458,
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
          "id": "obj-174",
          "varname": "mod_signals",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 44,
          "patching_rect": [
            28,
            886,
            1016,
            22
          ],
          "text": "mc.unpack~ 44",
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
          "id": "obj-175",
          "varname": "watch_target",
          "maxclass": "newobj",
          "numinlets": 45,
          "numoutlets": 1,
          "patching_rect": [
            1560,
            886,
            660,
            22
          ],
          "text": "selector~ 44 1",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-176",
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
          "id": "obj-177",
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
          "id": "obj-178",
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
          "id": "obj-179",
          "varname": "play_1",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            254,
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
            254,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-180",
          "varname": "wave_1",
          "maxclass": "waveform~",
          "numinlets": 5,
          "numoutlets": 6,
          "patching_rect": [
            256,
            254,
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
            254,
            428,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-181",
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
          "id": "obj-182",
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
          "id": "obj-183",
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
          "id": "obj-184",
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
          "id": "obj-185",
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
          "id": "obj-186",
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
          "id": "obj-187",
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
          "id": "obj-188",
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
          "id": "obj-189",
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
          "id": "obj-190",
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
          "id": "obj-191",
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
          "id": "obj-192",
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
          "id": "obj-193",
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
          "id": "obj-194",
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
          "id": "obj-195",
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
          "id": "obj-196",
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
          "id": "obj-197",
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
          "id": "obj-198",
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
          "id": "obj-199",
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
          "id": "obj-200",
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
          "id": "obj-201",
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
          "id": "obj-202",
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
          "id": "obj-203",
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
          "id": "obj-204",
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
          "id": "obj-205",
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
          "id": "obj-206",
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
          "id": "obj-207",
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
          "id": "obj-208",
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
          "id": "obj-209",
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
          "id": "obj-210",
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
          "id": "obj-211",
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
          "id": "obj-212",
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
          "id": "obj-213",
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
          "id": "obj-214",
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
          "id": "obj-215",
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
          "id": "obj-216",
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
          "id": "obj-217",
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
          "id": "obj-218",
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
          "id": "obj-219",
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
          "id": "obj-220",
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
          "id": "obj-221",
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
          "id": "obj-222",
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
          "id": "obj-223",
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
          "id": "obj-224",
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
          "id": "obj-225",
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
          "id": "obj-226",
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
          "id": "obj-227",
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
          "id": "obj-228",
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
          "id": "obj-229",
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
          "id": "obj-230",
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
          "id": "obj-231",
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
          "id": "obj-232",
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
          "id": "obj-233",
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
          "id": "obj-234",
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
          "id": "obj-235",
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
          "id": "obj-236",
          "varname": "mixer_mute_1",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            254,
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
            254,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-237",
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
          "id": "obj-238",
          "varname": "mixer_solo_1",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            254,
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
            254,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-239",
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
          "id": "obj-240",
          "varname": "mixer_pan_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            254,
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
            254,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-241",
          "varname": "mixer_level_1",
          "maxclass": "live.slider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            278,
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
            278,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-242",
          "varname": "mixer_level_value_1",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            280,
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
            280,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-243",
          "varname": "meter_1",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            278,
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
            278,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-244",
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
          "id": "obj-245",
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
          "id": "obj-246",
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
          "id": "obj-247",
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
          "id": "obj-248",
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
          "id": "obj-249",
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
          "id": "obj-250",
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
          "id": "obj-251",
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
          "id": "obj-252",
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
          "id": "obj-253",
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
          "id": "obj-254",
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
          "id": "obj-255",
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
          "id": "obj-256",
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
          "id": "obj-257",
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
          "id": "obj-258",
          "varname": "play_2",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            302,
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
            302,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-259",
          "varname": "wave_2",
          "maxclass": "waveform~",
          "numinlets": 5,
          "numoutlets": 6,
          "patching_rect": [
            256,
            302,
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
            302,
            428,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-260",
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
          "id": "obj-261",
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
          "id": "obj-262",
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
          "id": "obj-263",
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
          "id": "obj-264",
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
          "id": "obj-265",
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
          "id": "obj-266",
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
          "id": "obj-267",
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
          "id": "obj-268",
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
          "id": "obj-269",
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
          "id": "obj-270",
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
          "id": "obj-271",
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
          "id": "obj-272",
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
          "id": "obj-273",
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
          "id": "obj-274",
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
          "id": "obj-275",
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
          "id": "obj-276",
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
          "id": "obj-277",
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
          "id": "obj-278",
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
          "id": "obj-279",
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
          "id": "obj-280",
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
          "id": "obj-281",
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
          "id": "obj-282",
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
          "id": "obj-283",
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
          "id": "obj-284",
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
          "id": "obj-285",
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
          "id": "obj-286",
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
          "id": "obj-287",
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
          "id": "obj-288",
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
          "id": "obj-289",
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
          "id": "obj-290",
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
          "id": "obj-291",
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
          "id": "obj-292",
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
          "id": "obj-293",
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
          "id": "obj-294",
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
          "id": "obj-295",
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
          "id": "obj-296",
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
          "id": "obj-297",
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
          "id": "obj-298",
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
          "id": "obj-299",
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
          "id": "obj-300",
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
          "id": "obj-301",
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
          "id": "obj-302",
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
          "id": "obj-303",
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
          "id": "obj-304",
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
          "id": "obj-305",
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
          "id": "obj-306",
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
          "id": "obj-307",
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
          "id": "obj-308",
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
          "id": "obj-309",
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
          "id": "obj-310",
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
          "id": "obj-311",
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
          "id": "obj-312",
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
          "id": "obj-313",
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
          "id": "obj-314",
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
          "id": "obj-315",
          "varname": "mixer_mute_2",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            302,
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
            302,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-316",
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
          "id": "obj-317",
          "varname": "mixer_solo_2",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            302,
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
            302,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-318",
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
          "id": "obj-319",
          "varname": "mixer_pan_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            302,
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
            302,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-320",
          "varname": "mixer_level_2",
          "maxclass": "live.slider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            326,
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
            326,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-321",
          "varname": "mixer_level_value_2",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            328,
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
            328,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-322",
          "varname": "meter_2",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            326,
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
            326,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-323",
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
          "id": "obj-324",
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
          "id": "obj-325",
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
          "id": "obj-326",
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
          "id": "obj-327",
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
          "id": "obj-328",
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
          "id": "obj-329",
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
          "id": "obj-330",
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
          "id": "obj-331",
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
          "id": "obj-332",
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
          "id": "obj-333",
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
          "id": "obj-334",
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
          "id": "obj-335",
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
          "id": "obj-336",
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
          "id": "obj-337",
          "varname": "play_3",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            350,
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
            350,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-338",
          "varname": "wave_3",
          "maxclass": "waveform~",
          "numinlets": 5,
          "numoutlets": 6,
          "patching_rect": [
            256,
            350,
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
            350,
            428,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-339",
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
          "id": "obj-340",
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
          "id": "obj-341",
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
          "id": "obj-342",
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
          "id": "obj-343",
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
          "id": "obj-344",
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
          "id": "obj-345",
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
          "id": "obj-346",
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
          "id": "obj-347",
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
          "id": "obj-348",
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
          "id": "obj-349",
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
          "id": "obj-350",
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
          "id": "obj-351",
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
          "id": "obj-352",
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
          "id": "obj-353",
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
          "id": "obj-354",
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
          "id": "obj-355",
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
          "id": "obj-356",
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
          "id": "obj-357",
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
          "id": "obj-358",
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
          "id": "obj-359",
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
          "id": "obj-360",
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
          "id": "obj-361",
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
          "id": "obj-362",
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
          "id": "obj-363",
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
          "id": "obj-364",
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
          "id": "obj-365",
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
          "id": "obj-366",
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
          "id": "obj-367",
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
          "id": "obj-368",
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
          "id": "obj-369",
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
          "id": "obj-370",
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
          "id": "obj-371",
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
          "id": "obj-372",
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
          "id": "obj-373",
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
          "id": "obj-374",
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
          "id": "obj-375",
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
          "id": "obj-376",
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
          "id": "obj-377",
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
          "id": "obj-378",
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
          "id": "obj-379",
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
          "id": "obj-380",
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
          "id": "obj-381",
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
          "id": "obj-382",
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
          "id": "obj-383",
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
          "id": "obj-384",
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
          "id": "obj-385",
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
          "id": "obj-386",
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
          "id": "obj-387",
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
          "id": "obj-388",
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
          "id": "obj-389",
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
          "id": "obj-390",
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
          "id": "obj-391",
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
          "id": "obj-392",
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
          "id": "obj-393",
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
          "id": "obj-394",
          "varname": "mixer_mute_3",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            350,
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
            350,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-395",
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
          "id": "obj-396",
          "varname": "mixer_solo_3",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            350,
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
            350,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-397",
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
          "id": "obj-398",
          "varname": "mixer_pan_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            350,
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
            350,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-399",
          "varname": "mixer_level_3",
          "maxclass": "live.slider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            374,
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
            374,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-400",
          "varname": "mixer_level_value_3",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            376,
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
            376,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-401",
          "varname": "meter_3",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            374,
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
            374,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-402",
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
          "id": "obj-403",
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
          "id": "obj-404",
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
          "id": "obj-405",
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
          "id": "obj-406",
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
          "id": "obj-407",
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
          "id": "obj-408",
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
          "id": "obj-409",
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
          "id": "obj-410",
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
          "id": "obj-411",
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
          "id": "obj-412",
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
          "id": "obj-413",
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
          "id": "obj-414",
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
          "id": "obj-415",
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
          "id": "obj-416",
          "varname": "play_4",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            398,
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
            398,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-417",
          "varname": "wave_4",
          "maxclass": "waveform~",
          "numinlets": 5,
          "numoutlets": 6,
          "patching_rect": [
            256,
            398,
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
            398,
            428,
            44
          ]
        }
      },
      {
        "box": {
          "id": "obj-418",
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
          "id": "obj-419",
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
          "id": "obj-420",
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
          "id": "obj-421",
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
          "id": "obj-422",
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
          "id": "obj-423",
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
          "id": "obj-424",
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
          "id": "obj-425",
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
          "id": "obj-426",
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
          "id": "obj-427",
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
          "id": "obj-428",
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
          "id": "obj-429",
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
          "id": "obj-430",
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
          "id": "obj-431",
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
          "id": "obj-432",
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
          "id": "obj-433",
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
          "id": "obj-434",
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
          "id": "obj-435",
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
          "id": "obj-436",
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
          "id": "obj-437",
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
          "id": "obj-438",
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
          "id": "obj-439",
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
          "id": "obj-440",
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
          "id": "obj-441",
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
          "id": "obj-442",
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
          "id": "obj-443",
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
          "id": "obj-444",
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
          "id": "obj-445",
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
          "id": "obj-446",
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
          "id": "obj-447",
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
          "id": "obj-448",
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
          "id": "obj-449",
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
          "id": "obj-450",
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
          "id": "obj-451",
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
          "id": "obj-452",
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
          "id": "obj-453",
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
          "id": "obj-454",
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
          "id": "obj-455",
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
          "id": "obj-456",
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
          "id": "obj-457",
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
          "id": "obj-458",
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
          "id": "obj-459",
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
          "id": "obj-460",
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
          "id": "obj-461",
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
          "id": "obj-462",
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
          "id": "obj-463",
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
          "id": "obj-464",
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
          "id": "obj-465",
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
          "id": "obj-466",
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
          "id": "obj-467",
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
          "id": "obj-468",
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
          "id": "obj-469",
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
          "id": "obj-470",
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
          "id": "obj-471",
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
          "id": "obj-472",
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
          "id": "obj-473",
          "varname": "mixer_mute_4",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            398,
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
            398,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-474",
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
          "id": "obj-475",
          "varname": "mixer_solo_4",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            398,
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
            398,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-476",
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
          "id": "obj-477",
          "varname": "mixer_pan_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            398,
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
            398,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-478",
          "varname": "mixer_level_4",
          "maxclass": "live.slider",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            16,
            422,
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
            422,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-479",
          "varname": "mixer_level_value_4",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            160,
            424,
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
            424,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-480",
          "varname": "meter_4",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            208,
            422,
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
            422,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-481",
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
          "id": "obj-482",
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
          "id": "obj-483",
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
          "id": "obj-484",
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
          "id": "obj-485",
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
          "id": "obj-486",
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
          "id": "obj-487",
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
          "id": "obj-488",
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
          "id": "obj-489",
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
          "id": "obj-490",
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
          "id": "obj-491",
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
          "id": "obj-492",
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
          "id": "obj-493",
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
          "id": "obj-494",
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
      },
      {
        "box": {
          "id": "obj-495",
          "varname": "stereo_field_open",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            112,
            230,
            92,
            20
          ],
          "mode": 0,
          "text": "Stereo field…",
          "texton": "Stereo field…",
          "parameter_enable": 0,
          "hint": "Open stereo placement and level for the four loops.",
          "outlettype": [
            "bang",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            230,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-496",
          "varname": "stereo_field_open_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            3040,
            1880,
            52,
            22
          ],
          "text": "open"
        }
      },
      {
        "box": {
          "id": "obj-497",
          "varname": "stereo_field_window",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            3040,
            1910,
            68,
            22
          ],
          "text": "pcontrol"
        }
      },
      {
        "box": {
          "id": "obj-498",
          "varname": "stereo_field_panel",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            3040,
            1940,
            122,
            22
          ],
          "text": "p Stereo field",
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
              570,
              152,
              506,
              298
            ],
            "title": "Stereo field",
            "openinpresentation": 1,
            "boxes": [
              {
                "box": {
                  "id": "obj-1",
                  "varname": "input",
                  "maxclass": "inlet",
                  "numinlets": 0,
                  "numoutlets": 1,
                  "patching_rect": [
                    20,
                    320,
                    30,
                    30
                  ],
                  "index": 1
                }
              },
              {
                "box": {
                  "id": "obj-2",
                  "varname": "output",
                  "maxclass": "outlet",
                  "numinlets": 1,
                  "numoutlets": 0,
                  "patching_rect": [
                    20,
                    365,
                    30,
                    30
                  ],
                  "index": 1
                }
              },
              {
                "box": {
                  "id": "obj-3",
                  "varname": "canvas",
                  "maxclass": "jsui",
                  "numinlets": 1,
                  "numoutlets": 1,
                  "patching_rect": [
                    12,
                    12,
                    480,
                    244
                  ],
                  "filename": "fk_stereo_field.js",
                  "border": 0,
                  "parameter_enable": 0,
                  "outlettype": [
                    ""
                  ],
                  "presentation": 1,
                  "presentation_rect": [
                    12,
                    12,
                    480,
                    244
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-4",
                  "varname": "help",
                  "maxclass": "comment",
                  "numinlets": 1,
                  "numoutlets": 0,
                  "patching_rect": [
                    12,
                    266,
                    480,
                    22
                  ],
                  "fontsize": 12,
                  "text": "Drag left or right to pan, up or down to set level.",
                  "presentation": 1,
                  "presentation_rect": [
                    12,
                    266,
                    480,
                    22
                  ]
                }
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "obj-1",
                    0
                  ],
                  "destination": [
                    "obj-3",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-3",
                    0
                  ],
                  "destination": [
                    "obj-2",
                    0
                  ]
                }
              }
            ]
          },
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-499",
          "varname": "stereo_field_position",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            3040,
            1970,
            110,
            22
          ],
          "text": "route position"
        }
      },
      {
        "box": {
          "id": "obj-500",
          "varname": "stereo_field_voice",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 5,
          "patching_rect": [
            3040,
            2000,
            103,
            22
          ],
          "text": "route 1 2 3 4"
        }
      },
      {
        "box": {
          "id": "obj-501",
          "varname": "stereo_field_init",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            3040,
            2040,
            68,
            22
          ],
          "text": "loadbang",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-502",
          "varname": "stereo_field_edit_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            3040,
            2080,
            82,
            22
          ],
          "text": "unpack f f",
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-503",
          "varname": "stereo_field_state_1",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            3040,
            2110,
            117,
            22
          ],
          "text": "pak 1 -45.0 70.",
          "outlettype": [
            "list"
          ]
        }
      },
      {
        "box": {
          "id": "obj-504",
          "varname": "stereo_field_source_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            3040,
            2140,
            110,
            22
          ],
          "text": "prepend source"
        }
      },
      {
        "box": {
          "id": "obj-505",
          "varname": "stereo_field_edit_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            3190,
            2080,
            82,
            22
          ],
          "text": "unpack f f",
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-506",
          "varname": "stereo_field_state_2",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            3190,
            2110,
            117,
            22
          ],
          "text": "pak 2 -15.0 70.",
          "outlettype": [
            "list"
          ]
        }
      },
      {
        "box": {
          "id": "obj-507",
          "varname": "stereo_field_source_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            3190,
            2140,
            110,
            22
          ],
          "text": "prepend source"
        }
      },
      {
        "box": {
          "id": "obj-508",
          "varname": "stereo_field_edit_3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            3340,
            2080,
            82,
            22
          ],
          "text": "unpack f f",
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-509",
          "varname": "stereo_field_state_3",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            3340,
            2110,
            110,
            22
          ],
          "text": "pak 3 15.0 70.",
          "outlettype": [
            "list"
          ]
        }
      },
      {
        "box": {
          "id": "obj-510",
          "varname": "stereo_field_source_3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            3340,
            2140,
            110,
            22
          ],
          "text": "prepend source"
        }
      },
      {
        "box": {
          "id": "obj-511",
          "varname": "stereo_field_edit_4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            3490,
            2080,
            82,
            22
          ],
          "text": "unpack f f",
          "outlettype": [
            "float",
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-512",
          "varname": "stereo_field_state_4",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            3490,
            2110,
            110,
            22
          ],
          "text": "pak 4 45.0 70.",
          "outlettype": [
            "list"
          ]
        }
      },
      {
        "box": {
          "id": "obj-513",
          "varname": "stereo_field_source_4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            3490,
            2140,
            110,
            22
          ],
          "text": "prepend source"
        }
      },
      {
        "box": {
          "id": "obj-514",
          "varname": "input_panel",
          "maxclass": "panel",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            16,
            80,
            1052,
            74
          ],
          "background": 1,
          "ignoreclick": 1,
          "border": 0,
          "rounded": 6,
          "bgcolor": [
            0.175,
            0.175,
            0.18,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            16,
            80,
            1052,
            74
          ]
        }
      },
      {
        "box": {
          "id": "obj-515",
          "varname": "input_heading",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            28,
            88,
            248,
            22
          ],
          "text": "Input recording",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            28,
            88,
            248,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-516",
          "varname": "input_gain_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            312,
            91,
            104,
            22
          ],
          "text": "Input gain",
          "presentation": 1,
          "presentation_rect": [
            312,
            91,
            104,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-517",
          "varname": "input_level_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            456,
            91,
            230,
            22
          ],
          "text": "Input level · after gain",
          "presentation": 1,
          "presentation_rect": [
            456,
            91,
            230,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-518",
          "varname": "input_record_state",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            736,
            90,
            145,
            20
          ],
          "text": "Enable audio to record",
          "fontface": 1,
          "textcolor": [
            0.96,
            0.96,
            0.97,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            736,
            90,
            145,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-519",
          "varname": "input_record_time",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            946,
            90,
            74,
            20
          ],
          "text": "00:00.0",
          "fontface": 1,
          "textjustification": 2,
          "hint": "Elapsed audio captured in the current or last input take.",
          "presentation": 1,
          "presentation_rect": [
            946,
            90,
            74,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-520",
          "varname": "input_divider_0",
          "maxclass": "panel",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            292,
            90,
            1,
            54
          ],
          "background": 1,
          "ignoreclick": 1,
          "border": 0,
          "rounded": 0,
          "bgcolor": [
            0.29,
            0.29,
            0.3,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            292,
            90,
            1,
            54
          ]
        }
      },
      {
        "box": {
          "id": "obj-521",
          "varname": "input_divider_1",
          "maxclass": "panel",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            716,
            90,
            1,
            54
          ],
          "background": 1,
          "ignoreclick": 1,
          "border": 0,
          "rounded": 0,
          "bgcolor": [
            0.29,
            0.29,
            0.3,
            1.0
          ],
          "presentation": 1,
          "presentation_rect": [
            716,
            90,
            1,
            54
          ]
        }
      },
      {
        "box": {
          "id": "obj-522",
          "varname": "input_record_button",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            736,
            113,
            140,
            32
          ],
          "mode": 0,
          "text": "Record input",
          "texton": "Record input",
          "parameter_enable": 0,
          "hint": "Record the selected inputs as a new source for all four loops.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            736,
            113,
            140,
            32
          ],
          "active": 0
        }
      },
      {
        "box": {
          "id": "obj-523",
          "varname": "input_record_button_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1674,
            2230,
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
          "id": "obj-524",
          "varname": "input_record_button_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1674,
            2268,
            140,
            22
          ],
          "text": "toggle_input_record"
        }
      },
      {
        "box": {
          "id": "obj-525",
          "varname": "input_save_button",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            880,
            113,
            140,
            32
          ],
          "mode": 0,
          "text": "Save input WAV…",
          "texton": "Save input WAV…",
          "parameter_enable": 0,
          "hint": "Save the current input take so a Set can reopen it.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            880,
            113,
            140,
            32
          ],
          "active": 0
        }
      },
      {
        "box": {
          "id": "obj-526",
          "varname": "input_save_button_click",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2004,
            2230,
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
          "id": "obj-527",
          "varname": "input_save_button_message",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2004,
            2268,
            140,
            22
          ],
          "text": "choose_input_save"
        }
      },
      {
        "box": {
          "id": "obj-528",
          "varname": "input_left_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            28,
            118,
            48,
            20
          ],
          "text": "Input L",
          "presentation": 1,
          "presentation_rect": [
            28,
            118,
            48,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-529",
          "varname": "input_left",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            80,
            117,
            64,
            22
          ],
          "items": [
            "—"
          ],
          "allowdrag": 0,
          "parameter_enable": 0,
          "hint": "Select the left channel from your Audio Setup device. Choose the same input on both sides for mono.",
          "outlettype": [
            "int",
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            80,
            117,
            64,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-530",
          "varname": "input_left_message",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            530,
            2230,
            201,
            22
          ],
          "text": "prepend set_input_channel 1"
        }
      },
      {
        "box": {
          "id": "obj-531",
          "varname": "input_right_label",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            158,
            118,
            48,
            20
          ],
          "text": "Input R",
          "presentation": 1,
          "presentation_rect": [
            158,
            118,
            48,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-532",
          "varname": "input_right",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            210,
            117,
            64,
            22
          ],
          "items": [
            "—"
          ],
          "allowdrag": 0,
          "parameter_enable": 0,
          "hint": "Select the right channel from your Audio Setup device. Choose the same input on both sides for mono.",
          "outlettype": [
            "int",
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            210,
            117,
            64,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-533",
          "varname": "input_right_message",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            810,
            2230,
            201,
            22
          ],
          "text": "prepend set_input_channel 2"
        }
      },
      {
        "box": {
          "id": "obj-534",
          "varname": "input_gain",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            312,
            116,
            104,
            24
          ],
          "hint": "Adjust both inputs before metering and recording. 0 dB leaves their level unchanged.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Input gain",
              "parameter_shortname": "Input gain",
              "parameter_type": 0,
              "parameter_mmin": -60,
              "parameter_mmax": 18,
              "parameter_initial": [
                0
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
            312,
            116,
            104,
            24
          ]
        }
      },
      {
        "box": {
          "id": "obj-535",
          "varname": "input_gain_ramp",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2750,
            691,
            82,
            22
          ],
          "text": "pack 0. 20"
        }
      },
      {
        "box": {
          "id": "obj-536",
          "varname": "input_gain_base",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2750,
            723,
            68,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-537",
          "varname": "input_gain_mod",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2855,
            723,
            54,
            22
          ],
          "text": "*~ 24.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-538",
          "varname": "input_gain_sum",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2750,
            755,
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
          "id": "obj-539",
          "varname": "input_gain_effective",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2750,
            787,
            110,
            22
          ],
          "text": "clip~ -60. 18.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-540",
          "varname": "input_gain_signal",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2750,
            819,
            54,
            22
          ],
          "text": "dbtoa~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-541",
          "varname": "input_adc",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2260,
            736,
            68,
            22
          ],
          "text": "adc~ 1 2",
          "outlettype": [
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-542",
          "varname": "input_recorder",
          "maxclass": "newobj",
          "numinlets": 4,
          "numoutlets": 1,
          "patching_rect": [
            2260,
            832,
            180,
            22
          ],
          "text": "record~ fk-unbound-set 2",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-543",
          "varname": "input_progress",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2260,
            864,
            82,
            22
          ],
          "text": "peakamp~ 0",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-544",
          "varname": "input_progress_message",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2260,
            896,
            215,
            22
          ],
          "text": "prepend input_record_progress"
        }
      },
      {
        "box": {
          "id": "obj-545",
          "varname": "input_meter_label_L",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            456,
            112,
            20,
            18
          ],
          "text": "L",
          "fontsize": 11,
          "presentation": 1,
          "presentation_rect": [
            456,
            112,
            20,
            18
          ]
        }
      },
      {
        "box": {
          "id": "obj-546",
          "varname": "input_meter_L",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            478,
            114,
            216,
            12
          ],
          "orientation": 1,
          "clip_size": 1,
          "hint": "L input peak after gain. Red indicates overload.",
          "outlettype": [
            "float",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            478,
            114,
            216,
            12
          ]
        }
      },
      {
        "box": {
          "id": "obj-547",
          "varname": "input_trim_L",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2260,
            784,
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
          "id": "obj-548",
          "varname": "input_meter_label_R",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            456,
            129,
            20,
            18
          ],
          "text": "R",
          "fontsize": 11,
          "presentation": 1,
          "presentation_rect": [
            456,
            129,
            20,
            18
          ]
        }
      },
      {
        "box": {
          "id": "obj-549",
          "varname": "input_meter_R",
          "maxclass": "live.meter~",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            478,
            131,
            216,
            12
          ],
          "orientation": 1,
          "clip_size": 1,
          "hint": "R input peak after gain. Red indicates overload.",
          "outlettype": [
            "float",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            478,
            131,
            216,
            12
          ]
        }
      },
      {
        "box": {
          "id": "obj-550",
          "varname": "input_trim_R",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2348,
            784,
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
          "id": "obj-551",
          "varname": "input_clock",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2470,
            864,
            173,
            22
          ],
          "text": "snapshot~ 100 @active 0",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-552",
          "varname": "input_clock_message",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2470,
            896,
            201,
            22
          ],
          "text": "prepend input_elapsed_phase"
        }
      },
      {
        "box": {
          "id": "obj-553",
          "varname": "input_rate_message",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1130,
            884,
            187,
            22
          ],
          "text": "prepend input_sample_rate"
        }
      },
      {
        "box": {
          "id": "obj-554",
          "varname": "input_device_channels",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1150,
            2230,
            138,
            22
          ],
          "text": "adstatus numinputs",
          "outlettype": [
            "int",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-555",
          "varname": "input_count_message",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1325,
            2230,
            201,
            22
          ],
          "text": "prepend input_channel_count"
        }
      },
      {
        "box": {
          "id": "obj-556",
          "varname": "input_save_dialog",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            2540,
            812,
            117,
            22
          ],
          "text": "savedialog WAVE",
          "outlettype": [
            "",
            "",
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-557",
          "varname": "input_save_path",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2540,
            850,
            173,
            22
          ],
          "text": "prepend save_input_path"
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
            1
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
            "obj-15",
            0
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
            "obj-6",
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
            "obj-31",
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
            "obj-32",
            0
          ],
          "destination": [
            "obj-33",
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
            "obj-6",
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
            "obj-39",
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
            "obj-42",
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
            "obj-37",
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
            "obj-37",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-44",
            1
          ],
          "destination": [
            "obj-45",
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
            1
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
            "obj-37",
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
            "obj-44",
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
            "obj-44",
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
            "obj-44",
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
            "obj-44",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-60",
            0
          ],
          "destination": [
            "obj-61",
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
            "obj-44",
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
            "obj-65",
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
            "obj-44",
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
            "obj-67",
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
            "obj-44",
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
            "obj-44",
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
            "obj-73",
            0
          ],
          "destination": [
            "obj-74",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-74",
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
            "obj-77",
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
            "obj-78",
            1
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
            "obj-79",
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
            "obj-78",
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
            "obj-37",
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
            "obj-84",
            0
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
            "obj-37",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-85",
            0
          ],
          "destination": [
            "obj-86",
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
            "obj-37",
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
            "obj-88",
            0
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
            "obj-37",
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
            "obj-89",
            0
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
            "obj-37",
            0
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
            "obj-37",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-80",
            1
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
            "obj-37",
            0
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
            "obj-94",
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
            "obj-95",
            1
          ],
          "destination": [
            "obj-97",
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
            "obj-37",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-97",
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
            "obj-98",
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
            "obj-101",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-101",
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
            "obj-102",
            0
          ],
          "destination": [
            "obj-103",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-106",
            0
          ],
          "destination": [
            "obj-107",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-107",
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
            "obj-110",
            0
          ],
          "destination": [
            "obj-109",
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
            "obj-111",
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
            "obj-114",
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
            1
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
            "obj-115",
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
            "obj-119",
            2
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
            "obj-119",
            0
          ],
          "destination": [
            "obj-121",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-119",
            1
          ],
          "destination": [
            "obj-121",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-122",
            1
          ],
          "destination": [
            "obj-123",
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
            "obj-124",
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
            "obj-124",
            1
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
            "obj-125",
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
            "obj-125",
            1
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
            "obj-126",
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
            1
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
            "obj-127",
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
            "obj-127",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-127",
            0
          ],
          "destination": [
            "obj-128",
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
            "obj-128",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-128",
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
            "obj-108",
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
            "obj-118",
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
            "obj-130",
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
            "obj-110",
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
            "obj-131",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            1
          ],
          "destination": [
            "obj-131",
            1
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
            "obj-132",
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
            "obj-132",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            1
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
            0
          ],
          "destination": [
            "obj-133",
            1
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
            "obj-134",
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
            "obj-134",
            1
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
            "obj-38",
            0
          ],
          "destination": [
            "obj-135",
            1
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
            "obj-108",
            1
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
            "obj-118",
            1
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
            "obj-110",
            1
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
            "obj-139",
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
            "obj-141",
            0
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
            "obj-139",
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
            0
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
            "obj-6",
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
            "obj-151",
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
            "obj-6",
            0
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
            "obj-6",
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
            "obj-155",
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
            "obj-6",
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
            "obj-157",
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
            "obj-6",
            0
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
            "obj-6",
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
            "obj-161",
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
            "obj-6",
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
            "obj-163",
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
            "obj-6",
            0
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
            "obj-167",
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
            "obj-171",
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
            "obj-172",
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
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-173",
            1
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
            "obj-177",
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
            "obj-173",
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
            "obj-178",
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
            "obj-173",
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
            "obj-180",
            2
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
            "obj-181",
            9
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
            "obj-181",
            10
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
            "obj-181",
            11
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
            "obj-181",
            12
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
            "obj-187",
            0
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
            1
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
            "obj-181",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            3
          ],
          "destination": [
            "obj-175",
            1
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            1
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
            "obj-193",
            0
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
            1
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
            "obj-181",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            4
          ],
          "destination": [
            "obj-175",
            2
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
            "obj-195",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            2
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
            "obj-197",
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
            "obj-198",
            0
          ],
          "destination": [
            "obj-199",
            1
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
            "obj-200",
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
            "obj-181",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            5
          ],
          "destination": [
            "obj-175",
            3
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
            "obj-197",
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
            "obj-201",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            3
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
            "obj-203",
            0
          ],
          "destination": [
            "obj-205",
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
            "obj-205",
            1
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
            "obj-181",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            6
          ],
          "destination": [
            "obj-175",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-202",
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
            "obj-202",
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
            "obj-206",
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
            "obj-174",
            4
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
            "obj-208",
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
            "obj-209",
            0
          ],
          "destination": [
            "obj-210",
            1
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
            "obj-181",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            7
          ],
          "destination": [
            "obj-175",
            5
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
            "obj-207",
            0
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
            "obj-174",
            5
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
            "obj-213",
            0
          ],
          "destination": [
            "obj-215",
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
            "obj-181",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            8
          ],
          "destination": [
            "obj-175",
            6
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
            "obj-213",
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
            "obj-217",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            6
          ],
          "destination": [
            "obj-220",
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
            "obj-221",
            0
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
            "obj-221",
            1
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
            "obj-222",
            0
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
            "obj-181",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            9
          ],
          "destination": [
            "obj-175",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-218",
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
            "obj-218",
            0
          ],
          "destination": [
            "obj-223",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            7
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
            "obj-225",
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
            "obj-226",
            0
          ],
          "destination": [
            "obj-227",
            1
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
            "obj-228",
            0
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
            "obj-181",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            10
          ],
          "destination": [
            "obj-175",
            8
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
            "obj-229",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            8
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
            "obj-231",
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
            "obj-232",
            0
          ],
          "destination": [
            "obj-233",
            1
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
            "obj-234",
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
            "obj-181",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            11
          ],
          "destination": [
            "obj-175",
            9
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
            "obj-235",
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
            "obj-6",
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
            0
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
            "obj-139",
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
            "obj-139",
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
            "obj-224",
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
            "obj-224",
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
            "obj-230",
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
            "obj-245",
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
            "obj-240",
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
            "obj-242",
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
            "obj-243",
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
            "obj-248",
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
            "obj-117",
            0
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
            "obj-247",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            1
          ],
          "destination": [
            "obj-250",
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
            "obj-250",
            1
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
            "obj-117",
            1
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
            "obj-251",
            0
          ],
          "destination": [
            "obj-247",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-180",
            5
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
            "obj-252",
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
            "obj-180",
            4
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
            "obj-253",
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
            "obj-179",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-181",
            2
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
            "obj-256",
            1
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
            "obj-257",
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
            "obj-6",
            1
          ],
          "destination": [
            "obj-259",
            2
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
            "obj-260",
            9
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
            "obj-260",
            10
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
            "obj-260",
            11
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
            "obj-260",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            9
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
            "obj-266",
            0
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
            1
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
            "obj-260",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            3
          ],
          "destination": [
            "obj-175",
            10
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            10
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
            "obj-272",
            0
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
            1
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
            "obj-260",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            4
          ],
          "destination": [
            "obj-175",
            11
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
            "obj-274",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            11
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
            "obj-276",
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
            "obj-277",
            0
          ],
          "destination": [
            "obj-278",
            1
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
            "obj-279",
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
            "obj-260",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            5
          ],
          "destination": [
            "obj-175",
            12
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
            "obj-276",
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
            "obj-280",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            12
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
            "obj-282",
            0
          ],
          "destination": [
            "obj-284",
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
            "obj-284",
            1
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
            "obj-260",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            6
          ],
          "destination": [
            "obj-175",
            13
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-281",
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
            "obj-281",
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
            "obj-285",
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
            "obj-174",
            13
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
            "obj-287",
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
            "obj-288",
            0
          ],
          "destination": [
            "obj-289",
            1
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
            "obj-260",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            7
          ],
          "destination": [
            "obj-175",
            14
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
            "obj-286",
            0
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
            "obj-174",
            14
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
            "obj-292",
            0
          ],
          "destination": [
            "obj-294",
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
            "obj-260",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            8
          ],
          "destination": [
            "obj-175",
            15
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
            "obj-292",
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
            "obj-296",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            15
          ],
          "destination": [
            "obj-299",
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
            "obj-300",
            0
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
            "obj-300",
            1
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
            "obj-301",
            0
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
            "obj-260",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            9
          ],
          "destination": [
            "obj-175",
            16
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-297",
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
            "obj-297",
            0
          ],
          "destination": [
            "obj-302",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            16
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
            "obj-304",
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
            "obj-305",
            0
          ],
          "destination": [
            "obj-306",
            1
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
            "obj-307",
            0
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
            "obj-260",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            10
          ],
          "destination": [
            "obj-175",
            17
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
            "obj-308",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            17
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
            "obj-310",
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
            "obj-311",
            0
          ],
          "destination": [
            "obj-312",
            1
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
            "obj-313",
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
            "obj-260",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            11
          ],
          "destination": [
            "obj-175",
            18
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
            "obj-314",
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
            "obj-6",
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
            0
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
            "obj-139",
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
            "obj-139",
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
            "obj-303",
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
            "obj-303",
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
            "obj-309",
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
            "obj-324",
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
            "obj-319",
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
            "obj-321",
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
            "obj-322",
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
            "obj-327",
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
            "obj-117",
            0
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
            "obj-326",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            1
          ],
          "destination": [
            "obj-329",
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
            "obj-329",
            1
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
            "obj-117",
            1
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
            "obj-330",
            0
          ],
          "destination": [
            "obj-326",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-259",
            5
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
            "obj-331",
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
            "obj-259",
            4
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
            "obj-332",
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
            "obj-258",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-260",
            2
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
            "obj-335",
            1
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
            "obj-336",
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
            "obj-6",
            2
          ],
          "destination": [
            "obj-338",
            2
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
            "obj-339",
            9
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
            "obj-339",
            10
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
            "obj-339",
            11
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
            "obj-339",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            18
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
            "obj-345",
            0
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
            1
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
            "obj-339",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            3
          ],
          "destination": [
            "obj-175",
            19
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            19
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
            "obj-351",
            0
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
            1
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
            "obj-339",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            4
          ],
          "destination": [
            "obj-175",
            20
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
            "obj-353",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            20
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
            "obj-355",
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
            "obj-356",
            0
          ],
          "destination": [
            "obj-357",
            1
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
            "obj-358",
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
            "obj-339",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            5
          ],
          "destination": [
            "obj-175",
            21
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
            "obj-355",
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
            "obj-359",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            21
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
            "obj-361",
            0
          ],
          "destination": [
            "obj-363",
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
            "obj-363",
            1
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
            "obj-339",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            6
          ],
          "destination": [
            "obj-175",
            22
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-360",
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
            "obj-360",
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
            "obj-364",
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
            "obj-174",
            22
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
            "obj-366",
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
            "obj-367",
            0
          ],
          "destination": [
            "obj-368",
            1
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
            "obj-339",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            7
          ],
          "destination": [
            "obj-175",
            23
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
            "obj-365",
            0
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
            "obj-174",
            23
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
            "obj-371",
            0
          ],
          "destination": [
            "obj-373",
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
            "obj-339",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            8
          ],
          "destination": [
            "obj-175",
            24
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
            "obj-371",
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
            "obj-375",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            24
          ],
          "destination": [
            "obj-378",
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
            "obj-379",
            0
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
            "obj-379",
            1
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
            "obj-380",
            0
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
            "obj-339",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            9
          ],
          "destination": [
            "obj-175",
            25
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-376",
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
            "obj-376",
            0
          ],
          "destination": [
            "obj-381",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            25
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
            "obj-383",
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
            "obj-384",
            0
          ],
          "destination": [
            "obj-385",
            1
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
            "obj-386",
            0
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
            "obj-339",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            10
          ],
          "destination": [
            "obj-175",
            26
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
            "obj-387",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            26
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
            "obj-389",
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
            "obj-390",
            0
          ],
          "destination": [
            "obj-391",
            1
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
            "obj-392",
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
            "obj-339",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            11
          ],
          "destination": [
            "obj-175",
            27
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
            "obj-393",
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
            "obj-6",
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
            0
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
            "obj-139",
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
            "obj-139",
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
            "obj-382",
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
            "obj-382",
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
            "obj-388",
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
            "obj-403",
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
            "obj-398",
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
            "obj-400",
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
            "obj-401",
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
            "obj-406",
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
            "obj-117",
            0
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
            "obj-405",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            1
          ],
          "destination": [
            "obj-408",
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
            "obj-408",
            1
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
            "obj-117",
            1
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
            "obj-409",
            0
          ],
          "destination": [
            "obj-405",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-338",
            5
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
            "obj-410",
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
            "obj-338",
            4
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
            "obj-411",
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
            "obj-337",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-339",
            2
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
            "obj-414",
            1
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
            "obj-415",
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
            "obj-6",
            3
          ],
          "destination": [
            "obj-417",
            2
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
            "obj-418",
            9
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
            "obj-418",
            10
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
            "obj-418",
            11
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
            "obj-418",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            27
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
            "obj-424",
            0
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
            1
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
            "obj-418",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            3
          ],
          "destination": [
            "obj-175",
            28
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            28
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
            "obj-430",
            0
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
            1
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
            "obj-418",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            4
          ],
          "destination": [
            "obj-175",
            29
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
            "obj-432",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            29
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
            "obj-434",
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
            "obj-435",
            0
          ],
          "destination": [
            "obj-436",
            1
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
            "obj-437",
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
            "obj-418",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            5
          ],
          "destination": [
            "obj-175",
            30
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
            "obj-434",
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
            "obj-438",
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
            "obj-6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            30
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
            "obj-440",
            0
          ],
          "destination": [
            "obj-442",
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
            "obj-442",
            1
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
            "obj-418",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            6
          ],
          "destination": [
            "obj-175",
            31
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-439",
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
            "obj-439",
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
            "obj-443",
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
            "obj-174",
            31
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
            "obj-445",
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
            "obj-446",
            0
          ],
          "destination": [
            "obj-447",
            1
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
            "obj-418",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            7
          ],
          "destination": [
            "obj-175",
            32
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
            "obj-444",
            0
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
            "obj-174",
            32
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
            "obj-450",
            0
          ],
          "destination": [
            "obj-452",
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
            "obj-418",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            8
          ],
          "destination": [
            "obj-175",
            33
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
            "obj-450",
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
            "obj-454",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-454",
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
            "obj-174",
            33
          ],
          "destination": [
            "obj-457",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-456",
            0
          ],
          "destination": [
            "obj-458",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-457",
            0
          ],
          "destination": [
            "obj-458",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-458",
            0
          ],
          "destination": [
            "obj-459",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-459",
            0
          ],
          "destination": [
            "obj-418",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            9
          ],
          "destination": [
            "obj-175",
            34
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-455",
            0
          ],
          "destination": [
            "obj-456",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-455",
            0
          ],
          "destination": [
            "obj-460",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-460",
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
            "obj-174",
            34
          ],
          "destination": [
            "obj-463",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-462",
            0
          ],
          "destination": [
            "obj-464",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-463",
            0
          ],
          "destination": [
            "obj-464",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-464",
            0
          ],
          "destination": [
            "obj-465",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-465",
            0
          ],
          "destination": [
            "obj-418",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            10
          ],
          "destination": [
            "obj-175",
            35
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-461",
            0
          ],
          "destination": [
            "obj-462",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-461",
            0
          ],
          "destination": [
            "obj-466",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-466",
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
            "obj-174",
            35
          ],
          "destination": [
            "obj-469",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-468",
            0
          ],
          "destination": [
            "obj-470",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-469",
            0
          ],
          "destination": [
            "obj-470",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-470",
            0
          ],
          "destination": [
            "obj-471",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-471",
            0
          ],
          "destination": [
            "obj-418",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            11
          ],
          "destination": [
            "obj-175",
            36
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-467",
            0
          ],
          "destination": [
            "obj-468",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-467",
            0
          ],
          "destination": [
            "obj-472",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-472",
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
            "obj-473",
            0
          ],
          "destination": [
            "obj-474",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-474",
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
            "obj-475",
            0
          ],
          "destination": [
            "obj-476",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-476",
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
            "obj-479",
            0
          ],
          "destination": [
            "obj-461",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-478",
            0
          ],
          "destination": [
            "obj-461",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-461",
            0
          ],
          "destination": [
            "obj-481",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-481",
            0
          ],
          "destination": [
            "obj-478",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-477",
            0
          ],
          "destination": [
            "obj-467",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-467",
            0
          ],
          "destination": [
            "obj-482",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-482",
            0
          ],
          "destination": [
            "obj-477",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-481",
            0
          ],
          "destination": [
            "obj-479",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-484",
            0
          ],
          "destination": [
            "obj-480",
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
            "obj-485",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-483",
            0
          ],
          "destination": [
            "obj-485",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-485",
            0
          ],
          "destination": [
            "obj-117",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-485",
            0
          ],
          "destination": [
            "obj-486",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-486",
            0
          ],
          "destination": [
            "obj-484",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-418",
            1
          ],
          "destination": [
            "obj-487",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-483",
            0
          ],
          "destination": [
            "obj-487",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-487",
            0
          ],
          "destination": [
            "obj-117",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-487",
            0
          ],
          "destination": [
            "obj-488",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-488",
            0
          ],
          "destination": [
            "obj-484",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-417",
            5
          ],
          "destination": [
            "obj-489",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-489",
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
            "obj-417",
            4
          ],
          "destination": [
            "obj-490",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-490",
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
            "obj-416",
            0
          ],
          "destination": [
            "obj-491",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-491",
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
            "obj-418",
            2
          ],
          "destination": [
            "obj-492",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-492",
            0
          ],
          "destination": [
            "obj-493",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-493",
            0
          ],
          "destination": [
            "obj-494",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-494",
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
            "obj-495",
            0
          ],
          "destination": [
            "obj-496",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-496",
            0
          ],
          "destination": [
            "obj-497",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-497",
            0
          ],
          "destination": [
            "obj-498",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-498",
            0
          ],
          "destination": [
            "obj-499",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-499",
            0
          ],
          "destination": [
            "obj-500",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-500",
            0
          ],
          "destination": [
            "obj-502",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-502",
            0
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
            "obj-230",
            0
          ],
          "destination": [
            "obj-503",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-502",
            1
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
            "obj-224",
            0
          ],
          "destination": [
            "obj-503",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-501",
            0
          ],
          "destination": [
            "obj-503",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-503",
            0
          ],
          "destination": [
            "obj-504",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-504",
            0
          ],
          "destination": [
            "obj-498",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-500",
            1
          ],
          "destination": [
            "obj-505",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-505",
            0
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
            "obj-309",
            0
          ],
          "destination": [
            "obj-506",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-505",
            1
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
            "obj-303",
            0
          ],
          "destination": [
            "obj-506",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-501",
            0
          ],
          "destination": [
            "obj-506",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-506",
            0
          ],
          "destination": [
            "obj-507",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-507",
            0
          ],
          "destination": [
            "obj-498",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-500",
            2
          ],
          "destination": [
            "obj-508",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-508",
            0
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
            "obj-388",
            0
          ],
          "destination": [
            "obj-509",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-508",
            1
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
            "obj-382",
            0
          ],
          "destination": [
            "obj-509",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-501",
            0
          ],
          "destination": [
            "obj-509",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-509",
            0
          ],
          "destination": [
            "obj-510",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-510",
            0
          ],
          "destination": [
            "obj-498",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-500",
            3
          ],
          "destination": [
            "obj-511",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-511",
            0
          ],
          "destination": [
            "obj-467",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-467",
            0
          ],
          "destination": [
            "obj-512",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-511",
            1
          ],
          "destination": [
            "obj-461",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-461",
            0
          ],
          "destination": [
            "obj-512",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-501",
            0
          ],
          "destination": [
            "obj-512",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-512",
            0
          ],
          "destination": [
            "obj-513",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-513",
            0
          ],
          "destination": [
            "obj-498",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-522",
            0
          ],
          "destination": [
            "obj-523",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-523",
            0
          ],
          "destination": [
            "obj-524",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-524",
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
            "obj-525",
            0
          ],
          "destination": [
            "obj-526",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-526",
            0
          ],
          "destination": [
            "obj-527",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-527",
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
            "obj-529",
            0
          ],
          "destination": [
            "obj-530",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-530",
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
            "obj-532",
            0
          ],
          "destination": [
            "obj-533",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-533",
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
            "obj-534",
            0
          ],
          "destination": [
            "obj-535",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-535",
            0
          ],
          "destination": [
            "obj-536",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-536",
            0
          ],
          "destination": [
            "obj-538",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-537",
            0
          ],
          "destination": [
            "obj-538",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-538",
            0
          ],
          "destination": [
            "obj-539",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-539",
            0
          ],
          "destination": [
            "obj-540",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-541",
            0
          ],
          "destination": [
            "obj-547",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-540",
            0
          ],
          "destination": [
            "obj-547",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-547",
            0
          ],
          "destination": [
            "obj-546",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-547",
            0
          ],
          "destination": [
            "obj-542",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-541",
            1
          ],
          "destination": [
            "obj-550",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-540",
            0
          ],
          "destination": [
            "obj-550",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-550",
            0
          ],
          "destination": [
            "obj-549",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-550",
            0
          ],
          "destination": [
            "obj-542",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-542",
            0
          ],
          "destination": [
            "obj-543",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-543",
            0
          ],
          "destination": [
            "obj-544",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-544",
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
            "obj-542",
            0
          ],
          "destination": [
            "obj-551",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-551",
            0
          ],
          "destination": [
            "obj-552",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-552",
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
            "obj-16",
            1
          ],
          "destination": [
            "obj-553",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-553",
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
            "obj-554",
            1
          ],
          "destination": [
            "obj-555",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-555",
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
            "obj-556",
            0
          ],
          "destination": [
            "obj-557",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-557",
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
            "obj-174",
            36
          ],
          "destination": [
            "obj-113",
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
            "obj-175",
            37
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            37
          ],
          "destination": [
            "obj-537",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-539",
            0
          ],
          "destination": [
            "obj-175",
            38
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            38
          ],
          "destination": [
            "obj-117",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            2
          ],
          "destination": [
            "obj-175",
            39
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            39
          ],
          "destination": [
            "obj-117",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            3
          ],
          "destination": [
            "obj-175",
            40
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            40
          ],
          "destination": [
            "obj-117",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            4
          ],
          "destination": [
            "obj-175",
            41
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            41
          ],
          "destination": [
            "obj-117",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            5
          ],
          "destination": [
            "obj-175",
            42
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            42
          ],
          "destination": [
            "obj-117",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            6
          ],
          "destination": [
            "obj-175",
            43
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-174",
            43
          ],
          "destination": [
            "obj-117",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-117",
            7
          ],
          "destination": [
            "obj-175",
            44
          ]
        }
      }
    ]
  }
}
