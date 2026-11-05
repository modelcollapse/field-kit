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
      0,
      0,
      740,
      425
    ],
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "maxclass": "comment",
          "patching_rect": [
            0,
            0,
            188,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Mix effects",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            188,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-2",
          "maxclass": "comment",
          "patching_rect": [
            0,
            24,
            108,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Tone",
          "presentation": 1,
          "presentation_rect": [
            0,
            24,
            108,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-3",
          "maxclass": "comment",
          "patching_rect": [
            112,
            24,
            332,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Stereo echo",
          "presentation": 1,
          "presentation_rect": [
            112,
            24,
            332,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-4",
          "maxclass": "comment",
          "patching_rect": [
            448,
            24,
            220,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Room reverb",
          "presentation": 1,
          "presentation_rect": [
            448,
            24,
            220,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-5",
          "maxclass": "inlet",
          "patching_rect": [
            0,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 1,
          "comment": "Mix left",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-6",
          "maxclass": "inlet",
          "patching_rect": [
            144,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 2,
          "comment": "Mix right",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-7",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            320,
            105,
            22
          ],
          "numinlets": 2,
          "numoutlets": 2,
          "text": "gen~",
          "patcher": {
            "fileversion": 1,
            "appversion": {
              "major": 9,
              "minor": 2,
              "revision": 0,
              "architecture": "arm64",
              "modernui": 1
            },
            "classnamespace": "dsp.gen",
            "rect": [
              0,
              0,
              680,
              600
            ],
            "boxes": [
              {
                "box": {
                  "id": "obj-1",
                  "maxclass": "newobj",
                  "patching_rect": [
                    40,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 1",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-2",
                  "maxclass": "newobj",
                  "patching_rect": [
                    110,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 2",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-3",
                  "maxclass": "codebox",
                  "patching_rect": [
                    40,
                    86,
                    600,
                    420
                  ],
                  "numinlets": 2,
                  "numoutlets": 2,
                  "code": "Param enabled(0);\nParam tone(0);\nParam echo(20);\nParam time_ms(310);\nParam repeats(28);\nParam space(18);\nParam decay(1.7);\n\nHistory fxMix(0);\nHistory toneMix(0);\nHistory echoMix(0.20);\nHistory echoTime(310);\nHistory echoRepeats(0.28);\nHistory spaceMix(0.18);\nHistory roomDecay(1.7);\nHistory toneLowL(0);\nHistory toneLowR(0);\nHistory echoLowL(0);\nHistory echoLowR(0);\nHistory roomLowA(0);\nHistory roomLowB(0);\nHistory roomLowC(0);\nHistory roomLowD(0);\n\nDelay echoLineL(262144, interp=\"linear\");\nDelay echoLineR(262144, interp=\"linear\");\nDelay roomDiffuserL(4096);\nDelay roomDiffuserR(4096);\nDelay roomLineA(32768);\nDelay roomLineB(32768);\nDelay roomLineC(32768);\nDelay roomLineD(32768);\n\ncontrolRamp = 1 - exp(-1 / (0.020 * samplerate));\ntimeRamp = 1 - exp(-1 / (0.060 * samplerate));\nbypassStep = 1 / (0.020 * samplerate);\nfxMix = clamp(clamp(enabled, 0, 1), fxMix - bypassStep, fxMix + bypassStep);\ntoneMix = mix(toneMix, clamp(tone * 0.01, -1, 1), controlRamp);\nechoMix = mix(echoMix, clamp(echo * 0.01, 0, 1), controlRamp);\nechoTime = mix(echoTime, clamp(time_ms, 45, 850), timeRamp);\nechoRepeats = mix(echoRepeats, clamp(repeats * 0.01, 0, 0.78), controlRamp);\nspaceMix = mix(spaceMix, clamp(space * 0.01, 0, 1), controlRamp);\nroomDecay = mix(roomDecay, clamp(decay, 0.25, 5), controlRamp);\n\n// Tone tilts around 1.2 kHz. At zero the direct signal passes through.\ntoneCutoff = 1 - exp(-7539.822369 / samplerate);\ntoneLowL = mix(toneLowL, in1, toneCutoff);\ntoneLowR = mix(toneLowR, in2, toneCutoff);\ndark = max(-toneMix, 0) * 0.75;\nbright = max(toneMix, 0) * 0.75;\ntoneL = in1 - dark * (in1 - toneLowL) - bright * toneLowL;\ntoneR = in2 - dark * (in2 - toneLowR) - bright * toneLowR;\n\n// A slight difference in times and crossfeed opens up the repeats in stereo.\nsamplesPerMs = samplerate * 0.001;\nechoTapL = echoLineL.read(clamp(echoTime * samplesPerMs, 1, 262141));\nechoTapR = echoLineR.read(clamp(echoTime * 1.17 * samplesPerMs, 1, 262141));\nechoCutoff = 1 - exp(-28274.33388 / samplerate);\nechoLowL = mix(echoLowL, echoTapL, echoCutoff);\nechoLowR = mix(echoLowR, echoTapR, echoCutoff);\nechoLineL.write(toneL + echoRepeats * mix(echoLowL, echoLowR, 0.25));\nechoLineR.write(toneR + echoRepeats * mix(echoLowR, echoLowL, 0.25));\nechoWet = echoMix * 0.52;\nechoTrim = 1 - echoRepeats * 0.75;\nechoL = toneL * (1 - 0.35 * echoWet) + echoTapL * echoWet * echoTrim;\nechoR = toneR * (1 - 0.35 * echoWet) + echoTapR * echoWet * echoTrim;\n\n// Decorrelate the stereo input before it reaches the four-line room network.\ndiffTapL = roomDiffuserL.read(clamp(6.7 * samplesPerMs, 1, 4093));\ndiffTapR = roomDiffuserR.read(clamp(9.1 * samplesPerMs, 1, 4093));\ndiffL = diffTapL - 0.55 * echoL;\ndiffR = diffTapR - 0.55 * echoR;\nroomDiffuserL.write(echoL + 0.55 * diffL);\nroomDiffuserR.write(echoR + 0.55 * diffR);\n\nroomTapA = roomLineA.read(clamp(29.7 * samplesPerMs, 1, 32765));\nroomTapB = roomLineB.read(clamp(37.1 * samplesPerMs, 1, 32765));\nroomTapC = roomLineC.read(clamp(41.1 * samplesPerMs, 1, 32765));\nroomTapD = roomLineD.read(clamp(53.9 * samplesPerMs, 1, 32765));\nroomCutoff = 1 - exp(-17592.91886 / samplerate);\nroomLowA = mix(roomLowA, roomTapA, roomCutoff);\nroomLowB = mix(roomLowB, roomTapB, roomCutoff);\nroomLowC = mix(roomLowC, roomTapC, roomCutoff);\nroomLowD = mix(roomLowD, roomTapD, roomCutoff);\n\n// The normalized Hadamard matrix preserves energy. Per-line attenuation\n// follows the requested decay time, so the loop stays below unity gain.\nroomLoss = -0.006907755279 / roomDecay;\nfeedA = (roomLowA + roomLowB + roomLowC + roomLowD) * 0.5;\nfeedB = (roomLowA - roomLowB + roomLowC - roomLowD) * 0.5;\nfeedC = (roomLowA + roomLowB - roomLowC - roomLowD) * 0.5;\nfeedD = (roomLowA - roomLowB - roomLowC + roomLowD) * 0.5;\nroomLineA.write(diffL * 0.24 + feedA * exp(29.7 * roomLoss));\nroomLineB.write(diffR * 0.24 + feedB * exp(37.1 * roomLoss));\nroomLineC.write(diffL * 0.24 + feedC * exp(41.1 * roomLoss));\nroomLineD.write(-diffR * 0.24 + feedD * exp(53.9 * roomLoss));\nroomL = (roomTapA - roomTapB + roomTapC + roomTapD) * 0.5;\nroomR = (roomTapA + roomTapB - roomTapC + roomTapD) * 0.5;\nwetL = echoL * (1 - 0.18 * spaceMix) + roomL * spaceMix * 0.70;\nwetR = echoR * (1 - 0.18 * spaceMix) + roomR * spaceMix * 0.70;\n\n// The bypass branch has no filter, gain, or delay.\nout1 = mix(in1, wetL, fxMix);\nout2 = mix(in2, wetR, fxMix);\n",
                  "outlettype": [
                    "",
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-4",
                  "maxclass": "newobj",
                  "patching_rect": [
                    40,
                    545,
                    48,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "text": "out 1"
                }
              },
              {
                "box": {
                  "id": "obj-5",
                  "maxclass": "newobj",
                  "patching_rect": [
                    110,
                    545,
                    48,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "text": "out 2"
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
                    "obj-2",
                    0
                  ],
                  "destination": [
                    "obj-3",
                    1
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
                    "obj-3",
                    1
                  ],
                  "destination": [
                    "obj-5",
                    0
                  ]
                }
              }
            ],
            "description": "Tone tilt, crossfed stereo echo, and a damped stereo room"
          },
          "varname": "fk_fx_dsp",
          "outlettype": [
            "signal",
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-8",
          "maxclass": "outlet",
          "patching_rect": [
            0,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 1,
          "comment": "Effects left",
          "outlettype": []
        }
      },
      {
        "box": {
          "id": "obj-9",
          "maxclass": "outlet",
          "patching_rect": [
            144,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 2,
          "comment": "Effects right",
          "outlettype": []
        }
      },
      {
        "box": {
          "id": "obj-10",
          "maxclass": "live.text",
          "patching_rect": [
            528,
            0,
            140,
            20
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "mode": 1,
          "text": "Enable FX",
          "texton": "FX on",
          "varname": "fx_enabled",
          "hint": "Switch the entire mix effects chain in or out.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "FX enabled",
              "parameter_shortname": "FX",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1,
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
            528,
            0,
            140,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-11",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            265,
            108,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend enabled"
        }
      },
      {
        "box": {
          "id": "obj-12",
          "maxclass": "live.dial",
          "patching_rect": [
            0,
            48,
            108,
            68
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "varname": "fx_tone",
          "hint": "Turn left to darken and right to brighten.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Tone tilt",
              "parameter_shortname": "Tilt",
              "parameter_type": 1,
              "parameter_mmin": -100,
              "parameter_mmax": 100,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            48,
            108,
            68
          ]
        }
      },
      {
        "box": {
          "id": "obj-13",
          "maxclass": "newobj",
          "patching_rect": [
            122,
            265,
            108,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend tone"
        }
      },
      {
        "box": {
          "id": "obj-14",
          "maxclass": "live.dial",
          "patching_rect": [
            112,
            48,
            108,
            68
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "varname": "fx_echo",
          "hint": "Amount of stereo echo.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Echo mix",
              "parameter_shortname": "Mix %",
              "parameter_type": 1,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                20
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            48,
            108,
            68
          ]
        }
      },
      {
        "box": {
          "id": "obj-15",
          "maxclass": "newobj",
          "patching_rect": [
            240,
            265,
            108,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend echo"
        }
      },
      {
        "box": {
          "id": "obj-16",
          "maxclass": "live.dial",
          "patching_rect": [
            224,
            48,
            108,
            68
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "varname": "fx_time_ms",
          "hint": "Delay time in milliseconds.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Echo time",
              "parameter_shortname": "Time ms",
              "parameter_type": 1,
              "parameter_mmin": 45,
              "parameter_mmax": 850,
              "parameter_initial": [
                310
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            224,
            48,
            108,
            68
          ]
        }
      },
      {
        "box": {
          "id": "obj-17",
          "maxclass": "newobj",
          "patching_rect": [
            358,
            265,
            108,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend time_ms"
        }
      },
      {
        "box": {
          "id": "obj-18",
          "maxclass": "live.dial",
          "patching_rect": [
            336,
            48,
            108,
            68
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "varname": "fx_repeats",
          "hint": "How long the echo repeats.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Echo feedback",
              "parameter_shortname": "Feedback %",
              "parameter_type": 1,
              "parameter_mmin": 0,
              "parameter_mmax": 78,
              "parameter_initial": [
                28
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            336,
            48,
            108,
            68
          ]
        }
      },
      {
        "box": {
          "id": "obj-19",
          "maxclass": "newobj",
          "patching_rect": [
            476,
            265,
            108,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend repeats"
        }
      },
      {
        "box": {
          "id": "obj-20",
          "maxclass": "live.dial",
          "patching_rect": [
            448,
            48,
            108,
            68
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "varname": "fx_space",
          "hint": "Amount of room reverb.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Room mix",
              "parameter_shortname": "Mix %",
              "parameter_type": 1,
              "parameter_mmin": 0,
              "parameter_mmax": 100,
              "parameter_initial": [
                18
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1
            }
          },
          "outlettype": [
            "float",
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            448,
            48,
            108,
            68
          ]
        }
      },
      {
        "box": {
          "id": "obj-21",
          "maxclass": "newobj",
          "patching_rect": [
            594,
            265,
            108,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend space"
        }
      },
      {
        "box": {
          "id": "obj-22",
          "maxclass": "live.dial",
          "patching_rect": [
            560,
            48,
            108,
            68
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "showname": 1,
          "shownumber": 1,
          "varname": "fx_decay",
          "hint": "Reverb tail length in seconds.",
          "parameter_enable": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Room decay",
              "parameter_shortname": "Decay s",
              "parameter_type": 0,
              "parameter_mmin": 0.25,
              "parameter_mmax": 5,
              "parameter_initial": [
                1.7
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1,
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
            560,
            48,
            108,
            68
          ]
        }
      },
      {
        "box": {
          "id": "obj-23",
          "maxclass": "newobj",
          "patching_rect": [
            712,
            265,
            108,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend decay"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-5",
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
            1
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
            "obj-7",
            1
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
            "obj-10",
            0
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
            "obj-7",
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
            "obj-13",
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
            "obj-7",
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
            "obj-7",
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
            "obj-7",
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
            "obj-19",
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
            "obj-7",
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
            "obj-7",
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
            "obj-7",
            0
          ]
        }
      }
    ],
    "openinpresentation": 1,
    "gridsize": [
      8,
      8
    ],
    "description": "Stereo mix effects for FIELD KIT"
  }
}
