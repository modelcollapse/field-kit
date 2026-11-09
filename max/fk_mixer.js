// Keep mix visibility separate from transport so loops continue under mute and solo.
autowatch = 0;
inlets = 1;
outlets = 0;

var patch = this.patcher;
var mutes = [0, 0, 0, 0];
var solos = [0, 0, 0, 0];
var gains = [1, 1, 1, 1];
var OFF_COLOR = [0.24, 0.24, 0.24, 1];
var MUTE_COLOR = [0.95, 0.54, 0.28, 1];
var SOLO_COLOR = [0.38, 0.73, 0.96, 1];
var LIGHT_TEXT = [0.88, 0.88, 0.88, 1];
var DARK_TEXT = [0.09, 0.09, 0.09, 1];

function theme() {
    var colors = arrayfromargs(arguments);
    if (colors.length !== 8) return;
    OFF_COLOR = colors.slice(0, 4);
    LIGHT_TEXT = colors.slice(4, 8);
    update_mix();
}

function mute(voice, value) {
    if (valid_voice(voice)) {
        mutes[voice - 1] = value === undefined ? 1 - mutes[voice - 1] : (value ? 1 : 0);
        update_mix();
    }
}

function solo(voice, value) {
    if (valid_voice(voice)) {
        solos[voice - 1] = value === undefined ? 1 - solos[voice - 1] : (value ? 1 : 0);
        update_mix();
    }
}

function clear_solos() {
    solos = [0, 0, 0, 0];
    update_mix();
}

function recall_mutes(one, two, three, four) {
    mutes = [one, two, three, four].map(function (value) { return value ? 1 : 0; });
    clear_solos();
}

function dsp_enabled(enabled) {
    if (enabled) {
        gains.forEach(function (gain, index) {
            patch.getnamed("mixer_gain_" + (index + 1)).message(gain);
        });
    }
}

function valid_voice(voice) {
    return voice >= 1 && voice <= mutes.length && voice % 1 === 0;
}
valid_voice.local = 1;

function paint_button(name, enabled, label, color) {
    var button = patch.getnamed(name);
    var background = enabled ? color : OFF_COLOR;
    var foreground = enabled ? DARK_TEXT : LIGHT_TEXT;
    button.message("text", label);
    button.message("texton", label);
    button.message.apply(button, ["activebgcolor"].concat(background));
    button.message.apply(button, ["activebgoncolor"].concat(background));
    button.message.apply(button, ["activetextcolor"].concat(foreground));
    button.message.apply(button, ["activetextoncolor"].concat(foreground));
}
paint_button.local = 1;

function update_mix() {
    var soloing = solos.indexOf(1) !== -1;
    for (var index = 0; index < mutes.length; index++) {
        var voice = index + 1;
        paint_button("mixer_mute_" + voice, mutes[index], mutes[index] ? "Muted" : "Mute", MUTE_COLOR);
        paint_button("mixer_solo_" + voice, solos[index], solos[index] ? "Soloed" : "Solo", SOLO_COLOR);
        var gain = !mutes[index] && (!soloing || solos[index]) ? 1 : 0;
        if (gain !== gains[index]) {
            gains[index] = gain;
            patch.getnamed("mixer_gain_" + voice).message("list", gain, 12);
        }
    }
    patch.getnamed("mixer_clear_solo").message("active", soloing ? 1 : 0);
}
update_mix.local = 1;
