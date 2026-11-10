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
      1040,
      555
    ],
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "maxclass": "panel",
          "patching_rect": [
            0,
            23,
            108,
            95
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "surface_fx_tone",
          "background": 1,
          "ignoreclick": 1,
          "border": 0,
          "rounded": 7,
          "bgcolor": [
            0.13,
            0.17,
            0.23,
            1
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            23,
            108,
            95
          ]
        }
      },
      {
        "box": {
          "id": "obj-2",
          "maxclass": "panel",
          "patching_rect": [
            112,
            23,
            332,
            95
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "surface_fx_echo",
          "background": 1,
          "ignoreclick": 1,
          "border": 0,
          "rounded": 7,
          "bgcolor": [
            0.13,
            0.17,
            0.23,
            1
          ],
          "presentation": 1,
          "presentation_rect": [
            112,
            23,
            332,
            95
          ]
        }
      },
      {
        "box": {
          "id": "obj-3",
          "maxclass": "panel",
          "patching_rect": [
            448,
            23,
            220,
            95
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "surface_fx_room",
          "background": 1,
          "ignoreclick": 1,
          "border": 0,
          "rounded": 7,
          "bgcolor": [
            0.13,
            0.17,
            0.23,
            1
          ],
          "presentation": 1,
          "presentation_rect": [
            448,
            23,
            220,
            95
          ]
        }
      },
      {
        "box": {
          "id": "obj-4",
          "maxclass": "comment",
          "patching_rect": [
            0,
            0,
            82,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Main FX",
          "fontsize": 16,
          "fontface": 1,
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            82,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-5",
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
          "id": "obj-6",
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
          "id": "obj-7",
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
          "id": "obj-8",
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
          "id": "obj-9",
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
          "id": "obj-10",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            320,
            105,
            22
          ],
          "numinlets": 12,
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
              880,
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
                  "numinlets": 12,
                  "numoutlets": 8,
                  "code": "Param enabled(0);\nParam send_mode(0);\nParam tone(0);\nParam echo(20);\nParam time_ms(310);\nParam repeats(28);\nParam space(18);\nParam decay(1.7);\n\nHistory fxMix(0);\nHistory sendBlend(0);\nHistory toneMix(0);\nHistory echoMix(0.20);\nHistory echoTime(310);\nHistory echoNextTime(310);\nHistory echoTimeBlend(1);\nHistory echoTimeMod(0);\nHistory echoRepeats(0.28);\nHistory spaceMix(0.18);\nHistory roomDecay(1.7);\nHistory toneLowL(0);\nHistory toneLowR(0);\nHistory echoLowL(0);\nHistory echoLowR(0);\nHistory roomLowA(0);\nHistory roomLowB(0);\nHistory roomLowC(0);\nHistory roomLowD(0);\n\nDelay echoLineL(262144, interp=\"linear\");\nDelay echoLineR(262144, interp=\"linear\");\nDelay roomDiffuserL(4096);\nDelay roomDiffuserR(4096);\nDelay roomLineA(32768);\nDelay roomLineB(32768);\nDelay roomLineC(32768);\nDelay roomLineD(32768);\n\ncontrolRamp = 1 - exp(-1 / (0.020 * samplerate));\ntimeRamp = 1 - exp(-1 / (0.060 * samplerate));\nsamplesPerMs = samplerate * 0.001;\nbypassStep = 1 / (0.020 * samplerate);\nfxMix = clamp(clamp(enabled, 0, 1), fxMix - bypassStep, fxMix + bypassStep);\nsendBlend = clamp(clamp(send_mode, 0, 1), sendBlend - bypassStep, sendBlend + bypassStep);\nfullMix = 1 - sendBlend;\ntoneMix = mix(toneMix, clamp(tone * 0.01 + in3, -1, 1), controlRamp);\nechoMix = mix(echoMix, clamp(echo * 0.01 + in4, 0, 1), controlRamp);\n// Changing the knob or recalling a pattern switches between two fixed taps.\nrequestedTime = clamp(time_ms, 45, 850);\nif (echoTimeBlend >= 1 && requestedTime != echoNextTime) {\n    echoTime = echoNextTime;\n    echoNextTime = requestedTime;\n    echoTimeBlend = 0;\n}\nechoTimeBlend = min(1, echoTimeBlend + 1 / (0.035 * samplerate));\nechoWeight = echoTimeBlend * echoTimeBlend * (3 - 2 * echoTimeBlend);\n// Cap the LFO offset and the delay-head motion per sample, including square waves.\ndelayStep = 0.25 / samplesPerMs;\nechoTimeMod = clamp(mix(echoTimeMod, clamp(in5, -1, 1) * 30, timeRamp),\n                    echoTimeMod - delayStep, echoTimeMod + delayStep);\noldDelayTime = clamp(echoTime + echoTimeMod, 45, 850);\nnewDelayTime = clamp(echoNextTime + echoTimeMod, 45, 850);\ndelayTime = mix(oldDelayTime, newDelayTime, echoWeight);\nechoRepeats = mix(echoRepeats, clamp(repeats * 0.01 + in6 * 0.78, 0, 0.78), controlRamp);\nspaceMix = mix(spaceMix, clamp(space * 0.01 + in7, 0, 1), controlRamp);\nroomDecay = mix(roomDecay, clamp(decay + in8 * 2, 0.25, 5), controlRamp);\n\n// Tone tilts around 1.2 kHz. At zero the direct signal passes through.\ntoneCutoff = 1 - exp(-7539.822369 / samplerate);\ntoneLowL = mix(toneLowL, in1, toneCutoff);\ntoneLowR = mix(toneLowR, in2, toneCutoff);\ndark = max(-toneMix, 0) * 0.75;\nbright = max(toneMix, 0) * 0.75;\ntoneL = in1 - dark * (in1 - toneLowL) - bright * toneLowL;\ntoneR = in2 - dark * (in2 - toneLowR) - bright * toneLowR;\n\n// A slight difference in times and crossfeed opens up the repeats in stereo.\noldTapL = echoLineL.read(clamp(oldDelayTime * samplesPerMs, 1, 262141));\noldTapR = echoLineR.read(clamp(oldDelayTime * 1.17 * samplesPerMs, 1, 262141));\nnewTapL = echoLineL.read(clamp(newDelayTime * samplesPerMs, 1, 262141));\nnewTapR = echoLineR.read(clamp(newDelayTime * 1.17 * samplesPerMs, 1, 262141));\nechoTapL = mix(oldTapL, newTapL, echoWeight);\nechoTapR = mix(oldTapR, newTapR, echoWeight);\nechoCutoff = 1 - exp(-28274.33388 / samplerate);\nechoLowL = mix(echoLowL, echoTapL, echoCutoff);\nechoLowR = mix(echoLowR, echoTapR, echoCutoff);\n// Move the effect inputs between the serial mix and the independent sends.\n// The existing delay histories keep ringing through a mode change.\nechoInputL = mix(toneL, in9, sendBlend);\nechoInputR = mix(toneR, in10, sendBlend);\nechoLineL.write(echoInputL + echoRepeats * mix(echoLowL, echoLowR, 0.25));\nechoLineR.write(echoInputR + echoRepeats * mix(echoLowR, echoLowL, 0.25));\nechoWet = echoMix * 0.52;\nechoTrim = 1 - echoRepeats * 0.75;\nechoDry = 1 - 0.35 * echoWet * fullMix;\nechoL = toneL * echoDry + echoTapL * echoWet * echoTrim;\nechoR = toneR * echoDry + echoTapR * echoWet * echoTrim;\n\n// Decorrelate the stereo input before it reaches the four-line room network.\nroomInputL = mix(echoL, in11, sendBlend);\nroomInputR = mix(echoR, in12, sendBlend);\ndiffTapL = roomDiffuserL.read(clamp(6.7 * samplesPerMs, 1, 4093));\ndiffTapR = roomDiffuserR.read(clamp(9.1 * samplesPerMs, 1, 4093));\ndiffL = diffTapL - 0.55 * roomInputL;\ndiffR = diffTapR - 0.55 * roomInputR;\nroomDiffuserL.write(roomInputL + 0.55 * diffL);\nroomDiffuserR.write(roomInputR + 0.55 * diffR);\n\nroomTapA = roomLineA.read(clamp(29.7 * samplesPerMs, 1, 32765));\nroomTapB = roomLineB.read(clamp(37.1 * samplesPerMs, 1, 32765));\nroomTapC = roomLineC.read(clamp(41.1 * samplesPerMs, 1, 32765));\nroomTapD = roomLineD.read(clamp(53.9 * samplesPerMs, 1, 32765));\nroomCutoff = 1 - exp(-17592.91886 / samplerate);\nroomLowA = mix(roomLowA, roomTapA, roomCutoff);\nroomLowB = mix(roomLowB, roomTapB, roomCutoff);\nroomLowC = mix(roomLowC, roomTapC, roomCutoff);\nroomLowD = mix(roomLowD, roomTapD, roomCutoff);\n\n// The normalized Hadamard matrix preserves energy. Per-line attenuation\n// follows the requested decay time, so the loop stays below unity gain.\nroomLoss = -0.006907755279 / roomDecay;\nfeedA = (roomLowA + roomLowB + roomLowC + roomLowD) * 0.5;\nfeedB = (roomLowA - roomLowB + roomLowC - roomLowD) * 0.5;\nfeedC = (roomLowA + roomLowB - roomLowC - roomLowD) * 0.5;\nfeedD = (roomLowA - roomLowB - roomLowC + roomLowD) * 0.5;\nroomLineA.write(diffL * 0.24 + feedA * exp(29.7 * roomLoss));\nroomLineB.write(diffR * 0.24 + feedB * exp(37.1 * roomLoss));\nroomLineC.write(diffL * 0.24 + feedC * exp(41.1 * roomLoss));\nroomLineD.write(-diffR * 0.24 + feedD * exp(53.9 * roomLoss));\nroomL = (roomTapA - roomTapB + roomTapC + roomTapD) * 0.5;\nroomR = (roomTapA + roomTapB - roomTapC + roomTapD) * 0.5;\n// In Loop sends mode neither return attenuates the main signal.\nroomDry = 1 - 0.18 * spaceMix * fullMix;\nwetL = echoL * roomDry + roomL * spaceMix * 0.70;\nwetR = echoR * roomDry + roomR * spaceMix * 0.70;\n\n// The bypass branch has no filter, gain, or delay.\nout1 = mix(in1, wetL, fxMix);\nout2 = mix(in2, wetR, fxMix);\nout3 = toneMix;\nout4 = echoMix;\nout5 = delayTime;\nout6 = echoRepeats;\nout7 = spaceMix;\nout8 = roomDecay;\n",
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
                  "id": "obj-4",
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
                  "id": "obj-5",
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
                  "id": "obj-6",
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
                  "id": "obj-7",
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
                  "id": "obj-8",
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
                  "id": "obj-9",
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
                  "id": "obj-10",
                  "maxclass": "newobj",
                  "patching_rect": [
                    600,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 9",
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
                    670,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 10",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-12",
                  "maxclass": "newobj",
                  "patching_rect": [
                    740,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 11",
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
                    810,
                    32,
                    48,
                    22
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "text": "in 12",
                  "outlettype": [
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-14",
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
                  "id": "obj-15",
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
                  "id": "obj-16",
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
                  "id": "obj-17",
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
                  "id": "obj-18",
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
                  "id": "obj-19",
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
                  "id": "obj-20",
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
                  "id": "obj-21",
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
                    "obj-3",
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
                    "obj-4",
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
                    "obj-5",
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
                    "obj-6",
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
                    "obj-7",
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
                    "obj-8",
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
                    "obj-9",
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
                    "obj-10",
                    0
                  ],
                  "destination": [
                    "obj-1",
                    8
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
                    "obj-1",
                    9
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
                    10
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
                    "obj-1",
                    11
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
                    "obj-14",
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
                    "obj-15",
                    0
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
                    "obj-16",
                    0
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
                    "obj-17",
                    0
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
                    "obj-18",
                    0
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
                    "obj-19",
                    0
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
                    "obj-20",
                    0
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
                    "obj-21",
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
          "id": "obj-11",
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
          "id": "obj-12",
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
          "id": "obj-13",
          "maxclass": "inlet",
          "patching_rect": [
            792,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 10,
          "comment": "Echo send left",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-14",
          "maxclass": "inlet",
          "patching_rect": [
            864,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 11,
          "comment": "Echo send right",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-15",
          "maxclass": "inlet",
          "patching_rect": [
            936,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 12,
          "comment": "Room send left",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-16",
          "maxclass": "inlet",
          "patching_rect": [
            1008,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 13,
          "comment": "Room send right",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "obj-17",
          "maxclass": "umenu",
          "patching_rect": [
            206,
            0,
            100,
            20
          ],
          "numinlets": 1,
          "numoutlets": 3,
          "varname": "fx_mode",
          "items": [
            "Full mix",
            ",",
            "Loop sends"
          ],
          "parameter_enable": 0,
          "hint": "Feed Echo and Room from the full mix or the individual loop sends.",
          "outlettype": [
            "int",
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            206,
            0,
            100,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-18",
          "maxclass": "newobj",
          "patching_rect": [
            198,
            210,
            85,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "loadmess 0",
          "outlettype": [
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "obj-19",
          "maxclass": "newobj",
          "patching_rect": [
            198,
            240,
            134,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend send_mode"
        }
      },
      {
        "box": {
          "id": "obj-20",
          "maxclass": "live.text",
          "patching_rect": [
            86,
            0,
            112,
            20
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "fx_enabled",
          "mode": 1,
          "text": "Main FX · Off",
          "texton": "Main FX · On",
          "fontface": 1,
          "hint": "Turn Tone, Echo and Room on or off.",
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
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            86,
            0,
            112,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-21",
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
          "id": "obj-22",
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
          "id": "obj-23",
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
          "id": "obj-24",
          "maxclass": "comment",
          "patching_rect": [
            0,
            47,
            108,
            15
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "fx_label_tone",
          "text": "Tilt",
          "textjustification": 1,
          "fontsize": 10,
          "ignoreclick": 1,
          "presentation": 1,
          "presentation_rect": [
            0,
            47,
            108,
            15
          ]
        }
      },
      {
        "box": {
          "id": "obj-25",
          "maxclass": "live.dial",
          "patching_rect": [
            0,
            61,
            108,
            55
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "needlemode": 2,
          "showname": 0,
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
            61,
            108,
            55
          ]
        }
      },
      {
        "box": {
          "id": "obj-26",
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
          "id": "obj-27",
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
          "id": "obj-28",
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
          "id": "obj-29",
          "maxclass": "comment",
          "patching_rect": [
            112,
            47,
            108,
            15
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "fx_label_echo",
          "text": "Mix %",
          "textjustification": 1,
          "fontsize": 10,
          "ignoreclick": 1,
          "presentation": 1,
          "presentation_rect": [
            112,
            47,
            108,
            15
          ]
        }
      },
      {
        "box": {
          "id": "obj-30",
          "maxclass": "live.dial",
          "patching_rect": [
            112,
            61,
            108,
            55
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "needlemode": 1,
          "showname": 0,
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
            61,
            108,
            55
          ]
        }
      },
      {
        "box": {
          "id": "obj-31",
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
          "id": "obj-32",
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
          "id": "obj-33",
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
          "id": "obj-34",
          "maxclass": "comment",
          "patching_rect": [
            224,
            47,
            108,
            15
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "fx_label_time_ms",
          "text": "Time ms",
          "textjustification": 1,
          "fontsize": 10,
          "ignoreclick": 1,
          "presentation": 1,
          "presentation_rect": [
            224,
            47,
            108,
            15
          ]
        }
      },
      {
        "box": {
          "id": "obj-35",
          "maxclass": "live.dial",
          "patching_rect": [
            224,
            61,
            108,
            55
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "needlemode": 1,
          "showname": 0,
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
            61,
            108,
            55
          ]
        }
      },
      {
        "box": {
          "id": "obj-36",
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
          "id": "obj-37",
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
          "id": "obj-38",
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
          "id": "obj-39",
          "maxclass": "comment",
          "patching_rect": [
            336,
            47,
            108,
            15
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "fx_label_repeats",
          "text": "Feedback %",
          "textjustification": 1,
          "fontsize": 10,
          "ignoreclick": 1,
          "presentation": 1,
          "presentation_rect": [
            336,
            47,
            108,
            15
          ]
        }
      },
      {
        "box": {
          "id": "obj-40",
          "maxclass": "live.dial",
          "patching_rect": [
            336,
            61,
            108,
            55
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "needlemode": 1,
          "showname": 0,
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
            61,
            108,
            55
          ]
        }
      },
      {
        "box": {
          "id": "obj-41",
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
          "id": "obj-42",
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
          "id": "obj-43",
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
          "id": "obj-44",
          "maxclass": "comment",
          "patching_rect": [
            448,
            47,
            108,
            15
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "fx_label_space",
          "text": "Mix %",
          "textjustification": 1,
          "fontsize": 10,
          "ignoreclick": 1,
          "presentation": 1,
          "presentation_rect": [
            448,
            47,
            108,
            15
          ]
        }
      },
      {
        "box": {
          "id": "obj-45",
          "maxclass": "live.dial",
          "patching_rect": [
            448,
            61,
            108,
            55
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "needlemode": 1,
          "showname": 0,
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
            61,
            108,
            55
          ]
        }
      },
      {
        "box": {
          "id": "obj-46",
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
          "id": "obj-47",
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
          "id": "obj-48",
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
          "id": "obj-49",
          "maxclass": "comment",
          "patching_rect": [
            560,
            47,
            108,
            15
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "fx_label_decay",
          "text": "Decay s",
          "textjustification": 1,
          "fontsize": 10,
          "ignoreclick": 1,
          "presentation": 1,
          "presentation_rect": [
            560,
            47,
            108,
            15
          ]
        }
      },
      {
        "box": {
          "id": "obj-50",
          "maxclass": "live.dial",
          "patching_rect": [
            560,
            61,
            108,
            55
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "appearance": 3,
          "needlemode": 1,
          "showname": 0,
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
            61,
            108,
            55
          ]
        }
      },
      {
        "box": {
          "id": "obj-51",
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
      },
      {
        "box": {
          "id": "obj-52",
          "maxclass": "live.text",
          "patching_rect": [
            558,
            0,
            110,
            20
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "fx_pad_open",
          "mode": 0,
          "text": "FX pad…",
          "texton": "FX pad…",
          "parameter_enable": 0,
          "hint": "Blend two effects and record pad movements.",
          "outlettype": [
            "bang",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            558,
            0,
            110,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-53",
          "maxclass": "message",
          "patching_rect": [
            0,
            424,
            52,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "open",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-54",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            456,
            62,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "pcontrol"
        }
      },
      {
        "box": {
          "id": "obj-55",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            488,
            102,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "p Effects pad",
          "varname": "fx_pad_panel",
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
              440,
              372
            ],
            "boxes": [
              {
                "box": {
                  "id": "obj-1",
                  "maxclass": "inlet",
                  "patching_rect": [
                    16,
                    390,
                    26,
                    26
                  ],
                  "numinlets": 0,
                  "numoutlets": 1,
                  "index": 1
                }
              },
              {
                "box": {
                  "id": "obj-2",
                  "maxclass": "outlet",
                  "patching_rect": [
                    16,
                    478,
                    26,
                    26
                  ],
                  "numinlets": 1,
                  "numoutlets": 0,
                  "index": 1
                }
              },
              {
                "box": {
                  "id": "obj-3",
                  "maxclass": "jsui",
                  "patching_rect": [
                    0,
                    0,
                    440,
                    372
                  ],
                  "numinlets": 1,
                  "numoutlets": 1,
                  "background": 1,
                  "filename": "fk_fx_pad.js",
                  "varname": "fx_pad_canvas",
                  "border": 0,
                  "parameter_enable": 0,
                  "outlettype": [
                    ""
                  ],
                  "presentation": 1,
                  "presentation_rect": [
                    0,
                    0,
                    440,
                    372
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-4",
                  "maxclass": "newobj",
                  "patching_rect": [
                    16,
                    434,
                    127,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 3,
                  "text": "route xmenu ymenu",
                  "outlettype": [
                    "",
                    "",
                    ""
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-5",
                  "maxclass": "textbutton",
                  "patching_rect": [
                    426,
                    434,
                    68,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 3,
                  "mode": 0,
                  "outputmode": 1,
                  "varname": "fx_pad_close",
                  "text": "Close",
                  "texton": "Close",
                  "outlettype": [
                    "bang",
                    "",
                    "int"
                  ],
                  "presentation": 1,
                  "presentation_rect": [
                    350,
                    13,
                    66,
                    25
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-6",
                  "maxclass": "message",
                  "patching_rect": [
                    426,
                    478,
                    62,
                    22
                  ],
                  "numinlets": 2,
                  "numoutlets": 1,
                  "text": "wclose"
                }
              },
              {
                "box": {
                  "id": "obj-7",
                  "maxclass": "newobj",
                  "patching_rect": [
                    426,
                    516,
                    84,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 2,
                  "text": "thispatcher"
                }
              },
              {
                "box": {
                  "id": "obj-8",
                  "maxclass": "umenu",
                  "patching_rect": [
                    165,
                    434,
                    112,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 3,
                  "items": [
                    "Tone tilt",
                    ",",
                    "Echo mix",
                    ",",
                    "Room mix"
                  ],
                  "varname": "fx_pad_x",
                  "parameter_enable": 0,
                  "outlettype": [
                    "int",
                    "",
                    ""
                  ],
                  "presentation": 1,
                  "presentation_rect": [
                    50,
                    49,
                    152,
                    24
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-9",
                  "maxclass": "newobj",
                  "patching_rect": [
                    165,
                    478,
                    118,
                    22
                  ],
                  "numinlets": 2,
                  "numoutlets": 1,
                  "text": "prepend assign 0"
                }
              },
              {
                "box": {
                  "id": "obj-10",
                  "maxclass": "newobj",
                  "patching_rect": [
                    165,
                    516,
                    90,
                    22
                  ],
                  "numinlets": 2,
                  "numoutlets": 1,
                  "text": "prepend set"
                }
              },
              {
                "box": {
                  "id": "obj-11",
                  "maxclass": "newobj",
                  "patching_rect": [
                    165,
                    554,
                    85,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 1,
                  "text": "loadmess 1",
                  "outlettype": [
                    "int"
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-12",
                  "maxclass": "umenu",
                  "patching_rect": [
                    293,
                    434,
                    112,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 3,
                  "items": [
                    "Tone tilt",
                    ",",
                    "Echo mix",
                    ",",
                    "Room mix"
                  ],
                  "varname": "fx_pad_y",
                  "parameter_enable": 0,
                  "outlettype": [
                    "int",
                    "",
                    ""
                  ],
                  "presentation": 1,
                  "presentation_rect": [
                    244,
                    49,
                    172,
                    24
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-13",
                  "maxclass": "newobj",
                  "patching_rect": [
                    293,
                    478,
                    118,
                    22
                  ],
                  "numinlets": 2,
                  "numoutlets": 1,
                  "text": "prepend assign 1"
                }
              },
              {
                "box": {
                  "id": "obj-14",
                  "maxclass": "newobj",
                  "patching_rect": [
                    293,
                    516,
                    90,
                    22
                  ],
                  "numinlets": 2,
                  "numoutlets": 1,
                  "text": "prepend set"
                }
              },
              {
                "box": {
                  "id": "obj-15",
                  "maxclass": "newobj",
                  "patching_rect": [
                    293,
                    554,
                    85,
                    22
                  ],
                  "numinlets": 1,
                  "numoutlets": 1,
                  "text": "loadmess 2",
                  "outlettype": [
                    "int"
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-16",
                  "maxclass": "live.text",
                  "patching_rect": [
                    16,
                    586,
                    112,
                    25
                  ],
                  "numinlets": 1,
                  "numoutlets": 2,
                  "varname": "fx_pad_enabled",
                  "parameter_enable": 0,
                  "mode": 0,
                  "text": "Main FX · Off",
                  "texton": "Main FX · Off",
                  "fontface": 1,
                  "hint": "Turn Tone, Echo and Room on or off.",
                  "outlettype": [
                    "bang",
                    ""
                  ],
                  "presentation": 1,
                  "presentation_rect": [
                    208,
                    13,
                    134,
                    25
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-17",
                  "maxclass": "message",
                  "patching_rect": [
                    16,
                    617,
                    100,
                    22
                  ],
                  "numinlets": 2,
                  "numoutlets": 0,
                  "text": "fx_toggle"
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
                    "obj-4",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-4",
                    2
                  ],
                  "destination": [
                    "obj-2",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-5",
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
                    "obj-10",
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
                    "obj-8",
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
                    "obj-3",
                    0
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
                    "obj-14",
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
                    "obj-14",
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
                    "obj-2",
                    0
                  ]
                }
              }
            ],
            "title": "Effects pad",
            "openinpresentation": 1,
            "toolbarvisible": 0
          },
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-56",
          "maxclass": "inlet",
          "patching_rect": [
            720,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 9,
          "comment": "Stop pad motion",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-57",
          "maxclass": "newobj",
          "patching_rect": [
            0,
            520,
            204,
            22
          ],
          "numinlets": 1,
          "numoutlets": 5,
          "text": "route tone echo space fx_toggle",
          "outlettype": [
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
          "id": "obj-58",
          "maxclass": "newobj",
          "patching_rect": [
            164,
            424,
            82,
            22
          ],
          "numinlets": 3,
          "numoutlets": 1,
          "text": "pak 0 20 18",
          "outlettype": [
            "list"
          ]
        }
      },
      {
        "box": {
          "id": "obj-59",
          "maxclass": "newobj",
          "patching_rect": [
            164,
            456,
            105,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend source"
        }
      },
      {
        "box": {
          "id": "obj-60",
          "maxclass": "newobj",
          "patching_rect": [
            294,
            456,
            114,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend enabled"
        }
      },
      {
        "box": {
          "id": "obj-61",
          "maxclass": "live.text",
          "patching_rect": [
            440,
            0,
            110,
            20
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "stereo_field_open",
          "mode": 0,
          "text": "Stereo field…",
          "texton": "Stereo field…",
          "parameter_enable": 0,
          "hint": "Place and record the pan and level of each loop.",
          "outlettype": [
            "bang",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            440,
            0,
            110,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-62",
          "maxclass": "outlet",
          "patching_rect": [
            720,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 9,
          "comment": "Open Stereo field"
        }
      },
      {
        "box": {
          "id": "obj-63",
          "maxclass": "live.text",
          "patching_rect": [
            314,
            0,
            118,
            20
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "drifting_delay_open",
          "mode": 0,
          "text": "Drifting Memory",
          "texton": "Drifting Memory",
          "parameter_enable": 0,
          "hint": "Show Drifting Memory and its advanced controls in Mix.",
          "outlettype": [
            "bang",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            314,
            0,
            118,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-64",
          "maxclass": "outlet",
          "patching_rect": [
            792,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 10,
          "comment": "Show Drifting Memory in Mix"
        }
      },
      {
        "box": {
          "id": "obj-65",
          "maxclass": "inlet",
          "patching_rect": [
            1080,
            172,
            26,
            26
          ],
          "numinlets": 0,
          "numoutlets": 1,
          "index": 14,
          "comment": "Performance controls",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "obj-66",
          "maxclass": "outlet",
          "patching_rect": [
            1080,
            370,
            26,
            26
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "index": 11,
          "comment": "Current performance controls"
        }
      },
      {
        "box": {
          "id": "obj-67",
          "maxclass": "newobj",
          "patching_rect": [
            1080,
            204,
            300,
            22
          ],
          "numinlets": 1,
          "numoutlets": 5,
          "text": "route fx_mode fx_enabled fx_echo fx_space",
          "outlettype": [
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
          "id": "obj-68",
          "maxclass": "newobj",
          "patching_rect": [
            1080,
            240,
            145,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend fx_mode"
        }
      },
      {
        "box": {
          "id": "obj-69",
          "maxclass": "newobj",
          "patching_rect": [
            1080,
            270,
            145,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend fx_enabled"
        }
      },
      {
        "box": {
          "id": "obj-70",
          "maxclass": "newobj",
          "patching_rect": [
            1080,
            300,
            145,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend fx_echo"
        }
      },
      {
        "box": {
          "id": "obj-71",
          "maxclass": "newobj",
          "patching_rect": [
            1080,
            330,
            145,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "prepend fx_space"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-8",
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
            "obj-9",
            0
          ],
          "destination": [
            "obj-10",
            1
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
            "obj-10",
            1
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
            "obj-13",
            0
          ],
          "destination": [
            "obj-10",
            8
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
            "obj-10",
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
            "obj-10",
            10
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
            "obj-10",
            11
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
            "obj-10",
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
            "obj-10",
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
            "obj-10",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
            2
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
            "obj-10",
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
            "obj-10",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
            3
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
            "obj-10",
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
            "obj-10",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
            4
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
            "obj-35",
            0
          ],
          "destination": [
            "obj-36",
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
            "obj-10",
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
            "obj-10",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
            5
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
            "obj-10",
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
            "obj-10",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
            6
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
            "obj-10",
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
            "obj-10",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
            7
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
            "obj-10",
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
            "obj-54",
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
            "obj-56",
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
            "obj-57",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-57",
            3
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
            "obj-57",
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
            "obj-58",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-57",
            1
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
            "obj-58",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-57",
            2
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
            "obj-58",
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
            "obj-55",
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
            "obj-55",
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
            "obj-65",
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
            "obj-66",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-67",
            1
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
            "obj-69",
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
            "obj-66",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-67",
            2
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
            "obj-66",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-67",
            3
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
            "obj-66",
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
