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
          "numinlets": 8,
          "numoutlets": 8,
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
                  "maxclass": "codebox",
                  "patching_rect": [
                    40,
                    86,
                    600,
                    420
                  ],
                  "numinlets": 8,
                  "numoutlets": 8,
                  "code": "Param enabled(0);\nParam tone(0);\nParam echo(20);\nParam time_ms(310);\nParam repeats(28);\nParam space(18);\nParam decay(1.7);\n\nHistory fxMix(0);\nHistory toneMix(0);\nHistory echoMix(0.20);\nHistory echoTime(310);\nHistory echoNextTime(310);\nHistory echoTimeBlend(1);\nHistory echoTimeMod(0);\nHistory echoRepeats(0.28);\nHistory spaceMix(0.18);\nHistory roomDecay(1.7);\nHistory toneLowL(0);\nHistory toneLowR(0);\nHistory echoLowL(0);\nHistory echoLowR(0);\nHistory roomLowA(0);\nHistory roomLowB(0);\nHistory roomLowC(0);\nHistory roomLowD(0);\n\nDelay echoLineL(262144, interp=\"linear\");\nDelay echoLineR(262144, interp=\"linear\");\nDelay roomDiffuserL(4096);\nDelay roomDiffuserR(4096);\nDelay roomLineA(32768);\nDelay roomLineB(32768);\nDelay roomLineC(32768);\nDelay roomLineD(32768);\n\ncontrolRamp = 1 - exp(-1 / (0.020 * samplerate));\ntimeRamp = 1 - exp(-1 / (0.060 * samplerate));\nsamplesPerMs = samplerate * 0.001;\nbypassStep = 1 / (0.020 * samplerate);\nfxMix = clamp(clamp(enabled, 0, 1), fxMix - bypassStep, fxMix + bypassStep);\ntoneMix = mix(toneMix, clamp(tone * 0.01 + in3, -1, 1), controlRamp);\nechoMix = mix(echoMix, clamp(echo * 0.01 + in4, 0, 1), controlRamp);\n// Changing the knob or recalling a pattern switches between two fixed taps.\nrequestedTime = clamp(time_ms, 45, 850);\nif (echoTimeBlend >= 1 && requestedTime != echoNextTime) {\n    echoTime = echoNextTime;\n    echoNextTime = requestedTime;\n    echoTimeBlend = 0;\n}\nechoTimeBlend = min(1, echoTimeBlend + 1 / (0.035 * samplerate));\nechoWeight = echoTimeBlend * echoTimeBlend * (3 - 2 * echoTimeBlend);\n// Cap the LFO offset and the delay-head motion per sample, including square waves.\ndelayStep = 0.25 / samplesPerMs;\nechoTimeMod = clamp(mix(echoTimeMod, clamp(in5, -1, 1) * 30, timeRamp),\n                    echoTimeMod - delayStep, echoTimeMod + delayStep);\noldDelayTime = clamp(echoTime + echoTimeMod, 45, 850);\nnewDelayTime = clamp(echoNextTime + echoTimeMod, 45, 850);\ndelayTime = mix(oldDelayTime, newDelayTime, echoWeight);\nechoRepeats = mix(echoRepeats, clamp(repeats * 0.01 + in6 * 0.78, 0, 0.78), controlRamp);\nspaceMix = mix(spaceMix, clamp(space * 0.01 + in7, 0, 1), controlRamp);\nroomDecay = mix(roomDecay, clamp(decay + in8 * 2, 0.25, 5), controlRamp);\n\n// Tone tilts around 1.2 kHz. At zero the direct signal passes through.\ntoneCutoff = 1 - exp(-7539.822369 / samplerate);\ntoneLowL = mix(toneLowL, in1, toneCutoff);\ntoneLowR = mix(toneLowR, in2, toneCutoff);\ndark = max(-toneMix, 0) * 0.75;\nbright = max(toneMix, 0) * 0.75;\ntoneL = in1 - dark * (in1 - toneLowL) - bright * toneLowL;\ntoneR = in2 - dark * (in2 - toneLowR) - bright * toneLowR;\n\n// A slight difference in times and crossfeed opens up the repeats in stereo.\noldTapL = echoLineL.read(clamp(oldDelayTime * samplesPerMs, 1, 262141));\noldTapR = echoLineR.read(clamp(oldDelayTime * 1.17 * samplesPerMs, 1, 262141));\nnewTapL = echoLineL.read(clamp(newDelayTime * samplesPerMs, 1, 262141));\nnewTapR = echoLineR.read(clamp(newDelayTime * 1.17 * samplesPerMs, 1, 262141));\nechoTapL = mix(oldTapL, newTapL, echoWeight);\nechoTapR = mix(oldTapR, newTapR, echoWeight);\nechoCutoff = 1 - exp(-28274.33388 / samplerate);\nechoLowL = mix(echoLowL, echoTapL, echoCutoff);\nechoLowR = mix(echoLowR, echoTapR, echoCutoff);\nechoLineL.write(toneL + echoRepeats * mix(echoLowL, echoLowR, 0.25));\nechoLineR.write(toneR + echoRepeats * mix(echoLowR, echoLowL, 0.25));\nechoWet = echoMix * 0.52;\nechoTrim = 1 - echoRepeats * 0.75;\nechoL = toneL * (1 - 0.35 * echoWet) + echoTapL * echoWet * echoTrim;\nechoR = toneR * (1 - 0.35 * echoWet) + echoTapR * echoWet * echoTrim;\n\n// Decorrelate the stereo input before it reaches the four-line room network.\ndiffTapL = roomDiffuserL.read(clamp(6.7 * samplesPerMs, 1, 4093));\ndiffTapR = roomDiffuserR.read(clamp(9.1 * samplesPerMs, 1, 4093));\ndiffL = diffTapL - 0.55 * echoL;\ndiffR = diffTapR - 0.55 * echoR;\nroomDiffuserL.write(echoL + 0.55 * diffL);\nroomDiffuserR.write(echoR + 0.55 * diffR);\n\nroomTapA = roomLineA.read(clamp(29.7 * samplesPerMs, 1, 32765));\nroomTapB = roomLineB.read(clamp(37.1 * samplesPerMs, 1, 32765));\nroomTapC = roomLineC.read(clamp(41.1 * samplesPerMs, 1, 32765));\nroomTapD = roomLineD.read(clamp(53.9 * samplesPerMs, 1, 32765));\nroomCutoff = 1 - exp(-17592.91886 / samplerate);\nroomLowA = mix(roomLowA, roomTapA, roomCutoff);\nroomLowB = mix(roomLowB, roomTapB, roomCutoff);\nroomLowC = mix(roomLowC, roomTapC, roomCutoff);\nroomLowD = mix(roomLowD, roomTapD, roomCutoff);\n\n// The normalized Hadamard matrix preserves energy. Per-line attenuation\n// follows the requested decay time, so the loop stays below unity gain.\nroomLoss = -0.006907755279 / roomDecay;\nfeedA = (roomLowA + roomLowB + roomLowC + roomLowD) * 0.5;\nfeedB = (roomLowA - roomLowB + roomLowC - roomLowD) * 0.5;\nfeedC = (roomLowA + roomLowB - roomLowC - roomLowD) * 0.5;\nfeedD = (roomLowA - roomLowB - roomLowC + roomLowD) * 0.5;\nroomLineA.write(diffL * 0.24 + feedA * exp(29.7 * roomLoss));\nroomLineB.write(diffR * 0.24 + feedB * exp(37.1 * roomLoss));\nroomLineC.write(diffL * 0.24 + feedC * exp(41.1 * roomLoss));\nroomLineD.write(-diffR * 0.24 + feedD * exp(53.9 * roomLoss));\nroomL = (roomTapA - roomTapB + roomTapC + roomTapD) * 0.5;\nroomR = (roomTapA + roomTapB - roomTapC + roomTapD) * 0.5;\nwetL = echoL * (1 - 0.18 * spaceMix) + roomL * spaceMix * 0.70;\nwetR = echoR * (1 - 0.18 * spaceMix) + roomR * spaceMix * 0.70;\n\n// The bypass branch has no filter, gain, or delay.\nout1 = mix(in1, wetL, fxMix);\nout2 = mix(in2, wetR, fxMix);\nout3 = toneMix;\nout4 = echoMix;\nout5 = delayTime;\nout6 = echoRepeats;\nout7 = spaceMix;\nout8 = roomDecay;\n",
                  "outlettype": [
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-2",
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
                  "id": "obj-3",
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
                  "id": "obj-4",
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
              },
              {
                "box": {
                  "id": "obj-6",
                  "maxclass": "newobj",
                  "patching_rect": [
                    180,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 3",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-7",
                  "maxclass": "newobj",
                  "patching_rect": [
                    180,
                    545,
                    48,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "text": "out 3"
                }
              },
              {
                "box": {
                  "id": "obj-8",
                  "maxclass": "newobj",
                  "patching_rect": [
                    250,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 4",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-9",
                  "maxclass": "newobj",
                  "patching_rect": [
                    250,
                    545,
                    48,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "text": "out 4"
                }
              },
              {
                "box": {
                  "id": "obj-10",
                  "maxclass": "newobj",
                  "patching_rect": [
                    320,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 5",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-11",
                  "maxclass": "newobj",
                  "patching_rect": [
                    320,
                    545,
                    48,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "text": "out 5"
                }
              },
              {
                "box": {
                  "id": "obj-12",
                  "maxclass": "newobj",
                  "patching_rect": [
                    390,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 6",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-13",
                  "maxclass": "newobj",
                  "patching_rect": [
                    390,
                    545,
                    48,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "text": "out 6"
                }
              },
              {
                "box": {
                  "id": "obj-14",
                  "maxclass": "newobj",
                  "patching_rect": [
                    460,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 7",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-15",
                  "maxclass": "newobj",
                  "patching_rect": [
                    460,
                    545,
                    48,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "text": "out 7"
                }
              },
              {
                "box": {
                  "id": "obj-16",
                  "maxclass": "newobj",
                  "patching_rect": [
                    530,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 8",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-17",
                  "maxclass": "newobj",
                  "patching_rect": [
                    530,
                    545,
                    48,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "text": "out 8"
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
                    "obj-4",
                    0
                  ],
                  "destination": [
                    "obj-1",
                    1
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
                    "obj-5",
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
                    "obj-1",
                    2
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-1",
                    2
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
                    "obj-8",
                    0
                  ],
                  "destination": [
                    "obj-1",
                    3
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-1",
                    3
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
                    "obj-1",
                    4
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-1",
                    4
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
                    "obj-12",
                    0
                  ],
                  "destination": [
                    "obj-1",
                    5
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-1",
                    5
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
                    "obj-14",
                    0
                  ],
                  "destination": [
                    "obj-1",
                    6
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-1",
                    6
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
                    "obj-1",
                    7
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-1",
                    7
                  ],
                  "destination": [
                    "obj-17",
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
          "maxclass": "inlet",
          "patching_rect": [
            288,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 3,
          "comment": "Tone tilt modulation",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-13",
          "maxclass": "outlet",
          "patching_rect": [
            288,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 3,
          "comment": "Applied tone tilt",
          "outlettype": []
        }
      },
      {
        "box": {
          "id": "obj-14",
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
          "id": "obj-15",
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
          "id": "obj-16",
          "maxclass": "inlet",
          "patching_rect": [
            360,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 4,
          "comment": "Echo mix modulation",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-17",
          "maxclass": "outlet",
          "patching_rect": [
            360,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 4,
          "comment": "Applied echo mix",
          "outlettype": []
        }
      },
      {
        "box": {
          "id": "obj-18",
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
          "id": "obj-19",
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
          "id": "obj-20",
          "maxclass": "inlet",
          "patching_rect": [
            432,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 5,
          "comment": "Echo time modulation",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-21",
          "maxclass": "outlet",
          "patching_rect": [
            432,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 5,
          "comment": "Applied echo time",
          "outlettype": []
        }
      },
      {
        "box": {
          "id": "obj-22",
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
              "parameter_type": 0,
              "parameter_mmin": 45,
              "parameter_mmax": 850,
              "parameter_initial": [
                310
              ],
              "parameter_initial_enable": 1,
              "parameter_invisible": 1,
              "parameter_unitstyle": 9,
              "parameter_units": "%.0f"
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
          "id": "obj-23",
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
          "id": "obj-24",
          "maxclass": "inlet",
          "patching_rect": [
            504,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 6,
          "comment": "Echo feedback modulation",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-25",
          "maxclass": "outlet",
          "patching_rect": [
            504,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 6,
          "comment": "Applied echo feedback",
          "outlettype": []
        }
      },
      {
        "box": {
          "id": "obj-26",
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
          "id": "obj-27",
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
          "id": "obj-28",
          "maxclass": "inlet",
          "patching_rect": [
            576,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 7,
          "comment": "Room mix modulation",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-29",
          "maxclass": "outlet",
          "patching_rect": [
            576,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 7,
          "comment": "Applied room mix",
          "outlettype": []
        }
      },
      {
        "box": {
          "id": "obj-30",
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
          "id": "obj-31",
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
          "id": "obj-32",
          "maxclass": "inlet",
          "patching_rect": [
            648,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 8,
          "comment": "Room decay modulation",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-33",
          "maxclass": "outlet",
          "patching_rect": [
            648,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 8,
          "comment": "Applied room decay",
          "outlettype": []
        }
      },
      {
        "box": {
          "id": "obj-34",
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
          "id": "obj-35",
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
            "obj-7",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
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
            "obj-7",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            3
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
            "obj-7",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            4
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
      },
      {
        "patchline": {
          "source": [
            "obj-24",
            0
          ],
          "destination": [
            "obj-7",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            5
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
            "obj-7",
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
            "obj-7",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            6
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
            "obj-30",
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
            "obj-7",
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
            "obj-7",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            7
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
