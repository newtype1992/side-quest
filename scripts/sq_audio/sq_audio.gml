/// Short original synthetic cues; replace with designed audio after the feel pass.
function sq_audio_init() {
    global.sq_audio = {};
    var _names = ["shot", "reload", "roll", "noise", "hurt", "hit", "defeat", "enemy"];
    var _frequencies = [190, 960, 250, 100, 85, 490, 320, 155];
    var _lengths = [0.065, 0.07, 0.15, 0.25, 0.18, 0.04, 0.12, 0.08];
    for (var _i = 0; _i < array_length(_names); ++_i) {
        var _count = floor(22050 * _lengths[_i]);
        var _buf = buffer_create(_count * 2, buffer_fixed, 2);
        var _phase = 0;
        for (var _s = 0; _s < _count; ++_s) {
            var _t = _s / _count;
            _phase += 2 * pi * _frequencies[_i] * (1 - _t * 0.55) / 22050;
            var _envelope = min(1, _s / 70) * sqr(1 - _t);
            var _value = (sin(_phase) + 0.25 * sin(_phase * 3.7)) * _envelope * 5000;
            buffer_write(_buf, buffer_s16, round(_value));
        }
        var _sound = audio_create_buffer_sound(_buf, buffer_s16, 22050, 0, _count * 2, audio_mono);
        variable_struct_set(global.sq_audio, _names[_i], {sound: _sound, buffer: _buf});
    }
}

function sq_sound(_name) {
    if (global.sq_quiet) return;
    var _entry = variable_struct_get(global.sq_audio, _name);
    audio_play_sound(_entry.sound, 0, false);
}

function sq_audio_cleanup() {
    audio_stop_all();
    var _names = variable_struct_get_names(global.sq_audio);
    for (var _i = 0; _i < array_length(_names); ++_i) {
        var _entry = variable_struct_get(global.sq_audio, _names[_i]);
        audio_free_buffer_sound(_entry.sound);
        buffer_delete(_entry.buffer);
    }
}
