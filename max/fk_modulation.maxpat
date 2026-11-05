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
          "text": "Window"
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
            "Window 4"
          ]
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
            "Pan"
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
          "text": "LFO 1  \u00b7  Breakpoint curve",
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
          "id": "obj-42",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            675,
            318,
            144,
            22
          ],
          "text": "prepend curve_points",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-43",
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
          "id": "obj-44",
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
          "id": "obj-45",
          "maxclass": "newobj",
          "numinlets": 9,
          "numoutlets": 1,
          "patching_rect": [
            0,
            718,
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
          "id": "obj-46",
          "maxclass": "newobj",
          "numinlets": 9,
          "numoutlets": 1,
          "patching_rect": [
            220,
            718,
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
          "id": "obj-47",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            0,
            756,
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
          "id": "obj-48",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            0,
            788,
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
          "id": "obj-49",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            220,
            756,
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
          "id": "obj-50",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "patching_rect": [
            220,
            788,
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
          "id": "obj-51",
          "maxclass": "newobj",
          "numinlets": 8,
          "numoutlets": 37,
          "patching_rect": [
            0,
            844,
            1052,
            22
          ],
          "text": "matrix~ 8 36 1. @ramp 20",
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
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-52",
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
          "id": "obj-53",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            0,
            660,
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
          "id": "obj-54",
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
          "id": "obj-55",
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
          "id": "obj-56",
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
          "id": "obj-57",
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
          "id": "obj-58",
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
          "id": "obj-59",
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
          "id": "obj-60",
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
          "id": "obj-61",
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
          "id": "obj-62",
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
          "id": "obj-63",
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
          "id": "obj-64",
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
          "varname": "fk_curve_buffer_1"
        }
      },
      {
        "box": {
          "id": "obj-65",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            120,
            642,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_1"
        }
      },
      {
        "box": {
          "id": "obj-66",
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
          "id": "obj-67",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            350,
            660,
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
          "id": "obj-68",
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
          "id": "obj-69",
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
          "id": "obj-70",
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
          "id": "obj-71",
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
          "id": "obj-72",
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
          "id": "obj-73",
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
          "id": "obj-74",
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
          "id": "obj-75",
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
          "id": "obj-76",
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
          "id": "obj-77",
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
          "id": "obj-78",
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
          "varname": "fk_curve_buffer_2"
        }
      },
      {
        "box": {
          "id": "obj-79",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            470,
            642,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_2"
        }
      },
      {
        "box": {
          "id": "obj-80",
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
          "id": "obj-81",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            700,
            660,
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
          "id": "obj-82",
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
          "id": "obj-83",
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
          "id": "obj-84",
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
          "id": "obj-85",
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
          "id": "obj-86",
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
          "id": "obj-87",
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
          "id": "obj-88",
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
          "id": "obj-89",
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
          "id": "obj-90",
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
          "id": "obj-91",
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
          "id": "obj-92",
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
          "varname": "fk_curve_buffer_3"
        }
      },
      {
        "box": {
          "id": "obj-93",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            820,
            642,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_3"
        }
      },
      {
        "box": {
          "id": "obj-94",
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
          "id": "obj-95",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            1050,
            660,
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
          "id": "obj-96",
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
          "id": "obj-97",
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
          "id": "obj-98",
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
          "id": "obj-99",
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
          "id": "obj-100",
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
          "id": "obj-101",
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
          "id": "obj-102",
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
          "id": "obj-103",
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
          "id": "obj-104",
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
          "id": "obj-105",
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
          "id": "obj-106",
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
          "varname": "fk_curve_buffer_4"
        }
      },
      {
        "box": {
          "id": "obj-107",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1170,
            642,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_4"
        }
      },
      {
        "box": {
          "id": "obj-108",
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
          "id": "obj-109",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            1400,
            660,
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
          "id": "obj-110",
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
          "id": "obj-111",
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
          "id": "obj-112",
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
          "id": "obj-113",
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
          "id": "obj-114",
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
          "id": "obj-115",
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
          "id": "obj-116",
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
          "id": "obj-117",
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
          "id": "obj-118",
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
          "id": "obj-119",
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
          "id": "obj-120",
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
          "varname": "fk_curve_buffer_5"
        }
      },
      {
        "box": {
          "id": "obj-121",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1520,
            642,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_5"
        }
      },
      {
        "box": {
          "id": "obj-122",
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
          "id": "obj-123",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            1750,
            660,
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
          "id": "obj-124",
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
          "id": "obj-125",
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
          "id": "obj-126",
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
          "id": "obj-127",
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
          "id": "obj-128",
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
          "id": "obj-129",
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
          "id": "obj-130",
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
          "id": "obj-131",
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
          "id": "obj-132",
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
          "id": "obj-133",
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
          "id": "obj-134",
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
          "varname": "fk_curve_buffer_6"
        }
      },
      {
        "box": {
          "id": "obj-135",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            1870,
            642,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_6"
        }
      },
      {
        "box": {
          "id": "obj-136",
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
          "id": "obj-137",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            2100,
            660,
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
          "id": "obj-138",
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
          "id": "obj-139",
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
          "id": "obj-140",
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
          "id": "obj-141",
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
          "id": "obj-142",
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
          "id": "obj-143",
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
          "id": "obj-144",
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
          "id": "obj-145",
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
          "id": "obj-146",
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
          "id": "obj-147",
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
          "id": "obj-148",
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
          "varname": "fk_curve_buffer_7"
        }
      },
      {
        "box": {
          "id": "obj-149",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2220,
            642,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_7"
        }
      },
      {
        "box": {
          "id": "obj-150",
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
          "id": "obj-151",
          "maxclass": "newobj",
          "numinlets": 7,
          "numoutlets": 1,
          "patching_rect": [
            2450,
            660,
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
          "id": "obj-152",
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
          "id": "obj-153",
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
          "id": "obj-154",
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
          "id": "obj-155",
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
          "id": "obj-156",
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
          "id": "obj-157",
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
          "id": "obj-158",
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
          "id": "obj-159",
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
          "id": "obj-160",
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
          "id": "obj-161",
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
          "id": "obj-162",
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
          "varname": "fk_curve_buffer_8"
        }
      },
      {
        "box": {
          "id": "obj-163",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "patching_rect": [
            2570,
            642,
            215,
            22
          ],
          "text": "wave~ fk-unbound-curve @interp 1",
          "outlettype": [
            "signal"
          ],
          "varname": "fk_curve_wave_8"
        }
      },
      {
        "box": {
          "id": "obj-164",
          "maxclass": "newobj",
          "numinlets": 36,
          "numoutlets": 1,
          "patching_rect": [
            0,
            890,
            1052,
            22
          ],
          "text": "mc.pack~ 36",
          "outlettype": [
            "multichannelsignal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-165",
          "maxclass": "outlet",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            0,
            932,
            30,
            30
          ],
          "index": 1,
          "comment": "36 signed modulation channels"
        }
      },
      {
        "box": {
          "id": "obj-166",
          "maxclass": "outlet",
          "numinlets": 1,
          "numoutlets": 0,
          "patching_rect": [
            190,
            932,
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
            "obj-1",
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
            "obj-39",
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
            "obj-51",
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
            "obj-54",
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
            "obj-56",
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
            "obj-57",
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
            "obj-59",
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
            "obj-55",
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
            "obj-52",
            0
          ],
          "destination": [
            "obj-63",
            1
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
            "obj-53",
            1
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
            "obj-53",
            2
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
            "obj-53",
            3
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
            "obj-53",
            4
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
            "obj-53",
            5
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
            "obj-53",
            6
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
            "obj-51",
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
            "obj-45",
            1
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
            "obj-46",
            1
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
            "obj-68",
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
            "obj-70",
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
            "obj-71",
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
            "obj-73",
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
            "obj-79",
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
            "obj-69",
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
            "obj-72",
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
            "obj-75",
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
            "obj-66",
            0
          ],
          "destination": [
            "obj-77",
            1
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
            "obj-67",
            1
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
            "obj-67",
            2
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
            "obj-67",
            3
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
            "obj-67",
            4
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
            "obj-67",
            5
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
            "obj-67",
            6
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
            "obj-51",
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
            "obj-45",
            2
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
            "obj-46",
            2
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
            "obj-82",
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
            "obj-84",
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
            "obj-85",
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
            "obj-87",
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
            "obj-93",
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
            "obj-89",
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
            "obj-80",
            0
          ],
          "destination": [
            "obj-91",
            1
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
            "obj-81",
            1
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
            "obj-81",
            2
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
            "obj-81",
            3
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
            "obj-81",
            4
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
            "obj-81",
            5
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
            "obj-81",
            6
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
            "obj-51",
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
            "obj-45",
            3
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
            "obj-46",
            3
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
            "obj-96",
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
            "obj-98",
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
            "obj-99",
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
            "obj-101",
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
            "obj-97",
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
            "obj-94",
            0
          ],
          "destination": [
            "obj-105",
            1
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
            "obj-95",
            1
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
            "obj-95",
            2
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
            "obj-95",
            3
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
            "obj-95",
            4
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
            "obj-95",
            5
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
            "obj-95",
            6
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
            "obj-51",
            3
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
            "obj-45",
            4
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
            "obj-46",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-108",
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
            "obj-108",
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
            "obj-108",
            0
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
            "obj-108",
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
            "obj-108",
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
            "obj-110",
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
            "obj-117",
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
            "obj-119",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-108",
            0
          ],
          "destination": [
            "obj-119",
            1
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
            "obj-109",
            1
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
            "obj-109",
            2
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
            "obj-109",
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
            "obj-109",
            4
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
            "obj-109",
            5
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
            "obj-109",
            6
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
            "obj-51",
            4
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
            "obj-45",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-108",
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
            "obj-122",
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
            "obj-122",
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
            "obj-122",
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
            "obj-122",
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
            "obj-122",
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
            "obj-122",
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
            "obj-125",
            0
          ],
          "destination": [
            "obj-123",
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
            "obj-123",
            2
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
            "obj-123",
            3
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
            "obj-123",
            4
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
            "obj-123",
            5
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
            "obj-123",
            6
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
            "obj-51",
            5
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
            "obj-45",
            6
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
            "obj-46",
            6
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
            "obj-138",
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
            "obj-140",
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
            "obj-141",
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
            "obj-143",
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
            "obj-139",
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
            "obj-142",
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
            "obj-144",
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
            "obj-136",
            0
          ],
          "destination": [
            "obj-147",
            1
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
            "obj-137",
            1
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
            "obj-137",
            2
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
            "obj-137",
            3
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
            "obj-137",
            4
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
            "obj-137",
            5
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
            "obj-137",
            6
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
            "obj-51",
            6
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
            "obj-45",
            7
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
            "obj-46",
            7
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
            "obj-150",
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
            "obj-150",
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
            "obj-150",
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
            "obj-150",
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
            "obj-157",
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
            "obj-150",
            0
          ],
          "destination": [
            "obj-161",
            1
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
            "obj-151",
            1
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
            "obj-151",
            2
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
            "obj-151",
            3
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
            "obj-151",
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
            "obj-151",
            5
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
            "obj-151",
            6
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
            "obj-51",
            7
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
            "obj-45",
            8
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
            "obj-46",
            8
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
            "obj-164",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            1
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
            "obj-51",
            2
          ],
          "destination": [
            "obj-164",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            3
          ],
          "destination": [
            "obj-164",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            4
          ],
          "destination": [
            "obj-164",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            5
          ],
          "destination": [
            "obj-164",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            6
          ],
          "destination": [
            "obj-164",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            7
          ],
          "destination": [
            "obj-164",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            8
          ],
          "destination": [
            "obj-164",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            9
          ],
          "destination": [
            "obj-164",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            10
          ],
          "destination": [
            "obj-164",
            10
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            11
          ],
          "destination": [
            "obj-164",
            11
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            12
          ],
          "destination": [
            "obj-164",
            12
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            13
          ],
          "destination": [
            "obj-164",
            13
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            14
          ],
          "destination": [
            "obj-164",
            14
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            15
          ],
          "destination": [
            "obj-164",
            15
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            16
          ],
          "destination": [
            "obj-164",
            16
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            17
          ],
          "destination": [
            "obj-164",
            17
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            18
          ],
          "destination": [
            "obj-164",
            18
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            19
          ],
          "destination": [
            "obj-164",
            19
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            20
          ],
          "destination": [
            "obj-164",
            20
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            21
          ],
          "destination": [
            "obj-164",
            21
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            22
          ],
          "destination": [
            "obj-164",
            22
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            23
          ],
          "destination": [
            "obj-164",
            23
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            24
          ],
          "destination": [
            "obj-164",
            24
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            25
          ],
          "destination": [
            "obj-164",
            25
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            26
          ],
          "destination": [
            "obj-164",
            26
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            27
          ],
          "destination": [
            "obj-164",
            27
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            28
          ],
          "destination": [
            "obj-164",
            28
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            29
          ],
          "destination": [
            "obj-164",
            29
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            30
          ],
          "destination": [
            "obj-164",
            30
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            31
          ],
          "destination": [
            "obj-164",
            31
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            32
          ],
          "destination": [
            "obj-164",
            32
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            33
          ],
          "destination": [
            "obj-164",
            33
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            34
          ],
          "destination": [
            "obj-164",
            34
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-51",
            35
          ],
          "destination": [
            "obj-164",
            35
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
            "obj-1",
            1
          ],
          "destination": [
            "obj-166",
            0
          ]
        }
      }
    ]
  }
}
