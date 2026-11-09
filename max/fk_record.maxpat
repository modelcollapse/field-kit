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
      80,
      80,
      380,
      116
    ],
    "openinpresentation": 1,
    "description": "FIELD KIT capture. Feed the final stereo mix into inlets 1 and 2.",
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "varname": "capture_title",
          "maxclass": "comment",
          "patching_rect": [
            0,
            0,
            140,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Mix recording",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-2",
          "varname": "record_time",
          "maxclass": "comment",
          "patching_rect": [
            240,
            24,
            140,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "00:00.0",
          "fontsize": 16,
          "fontface": 1,
          "textjustification": 2,
          "presentation": 1,
          "presentation_rect": [
            240,
            24,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-3",
          "varname": "record_status",
          "maxclass": "comment",
          "patching_rect": [
            0,
            48,
            380,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Enable audio to record",
          "fontsize": 14,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            0,
            48,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-4",
          "varname": "record_file",
          "maxclass": "comment",
          "patching_rect": [
            0,
            72,
            380,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Choose Record mix… to name your take",
          "presentation": 1,
          "presentation_rect": [
            0,
            72,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-5",
          "varname": "record_format",
          "maxclass": "comment",
          "patching_rect": [
            0,
            96,
            380,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Stereo WAV · 24-bit · final mix",
          "presentation": 1,
          "presentation_rect": [
            0,
            96,
            380,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-6",
          "varname": "rec_controller",
          "maxclass": "newobj",
          "patching_rect": [
            240,
            216,
            120,
            22
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "js fk_recorder.js"
        }
      },
      {
        "box": {
          "id": "obj-7",
          "varname": "record_button",
          "maxclass": "live.text",
          "patching_rect": [
            0,
            24,
            140,
            20
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "mode": 0,
          "active": 0,
          "parameter_enable": 0,
          "text": "Record mix…",
          "texton": "Record mix…",
          "hint": "Choose where to save a WAV of the final mix.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            24,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-8",
          "varname": "record_button_message",
          "maxclass": "message",
          "patching_rect": [
            0,
            150,
            90,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "choose",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-9",
          "varname": "stop_button",
          "maxclass": "live.text",
          "patching_rect": [
            144,
            24,
            92,
            20
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "mode": 0,
          "active": 0,
          "parameter_enable": 0,
          "text": "Stop mix",
          "texton": "Stop mix",
          "hint": "Finish and save the mix recording.",
          "outlettype": [
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            144,
            24,
            92,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-10",
          "varname": "stop_button_message",
          "maxclass": "message",
          "patching_rect": [
            144,
            150,
            90,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "stop_record",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-11",
          "varname": "save_dialog",
          "maxclass": "newobj",
          "patching_rect": [
            400,
            150,
            110,
            22
          ],
          "numinlets": 1,
          "numoutlets": 3,
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
          "id": "obj-12",
          "varname": "chosen_path",
          "maxclass": "newobj",
          "patching_rect": [
            400,
            182,
            110,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend start_path",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-13",
          "varname": "cancel_dialog",
          "maxclass": "message",
          "patching_rect": [
            520,
            182,
            100,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "cancel",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-14",
          "varname": "writer",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            280,
            116,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "sfrecord~ 2",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-15",
          "varname": "audio_left",
          "maxclass": "inlet",
          "patching_rect": [
            0,
            216,
            30,
            30
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 1,
          "comment": "Left final mix",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-16",
          "varname": "audio_right",
          "maxclass": "inlet",
          "patching_rect": [
            90,
            216,
            30,
            30
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 2,
          "comment": "Right final mix",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-17",
          "varname": "elapsed_sample",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            314,
            116,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "snapshot~ 100",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-18",
          "varname": "elapsed_message",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            346,
            116,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend elapsed",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-19",
          "varname": "rec_dsp",
          "maxclass": "newobj",
          "patching_rect": [
            398,
            266,
            90,
            22
          ],
          "numinlets": 1,
          "numoutlets": 4,
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
          "id": "obj-20",
          "varname": "enabled_message",
          "maxclass": "newobj",
          "patching_rect": [
            398,
            298,
            140,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend dsp_enabled",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-21",
          "varname": "rec_load",
          "maxclass": "newobj",
          "patching_rect": [
            560,
            266,
            64,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "loadbang",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-22",
          "varname": "rec_defer",
          "maxclass": "newobj",
          "patching_rect": [
            560,
            298,
            64,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "deferlow",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-23",
          "varname": "rec_unload",
          "maxclass": "newobj",
          "patching_rect": [
            128,
            280,
            64,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "freebang",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "obj-24",
          "varname": "close_writer",
          "maxclass": "message",
          "patching_rect": [
            128,
            314,
            40,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "0",
          "outlettype": [
            "int"
          ]
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
            "obj-8",
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
            "obj-6",
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
            "obj-10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
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
            "obj-12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-11",
            2
          ],
          "destination": [
            "obj-13",
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
            "obj-6",
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
            "obj-14",
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
            "obj-14",
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
            "obj-6",
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
            "obj-19",
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
            "obj-14",
            0
          ]
        }
      }
    ]
  }
}
