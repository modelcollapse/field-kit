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
      80,
      505,
      222
    ],
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "varname": "ratio",
          "maxclass": "newobj",
          "numinlets": 0,
          "numoutlets": 1,
          "patching_rect": [
            320,
            28,
            42,
            22
          ],
          "text": "in 3",
          "outlettype": [
            "float"
          ]
        }
      },
      {
        "box": {
          "id": "obj-2",
          "varname": "initialize_clip",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "patching_rect": [
            320,
            64,
            117,
            22
          ],
          "text": "loadmess clip 1",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-3",
          "varname": "input_1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            24,
            28,
            68,
            22
          ],
          "text": "fftin~ 1",
          "outlettype": [
            "signal",
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-4",
          "varname": "shift_1",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 2,
          "patching_rect": [
            24,
            88,
            75,
            22
          ],
          "text": "gizmo~ 1.",
          "outlettype": [
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-5",
          "varname": "output_1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "patching_rect": [
            24,
            148,
            75,
            22
          ],
          "text": "fftout~ 1"
        }
      },
      {
        "box": {
          "id": "obj-6",
          "varname": "input_2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "patching_rect": [
            174,
            28,
            68,
            22
          ],
          "text": "fftin~ 2",
          "outlettype": [
            "signal",
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-7",
          "varname": "shift_2",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 2,
          "patching_rect": [
            174,
            88,
            75,
            22
          ],
          "text": "gizmo~ 1.",
          "outlettype": [
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-8",
          "varname": "output_2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "patching_rect": [
            174,
            148,
            75,
            22
          ],
          "text": "fftout~ 2"
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
            "obj-4",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
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
            "obj-5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-3",
            1
          ],
          "destination": [
            "obj-4",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-4",
            1
          ],
          "destination": [
            "obj-5",
            1
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
            "obj-7",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-2",
            0
          ],
          "destination": [
            "obj-7",
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
            "obj-7",
            0
          ]
        }
      },
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
            "obj-6",
            1
          ],
          "destination": [
            "obj-7",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            1
          ],
          "destination": [
            "obj-8",
            1
          ]
        }
      }
    ]
  }
}
