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
      100,
      100,
      1052,
      212
    ],
    "openinpresentation": 1,
    "description": "LFO route selection, live feedback and breakpoint editing",
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            50,
            318,
            142,
            22
          ],
          "text": "js fk_mod_routes.js",
          "outlettype": [
            "list",
            "int"
          ],
          "varname": "fk_router"
        }
      },
      {
        "box": {
          "id": "obj-2",
          "maxclass": "inlet",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            0,
            272,
            30,
            30
          ],
          "outlettype": [
            ""
          ],
          "index": 1,
          "comment": "Routing controls and live destination feedback"
        }
      },
      {
        "box": {
          "id": "obj-3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            206,
            318,
            60,
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
          "id": "obj-4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            274,
            318,
            65,
            22
          ],
          "text": "deferlow",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-5",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            0,
            0,
            332,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            332,
            20
          ],
          "text": "Modulation patchbay",
          "fontsize": 16,
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "obj-6",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            336,
            0,
            92,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            336,
            0,
            92,
            20
          ],
          "text": "Route",
          "fontsize": 16,
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "obj-7",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            432,
            4,
            236,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            432,
            4,
            236,
            20
          ],
          "text": "LFO 1 \u2192 W1 Start  /  Off",
          "varname": "fk_mod_status"
        }
      },
      {
        "box": {
          "id": "obj-8",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            672,
            0,
            380,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            672,
            0,
            380,
            20
          ],
          "text": "Feedback",
          "fontsize": 16,
          "fontface": 1
        }
      },
      {
        "box": {
          "id": "obj-9",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            0,
            24,
            140,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            24,
            140,
            20
          ],
          "text": "LFO"
        }
      },
      {
        "box": {
          "id": "obj-10",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            144,
            24,
            140,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            144,
            24,
            140,
            20
          ],
          "text": "Shape"
        }
      },
      {
        "box": {
          "id": "obj-11",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            288,
            24,
            44,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            288,
            24,
            44,
            20
          ],
          "text": "Rate"
        }
      },
      {
        "box": {
          "id": "obj-12",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            336,
            24,
            92,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            336,
            24,
            92,
            20
          ],
          "text": "Scope"
        }
      },
      {
        "box": {
          "id": "obj-13",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            432,
            24,
            140,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            432,
            24,
            140,
            20
          ],
          "text": "Destination"
        }
      },
      {
        "box": {
          "id": "obj-14",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            576,
            24,
            92,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            576,
            24,
            92,
            20
          ],
          "text": "Depth (%)"
        }
      },
      {
        "box": {
          "id": "obj-15",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            0,
            48,
            140,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            48,
            140,
            20
          ],
          "outlettype": [
            "int",
            "",
            ""
          ],
          "varname": "fk_mod_lfo",
          "items": [
            "LFO 1",
            ",",
            "LFO 2",
            ",",
            "LFO 3",
            ",",
            "LFO 4",
            ",",
            "LFO 5",
            ",",
            "LFO 6",
            ",",
            "LFO 7",
            ",",
            "LFO 8"
          ],
          "hint": "Choose which LFO to edit. All eight run independently."
        }
      },
      {
        "box": {
          "id": "obj-16",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            336,
            48,
            92,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            336,
            48,
            92,
            20
          ],
          "outlettype": [
            "int",
            "",
            ""
          ],
          "varname": "fk_mod_window",
          "items": [
            "Window 1",
            ",",
            "Window 2",
            ",",
            "Window 3",
            ",",
            "Window 4",
            ",",
            "Global"
          ],
          "hint": "Choose a loop window or route to Main FX, Drifting Memory, master or input gain."
        }
      },
      {
        "box": {
          "id": "obj-17",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            432,
            48,
            140,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            432,
            48,
            140,
            20
          ],
          "outlettype": [
            "int",
            "",
            ""
          ],
          "varname": "fk_mod_target",
          "items": [
            "Start",
            ",",
            "End",
            ",",
            "Speed",
            ",",
            "Direction",
            ",",
            "Crossfade",
            ",",
            "Drive",
            ",",
            "Filter",
            ",",
            "Level",
            ",",
            "Pan",
            ",",
            "Echo send",
            ",",
            "Room send"
          ]
        }
      },
      {
        "box": {
          "id": "obj-18",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            576,
            48,
            92,
            44
          ],
          "presentation": 1,
          "presentation_rect": [
            576,
            48,
            92,
            44
          ],
          "outlettype": [
            "float",
            "float"
          ],
          "appearance": 3,
          "showname": 0,
          "shownumber": 1,
          "varname": "fk_mod_depth",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Route depth",
              "parameter_shortname": "Route depth",
              "parameter_type": 1,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-19",
          "maxclass": "live.dial",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            288,
            48,
            44,
            44
          ],
          "presentation": 1,
          "presentation_rect": [
            288,
            48,
            44,
            44
          ],
          "outlettype": [
            "float",
            "float"
          ],
          "appearance": 3,
          "showname": 0,
          "shownumber": 1,
          "hint": "LFO rate in hertz",
          "varname": "fk_mod_rate",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Selected LFO rate",
              "parameter_shortname": "Selected LFO rate",
              "parameter_type": 0,
              "parameter_mmin": 0.01,
              "parameter_mmax": 20,
              "parameter_initial": [
                0.12
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1,
              "parameter_unitstyle": 9,
              "parameter_units": "%.2f Hz"
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-20",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            144,
            48,
            140,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            144,
            48,
            140,
            20
          ],
          "outlettype": [
            "int",
            "",
            ""
          ],
          "varname": "fk_mod_shape",
          "items": [
            "Sine",
            ",",
            "Triangle",
            ",",
            "Saw",
            ",",
            "Square",
            ",",
            "S&H",
            ",",
            "Breakpoint"
          ]
        }
      },
      {
        "box": {
          "id": "obj-21",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            336,
            72,
            92,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            336,
            72,
            92,
            20
          ],
          "outlettype": [
            "",
            ""
          ],
          "text": "Add route",
          "texton": "Add route",
          "mode": 0,
          "parameter_enable": 0,
          "varname": "fk_action_add_route"
        }
      },
      {
        "box": {
          "id": "obj-22",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            336,
            390,
            100,
            22
          ],
          "text": "add_route"
        }
      },
      {
        "box": {
          "id": "obj-23",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            432,
            72,
            140,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            432,
            72,
            140,
            20
          ],
          "outlettype": [
            "",
            ""
          ],
          "text": "Remove route",
          "texton": "Remove route",
          "mode": 0,
          "parameter_enable": 0,
          "varname": "fk_action_clear_route"
        }
      },
      {
        "box": {
          "id": "obj-24",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            432,
            390,
            100,
            22
          ],
          "text": "clear_route"
        }
      },
      {
        "box": {
          "id": "obj-25",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            149,
            280,
            38,
            22
          ],
          "text": "+ 1",
          "outlettype": [
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-26",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            195,
            280,
            144,
            22
          ],
          "text": "prepend view",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-27",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            0,
            280,
            144,
            22
          ],
          "text": "prepend select_lfo",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-28",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            350,
            280,
            144,
            22
          ],
          "text": "prepend select_destination",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-29",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            500,
            280,
            144,
            22
          ],
          "text": "prepend set_depth",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-30",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            650,
            280,
            144,
            22
          ],
          "text": "prepend set_rate",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-31",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            800,
            280,
            144,
            22
          ],
          "text": "prepend set_shape",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-32",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            672,
            96,
            380,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            672,
            96,
            380,
            20
          ],
          "text": "LFO 1  \u00b7  live signal",
          "varname": "fk_signal_label"
        }
      },
      {
        "box": {
          "id": "obj-33",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            0,
            96,
            524,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            96,
            524,
            20
          ],
          "text": "LFO 1  \u00b7  Sine",
          "varname": "fk_curve_label"
        }
      },
      {
        "box": {
          "id": "obj-34",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            672,
            24,
            188,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            672,
            24,
            188,
            20
          ],
          "text": "Applied value  \u00b7  Audio off",
          "varname": "fk_applied_value"
        }
      },
      {
        "box": {
          "id": "obj-35",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            864,
            24,
            188,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            864,
            24,
            188,
            20
          ],
          "text": "LFO signal  \u00b7  Audio off",
          "varname": "fk_lfo_value"
        }
      },
      {
        "box": {
          "id": "obj-36",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            672,
            48,
            380,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            672,
            48,
            380,
            20
          ],
          "text": "Active routes on LFO 1  /  0",
          "varname": "fk_active_label"
        }
      },
      {
        "box": {
          "id": "obj-37",
          "maxclass": "umenu",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            672,
            72,
            380,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            672,
            72,
            380,
            20
          ],
          "outlettype": [
            "int",
            "",
            ""
          ],
          "varname": "fk_active_routes",
          "items": [
            "No active routes"
          ]
        }
      },
      {
        "box": {
          "id": "obj-38",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            420,
            318,
            144,
            22
          ],
          "text": "prepend jump_route",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-39",
          "maxclass": "scope~",
          "numinlets": 2,
          "numoutlets": 0,
          "patching_rect": [
            672,
            120,
            380,
            92
          ],
          "presentation": 1,
          "presentation_rect": [
            672,
            120,
            380,
            92
          ],
          "range": [
            -1.0,
            1.0
          ],
          "bufsize": 128,
          "calccount": 256,
          "varname": "fk_lfo_scope"
        }
      },
      {
        "box": {
          "id": "obj-40",
          "maxclass": "function",
          "numinlets": 1,
          "numoutlets": 4,
          "patching_rect": [
            0,
            120,
            668,
            92
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            120,
            668,
            92
          ],
          "outlettype": [
            "float",
            "",
            "",
            "bang"
          ],
          "hint": "Click to add a point. Drag to edit. Shift-click to delete.",
          "varname": "fk_curve",
          "domain": 1.0,
          "range": [
            -1.0,
            1.0
          ],
          "mode": 0,
          "hidden": 1,
          "ignoreclick": 1,
          "clicksustain": 0,
          "addpoints": [
            0,
            0,
            0,
            0.25,
            1,
            0,
            0.5,
            0,
            0,
            0.75,
            -1,
            0,
            1,
            0,
            0
          ]
        }
      },
      {
        "box": {
          "id": "obj-41",
          "maxclass": "jsui",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            0,
            120,
            668,
            92
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            120,
            668,
            92
          ],
          "filename": "fk_lfo_preview.js",
          "varname": "fk_lfo_preview",
          "ignoreclick": 1,
          "border": 0,
          "parameter_enable": 0
        }
      },
      {
        "box": {
          "id": "obj-42",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            570,
            318,
            94,
            22
          ],
          "text": "curve_edited"
        }
      },
      {
        "box": {
          "id": "obj-43",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            675,
            318,
            144,
            22
          ],
          "text": "prepend curve_dump",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-44",
          "maxclass": "live.text",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            528,
            96,
            140,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            528,
            96,
            140,
            20
          ],
          "outlettype": [
            "",
            ""
          ],
          "text": "Use curve",
          "texton": "Use curve",
          "mode": 0,
          "parameter_enable": 0,
          "varname": "fk_action_use_curve"
        }
      },
      {
        "box": {
          "id": "obj-45",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            528,
            420,
            100,
            22
          ],
          "text": "use_curve"
        }
      },
      {
        "box": {
          "id": "obj-46",
          "maxclass": "newobj",
          "numinlets": 9,
          "numoutlets": 1,
          "patching_rect": [
            0,
            864,
            140,
            22
          ],
          "text": "selector~ 8 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_watch"
        }
      },
      {
        "box": {
          "id": "obj-47",
          "maxclass": "newobj",
          "numinlets": 9,
          "numoutlets": 1,
          "patching_rect": [
            220,
            864,
            140,
            22
          ],
          "text": "selector~ 8 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_phase_watch"
        }
      },
      {
        "box": {
          "id": "obj-48",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            0,
            900,
            120,
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
          "id": "obj-49",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            0,
            934,
            144,
            22
          ],
          "text": "prepend lfo_sample",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-50",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            220,
            900,
            120,
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
          "id": "obj-51",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            220,
            934,
            144,
            22
          ],
          "text": "prepend lfo_phase",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-52",
          "maxclass": "newobj",
          "numinlets": 8,
          "numoutlets": 67,
          "patching_rect": [
            0,
            980,
            1052,
            22
          ],
          "text": "matrix~ 8 66 1. @ramp 20",
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
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-53",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            920,
            318,
            65,
            22
          ],
          "text": "deferlow",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-54",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            0,
            458,
            90,
            22
          ],
          "text": "phasor~ 0.12",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_phase_1"
        }
      },
      {
        "box": {
          "id": "obj-55",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            0,
            820,
            150,
            22
          ],
          "text": "selector~ 6 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_shape_signal_1"
        }
      },
      {
        "box": {
          "id": "obj-56",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            0,
            502,
            64,
            22
          ],
          "text": "+~ 0.75",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-57",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            0,
            538,
            50,
            22
          ],
          "text": "cos~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-58",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            68,
            502,
            90,
            22
          ],
          "text": "triangle~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-59",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            68,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-60",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            68,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-61",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            162,
            502,
            56,
            22
          ],
          "text": "<~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-62",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            162,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-63",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            162,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-64",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            0,
            574,
            54,
            22
          ],
          "text": "noise~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-65",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            0,
            610,
            100,
            22
          ],
          "text": "sah~ 0.000001",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-66",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            120,
            610,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_1_0"
        }
      },
      {
        "box": {
          "id": "obj-67",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            120,
            637,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_1_0"
        }
      },
      {
        "box": {
          "id": "obj-68",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            120,
            665,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_1_1"
        }
      },
      {
        "box": {
          "id": "obj-69",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            120,
            692,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_1_1"
        }
      },
      {
        "box": {
          "id": "obj-70",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            220,
            720,
            100,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ],
          "varname": "fk_curve_fade_1"
        }
      },
      {
        "box": {
          "id": "obj-71",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            220,
            755,
            100,
            22
          ],
          "text": "curve_ready 0"
        }
      },
      {
        "box": {
          "id": "obj-72",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            120,
            720,
            44,
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
          "id": "obj-73",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            120,
            755,
            44,
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
          "id": "obj-74",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            120,
            788,
            44,
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
          "id": "obj-75",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            350,
            458,
            90,
            22
          ],
          "text": "phasor~ 0.31",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_phase_2"
        }
      },
      {
        "box": {
          "id": "obj-76",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            350,
            820,
            150,
            22
          ],
          "text": "selector~ 6 2",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_shape_signal_2"
        }
      },
      {
        "box": {
          "id": "obj-77",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            350,
            502,
            64,
            22
          ],
          "text": "+~ 0.75",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-78",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            350,
            538,
            50,
            22
          ],
          "text": "cos~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-79",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            418,
            502,
            90,
            22
          ],
          "text": "triangle~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-80",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            418,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-81",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            418,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-82",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            512,
            502,
            56,
            22
          ],
          "text": "<~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-83",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            512,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-84",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            512,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-85",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            350,
            574,
            54,
            22
          ],
          "text": "noise~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-86",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            350,
            610,
            100,
            22
          ],
          "text": "sah~ 0.000001",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-87",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            470,
            610,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_2_0"
        }
      },
      {
        "box": {
          "id": "obj-88",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            470,
            637,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_2_0"
        }
      },
      {
        "box": {
          "id": "obj-89",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            470,
            665,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_2_1"
        }
      },
      {
        "box": {
          "id": "obj-90",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            470,
            692,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_2_1"
        }
      },
      {
        "box": {
          "id": "obj-91",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            570,
            720,
            100,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ],
          "varname": "fk_curve_fade_2"
        }
      },
      {
        "box": {
          "id": "obj-92",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            570,
            755,
            100,
            22
          ],
          "text": "curve_ready 1"
        }
      },
      {
        "box": {
          "id": "obj-93",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            470,
            720,
            44,
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
          "id": "obj-94",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            470,
            755,
            44,
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
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            470,
            788,
            44,
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
          "id": "obj-96",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            700,
            458,
            90,
            22
          ],
          "text": "phasor~ 0.73",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_phase_3"
        }
      },
      {
        "box": {
          "id": "obj-97",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            700,
            820,
            150,
            22
          ],
          "text": "selector~ 6 3",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_shape_signal_3"
        }
      },
      {
        "box": {
          "id": "obj-98",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            700,
            502,
            64,
            22
          ],
          "text": "+~ 0.75",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-99",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            700,
            538,
            50,
            22
          ],
          "text": "cos~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-100",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            768,
            502,
            90,
            22
          ],
          "text": "triangle~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-101",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            768,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-102",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            768,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-103",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            862,
            502,
            56,
            22
          ],
          "text": "<~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-104",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            862,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-105",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            862,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-106",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            700,
            574,
            54,
            22
          ],
          "text": "noise~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-107",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            700,
            610,
            100,
            22
          ],
          "text": "sah~ 0.000001",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-108",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            820,
            610,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_3_0"
        }
      },
      {
        "box": {
          "id": "obj-109",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            820,
            637,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_3_0"
        }
      },
      {
        "box": {
          "id": "obj-110",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            820,
            665,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_3_1"
        }
      },
      {
        "box": {
          "id": "obj-111",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            820,
            692,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_3_1"
        }
      },
      {
        "box": {
          "id": "obj-112",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            920,
            720,
            100,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ],
          "varname": "fk_curve_fade_3"
        }
      },
      {
        "box": {
          "id": "obj-113",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            920,
            755,
            100,
            22
          ],
          "text": "curve_ready 2"
        }
      },
      {
        "box": {
          "id": "obj-114",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            720,
            44,
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
          "id": "obj-115",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            755,
            44,
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
          "id": "obj-116",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            820,
            788,
            44,
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
          "id": "obj-117",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1050,
            458,
            90,
            22
          ],
          "text": "phasor~ 0.18",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_phase_4"
        }
      },
      {
        "box": {
          "id": "obj-118",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            1050,
            820,
            150,
            22
          ],
          "text": "selector~ 6 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_shape_signal_4"
        }
      },
      {
        "box": {
          "id": "obj-119",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1050,
            502,
            64,
            22
          ],
          "text": "+~ 0.75",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-120",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1050,
            538,
            50,
            22
          ],
          "text": "cos~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-121",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1118,
            502,
            90,
            22
          ],
          "text": "triangle~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-122",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1118,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-123",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1118,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-124",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1212,
            502,
            56,
            22
          ],
          "text": "<~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-125",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1212,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-126",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1212,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-127",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            1050,
            574,
            54,
            22
          ],
          "text": "noise~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-128",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1050,
            610,
            100,
            22
          ],
          "text": "sah~ 0.000001",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-129",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1170,
            610,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_4_0"
        }
      },
      {
        "box": {
          "id": "obj-130",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1170,
            637,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_4_0"
        }
      },
      {
        "box": {
          "id": "obj-131",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1170,
            665,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_4_1"
        }
      },
      {
        "box": {
          "id": "obj-132",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1170,
            692,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_4_1"
        }
      },
      {
        "box": {
          "id": "obj-133",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1270,
            720,
            100,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ],
          "varname": "fk_curve_fade_4"
        }
      },
      {
        "box": {
          "id": "obj-134",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1270,
            755,
            100,
            22
          ],
          "text": "curve_ready 3"
        }
      },
      {
        "box": {
          "id": "obj-135",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1170,
            720,
            44,
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
          "id": "obj-136",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1170,
            755,
            44,
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
          "id": "obj-137",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1170,
            788,
            44,
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
          "id": "obj-138",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            458,
            90,
            22
          ],
          "text": "phasor~ 0.43",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_phase_5"
        }
      },
      {
        "box": {
          "id": "obj-139",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            820,
            150,
            22
          ],
          "text": "selector~ 6 2",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_shape_signal_5"
        }
      },
      {
        "box": {
          "id": "obj-140",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            502,
            64,
            22
          ],
          "text": "+~ 0.75",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-141",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            538,
            50,
            22
          ],
          "text": "cos~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-142",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1468,
            502,
            90,
            22
          ],
          "text": "triangle~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-143",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1468,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-144",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1468,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-145",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1562,
            502,
            56,
            22
          ],
          "text": "<~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-146",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1562,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-147",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1562,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-148",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            574,
            54,
            22
          ],
          "text": "noise~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-149",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            610,
            100,
            22
          ],
          "text": "sah~ 0.000001",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-150",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1520,
            610,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_5_0"
        }
      },
      {
        "box": {
          "id": "obj-151",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            637,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_5_0"
        }
      },
      {
        "box": {
          "id": "obj-152",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1520,
            665,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_5_1"
        }
      },
      {
        "box": {
          "id": "obj-153",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            692,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_5_1"
        }
      },
      {
        "box": {
          "id": "obj-154",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1620,
            720,
            100,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ],
          "varname": "fk_curve_fade_5"
        }
      },
      {
        "box": {
          "id": "obj-155",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1620,
            755,
            100,
            22
          ],
          "text": "curve_ready 4"
        }
      },
      {
        "box": {
          "id": "obj-156",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            720,
            44,
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
          "id": "obj-157",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            755,
            44,
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
          "id": "obj-158",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            788,
            44,
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
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            458,
            90,
            22
          ],
          "text": "phasor~ 0.67",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_phase_6"
        }
      },
      {
        "box": {
          "id": "obj-160",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            820,
            150,
            22
          ],
          "text": "selector~ 6 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_shape_signal_6"
        }
      },
      {
        "box": {
          "id": "obj-161",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            502,
            64,
            22
          ],
          "text": "+~ 0.75",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-162",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            538,
            50,
            22
          ],
          "text": "cos~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-163",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1818,
            502,
            90,
            22
          ],
          "text": "triangle~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-164",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1818,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-165",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1818,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-166",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1912,
            502,
            56,
            22
          ],
          "text": "<~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-167",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1912,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-168",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1912,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-169",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            574,
            54,
            22
          ],
          "text": "noise~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-170",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            610,
            100,
            22
          ],
          "text": "sah~ 0.000001",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-171",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1870,
            610,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_6_0"
        }
      },
      {
        "box": {
          "id": "obj-172",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1870,
            637,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_6_0"
        }
      },
      {
        "box": {
          "id": "obj-173",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            1870,
            665,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_6_1"
        }
      },
      {
        "box": {
          "id": "obj-174",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1870,
            692,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_6_1"
        }
      },
      {
        "box": {
          "id": "obj-175",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            1970,
            720,
            100,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ],
          "varname": "fk_curve_fade_6"
        }
      },
      {
        "box": {
          "id": "obj-176",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1970,
            755,
            100,
            22
          ],
          "text": "curve_ready 5"
        }
      },
      {
        "box": {
          "id": "obj-177",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1870,
            720,
            44,
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
          "id": "obj-178",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1870,
            755,
            44,
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
          "id": "obj-179",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            1870,
            788,
            44,
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
          "id": "obj-180",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            458,
            90,
            22
          ],
          "text": "phasor~ 1.1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_phase_7"
        }
      },
      {
        "box": {
          "id": "obj-181",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            820,
            150,
            22
          ],
          "text": "selector~ 6 2",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_shape_signal_7"
        }
      },
      {
        "box": {
          "id": "obj-182",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            502,
            64,
            22
          ],
          "text": "+~ 0.75",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-183",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            538,
            50,
            22
          ],
          "text": "cos~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-184",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2168,
            502,
            90,
            22
          ],
          "text": "triangle~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-185",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2168,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-186",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2168,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-187",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2262,
            502,
            56,
            22
          ],
          "text": "<~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-188",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2262,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-189",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2262,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-190",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            574,
            54,
            22
          ],
          "text": "noise~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-191",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            610,
            100,
            22
          ],
          "text": "sah~ 0.000001",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-192",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2220,
            610,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_7_0"
        }
      },
      {
        "box": {
          "id": "obj-193",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2220,
            637,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_7_0"
        }
      },
      {
        "box": {
          "id": "obj-194",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2220,
            665,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_7_1"
        }
      },
      {
        "box": {
          "id": "obj-195",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2220,
            692,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_7_1"
        }
      },
      {
        "box": {
          "id": "obj-196",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2320,
            720,
            100,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ],
          "varname": "fk_curve_fade_7"
        }
      },
      {
        "box": {
          "id": "obj-197",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2320,
            755,
            100,
            22
          ],
          "text": "curve_ready 6"
        }
      },
      {
        "box": {
          "id": "obj-198",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2220,
            720,
            44,
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
          "id": "obj-199",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2220,
            755,
            44,
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
          "id": "obj-200",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2220,
            788,
            44,
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
          "id": "obj-201",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2450,
            458,
            90,
            22
          ],
          "text": "phasor~ 1.7",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_phase_8"
        }
      },
      {
        "box": {
          "id": "obj-202",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            2450,
            820,
            150,
            22
          ],
          "text": "selector~ 6 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_lfo_shape_signal_8"
        }
      },
      {
        "box": {
          "id": "obj-203",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2450,
            502,
            64,
            22
          ],
          "text": "+~ 0.75",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-204",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            2450,
            538,
            50,
            22
          ],
          "text": "cos~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-205",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2518,
            502,
            90,
            22
          ],
          "text": "triangle~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-206",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2518,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-207",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2518,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-208",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2612,
            502,
            56,
            22
          ],
          "text": "<~ 0.5",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-209",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2612,
            538,
            54,
            22
          ],
          "text": "*~ 2.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-210",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2612,
            574,
            54,
            22
          ],
          "text": "-~ 1.",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-211",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            2450,
            574,
            54,
            22
          ],
          "text": "noise~",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-212",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2450,
            610,
            100,
            22
          ],
          "text": "sah~ 0.000001",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-213",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2570,
            610,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_8_0"
        }
      },
      {
        "box": {
          "id": "obj-214",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2570,
            637,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_8_0"
        }
      },
      {
        "box": {
          "id": "obj-215",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "patching_rect": [
            2570,
            665,
            222,
            22
          ],
          "text": "buffer~ fk-unbound-curve @samps 1025",
          "outlettype": [
            "float",
            "bang"
          ],
          "varname": "fk_curve_buffer_8_1"
        }
      },
      {
        "box": {
          "id": "obj-216",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2570,
            692,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_8_1"
        }
      },
      {
        "box": {
          "id": "obj-217",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "patching_rect": [
            2670,
            720,
            100,
            22
          ],
          "text": "line~ 0.",
          "outlettype": [
            "signal",
            "bang"
          ],
          "varname": "fk_curve_fade_8"
        }
      },
      {
        "box": {
          "id": "obj-218",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2670,
            755,
            100,
            22
          ],
          "text": "curve_ready 7"
        }
      },
      {
        "box": {
          "id": "obj-219",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2570,
            720,
            44,
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
          "id": "obj-220",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2570,
            755,
            44,
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
          "id": "obj-221",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            2570,
            788,
            44,
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
          "maxclass": "newobj",
          "numinlets": 66,
          "numoutlets": 1,
          "patching_rect": [
            0,
            1028,
            1052,
            22
          ],
          "text": "mc.pack~ 66",
          "outlettype": [
            "multichannelsignal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-223",
          "maxclass": "outlet",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            0,
            1070,
            30,
            30
          ],
          "index": 1,
          "comment": "66 signed modulation channels"
        }
      },
      {
        "box": {
          "id": "obj-224",
          "maxclass": "outlet",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            190,
            1070,
            30,
            30
          ],
          "index": 2,
          "comment": "Selected feedback signal index"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-2",
            0
          ],
          "destination": [
            "obj-1",
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
            "obj-4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-4",
            0
          ],
          "destination": [
            "obj-1",
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
            "obj-22",
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
            "obj-1",
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
            "obj-1",
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
            "obj-25",
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
            "obj-1",
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
            "obj-1",
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
            "obj-28",
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
            "obj-1",
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
            "obj-1",
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
            "obj-1",
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
            "obj-31",
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
            "obj-1",
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
            "obj-1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-40",
            3
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
            "obj-1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-40",
            2
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
            "obj-1",
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
            "obj-1",
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
            "obj-39",
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
            "obj-48",
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
            "obj-1",
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
            "obj-51",
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
            "obj-1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-1",
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
            "obj-53",
            0
          ],
          "destination": [
            "obj-1",
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
            "obj-67",
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
            "obj-69",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-70",
            1
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
            "obj-53",
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
            "obj-72",
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
            "obj-72",
            1
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
            "obj-70",
            0
          ],
          "destination": [
            "obj-73",
            1
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
            "obj-74",
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
            1
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
            "obj-56",
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
            "obj-58",
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
            "obj-59",
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
            "obj-61",
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
            "obj-57",
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
            "obj-60",
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
            "obj-63",
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
            "obj-54",
            0
          ],
          "destination": [
            "obj-65",
            1
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
            "obj-55",
            1
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
            "obj-55",
            2
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
            "obj-55",
            3
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
            "obj-55",
            4
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
            "obj-55",
            5
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
            "obj-55",
            6
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
            "obj-52",
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
            "obj-46",
            1
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
            "obj-47",
            1
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
            "obj-88",
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
            "obj-90",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-91",
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
            "obj-53",
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
            "obj-93",
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
            "obj-93",
            1
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
            "obj-91",
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
            "obj-88",
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
            "obj-94",
            0
          ],
          "destination": [
            "obj-95",
            1
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
            "obj-77",
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
            "obj-80",
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
            "obj-82",
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
            "obj-80",
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
            "obj-75",
            0
          ],
          "destination": [
            "obj-86",
            1
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
            "obj-76",
            1
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
            "obj-76",
            2
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
            "obj-76",
            3
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
            "obj-76",
            4
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
            "obj-76",
            5
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
            "obj-76",
            6
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
            "obj-52",
            1
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
            "obj-46",
            2
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
            "obj-47",
            2
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
            "obj-109",
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
            "obj-111",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-112",
            1
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
            "obj-113",
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
            "obj-111",
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
            "obj-109",
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
            "obj-112",
            0
          ],
          "destination": [
            "obj-115",
            1
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
            "obj-116",
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
            1
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
            "obj-98",
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
            "obj-100",
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
            "obj-101",
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
            "obj-103",
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
            "obj-99",
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
            "obj-102",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-103",
            0
          ],
          "destination": [
            "obj-104",
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
            "obj-96",
            0
          ],
          "destination": [
            "obj-107",
            1
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
            "obj-97",
            1
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
            "obj-97",
            2
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
            "obj-97",
            3
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
            "obj-97",
            4
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
            "obj-97",
            5
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
            "obj-97",
            6
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
            "obj-52",
            2
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
            "obj-46",
            3
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
            "obj-47",
            3
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
            "obj-130",
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
            "obj-132",
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
            "obj-53",
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
            "obj-135",
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
            "obj-133",
            0
          ],
          "destination": [
            "obj-136",
            1
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
            "obj-137",
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
            "obj-137",
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
            "obj-119",
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
            "obj-121",
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
            "obj-122",
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
            "obj-122",
            0
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
            "obj-117",
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
            "obj-120",
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
            "obj-121",
            0
          ],
          "destination": [
            "obj-118",
            2
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
            "obj-118",
            3
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
            "obj-118",
            4
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
            "obj-118",
            5
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
            "obj-118",
            6
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
            "obj-52",
            3
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
            "obj-46",
            4
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
            "obj-47",
            4
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
            "obj-151",
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
            "obj-153",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-154",
            1
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
            "obj-53",
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
            "obj-156",
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
            "obj-156",
            1
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
            "obj-154",
            0
          ],
          "destination": [
            "obj-157",
            1
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
            "obj-138",
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
            "obj-138",
            0
          ],
          "destination": [
            "obj-142",
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
            "obj-143",
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
            "obj-145",
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
            "obj-143",
            0
          ],
          "destination": [
            "obj-144",
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
            "obj-147",
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
            "obj-149",
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
            "obj-149",
            1
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
            1
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
            "obj-139",
            2
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
            "obj-139",
            3
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
            "obj-139",
            4
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
            "obj-139",
            5
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
            "obj-139",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-139",
            0
          ],
          "destination": [
            "obj-52",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-139",
            0
          ],
          "destination": [
            "obj-46",
            5
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
            "obj-47",
            5
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
            "obj-172",
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
            "obj-174",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-175",
            1
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
            "obj-53",
            0
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
            "obj-177",
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
            "obj-177",
            1
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
            "obj-175",
            0
          ],
          "destination": [
            "obj-178",
            1
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
            "obj-179",
            1
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
            "obj-161",
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
            "obj-163",
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
            "obj-164",
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
            "obj-166",
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
            "obj-162",
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
            "obj-168",
            0
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
            "obj-170",
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
            "obj-170",
            1
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
            "obj-160",
            1
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
            "obj-160",
            2
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
            "obj-160",
            3
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
            "obj-160",
            4
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
            "obj-160",
            5
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
            "obj-160",
            6
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
            "obj-52",
            5
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
            "obj-46",
            6
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
            "obj-47",
            6
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
            "obj-193",
            0
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
            "obj-195",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-196",
            1
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
            "obj-197",
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
            "obj-195",
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
            "obj-193",
            0
          ],
          "destination": [
            "obj-198",
            1
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
            "obj-199",
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
            "obj-200",
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
            "obj-182",
            0
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
            "obj-184",
            0
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
            "obj-185",
            0
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
            "obj-187",
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
            "obj-183",
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
            "obj-189",
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
            "obj-191",
            0
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
            "obj-191",
            1
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
            "obj-181",
            2
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
            "obj-181",
            3
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
            "obj-181",
            4
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
            "obj-181",
            5
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
            6
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
            "obj-52",
            6
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
            "obj-46",
            7
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
            "obj-47",
            7
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
            "obj-214",
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
            "obj-216",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-217",
            1
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
            "obj-218",
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
            "obj-216",
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
            "obj-214",
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
            0
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
            "obj-217",
            0
          ],
          "destination": [
            "obj-220",
            1
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
            "obj-201",
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
            "obj-201",
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
            "obj-201",
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
            "obj-201",
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
            "obj-203",
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
            "obj-206",
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
            "obj-208",
            0
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
            "obj-211",
            0
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
            "obj-201",
            0
          ],
          "destination": [
            "obj-212",
            1
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
            "obj-202",
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
            "obj-202",
            2
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
            "obj-202",
            3
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
            "obj-202",
            4
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
            "obj-202",
            5
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
            "obj-202",
            6
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
            "obj-52",
            7
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
            "obj-46",
            8
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
            "obj-47",
            8
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
            "obj-222",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            1
          ],
          "destination": [
            "obj-222",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            2
          ],
          "destination": [
            "obj-222",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            3
          ],
          "destination": [
            "obj-222",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            4
          ],
          "destination": [
            "obj-222",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            5
          ],
          "destination": [
            "obj-222",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            6
          ],
          "destination": [
            "obj-222",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            7
          ],
          "destination": [
            "obj-222",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            8
          ],
          "destination": [
            "obj-222",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            9
          ],
          "destination": [
            "obj-222",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            10
          ],
          "destination": [
            "obj-222",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            11
          ],
          "destination": [
            "obj-222",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            12
          ],
          "destination": [
            "obj-222",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            13
          ],
          "destination": [
            "obj-222",
            13
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            14
          ],
          "destination": [
            "obj-222",
            14
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            15
          ],
          "destination": [
            "obj-222",
            15
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            16
          ],
          "destination": [
            "obj-222",
            16
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            17
          ],
          "destination": [
            "obj-222",
            17
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            18
          ],
          "destination": [
            "obj-222",
            18
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            19
          ],
          "destination": [
            "obj-222",
            19
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            20
          ],
          "destination": [
            "obj-222",
            20
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            21
          ],
          "destination": [
            "obj-222",
            21
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            22
          ],
          "destination": [
            "obj-222",
            22
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            23
          ],
          "destination": [
            "obj-222",
            23
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            24
          ],
          "destination": [
            "obj-222",
            24
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            25
          ],
          "destination": [
            "obj-222",
            25
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            26
          ],
          "destination": [
            "obj-222",
            26
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            27
          ],
          "destination": [
            "obj-222",
            27
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            28
          ],
          "destination": [
            "obj-222",
            28
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            29
          ],
          "destination": [
            "obj-222",
            29
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            30
          ],
          "destination": [
            "obj-222",
            30
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            31
          ],
          "destination": [
            "obj-222",
            31
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            32
          ],
          "destination": [
            "obj-222",
            32
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            33
          ],
          "destination": [
            "obj-222",
            33
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            34
          ],
          "destination": [
            "obj-222",
            34
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            35
          ],
          "destination": [
            "obj-222",
            35
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            36
          ],
          "destination": [
            "obj-222",
            36
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            37
          ],
          "destination": [
            "obj-222",
            37
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            38
          ],
          "destination": [
            "obj-222",
            38
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            39
          ],
          "destination": [
            "obj-222",
            39
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            40
          ],
          "destination": [
            "obj-222",
            40
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            41
          ],
          "destination": [
            "obj-222",
            41
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            42
          ],
          "destination": [
            "obj-222",
            42
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            43
          ],
          "destination": [
            "obj-222",
            43
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            44
          ],
          "destination": [
            "obj-222",
            44
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            45
          ],
          "destination": [
            "obj-222",
            45
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            46
          ],
          "destination": [
            "obj-222",
            46
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            47
          ],
          "destination": [
            "obj-222",
            47
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            48
          ],
          "destination": [
            "obj-222",
            48
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            49
          ],
          "destination": [
            "obj-222",
            49
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            50
          ],
          "destination": [
            "obj-222",
            50
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            51
          ],
          "destination": [
            "obj-222",
            51
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            52
          ],
          "destination": [
            "obj-222",
            52
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            53
          ],
          "destination": [
            "obj-222",
            53
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            54
          ],
          "destination": [
            "obj-222",
            54
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            55
          ],
          "destination": [
            "obj-222",
            55
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            56
          ],
          "destination": [
            "obj-222",
            56
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            57
          ],
          "destination": [
            "obj-222",
            57
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            58
          ],
          "destination": [
            "obj-222",
            58
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            59
          ],
          "destination": [
            "obj-222",
            59
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            60
          ],
          "destination": [
            "obj-222",
            60
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            61
          ],
          "destination": [
            "obj-222",
            61
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            62
          ],
          "destination": [
            "obj-222",
            62
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            63
          ],
          "destination": [
            "obj-222",
            63
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            64
          ],
          "destination": [
            "obj-222",
            64
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-52",
            65
          ],
          "destination": [
            "obj-222",
            65
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
            "obj-223",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-1",
            1
          ],
          "destination": [
            "obj-224",
            0
          ]
        }
      }
    ]
  }
}
