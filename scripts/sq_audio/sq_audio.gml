/// Compact original arcade cues: a pocket-pistol pop, store-scanner reload,
/// sneaker scrape, Hype Man call, and wood/metal cover impacts.
function sq_audio_init() {
    global.sq_audio = {};
    var _names = ["shot", "reload", "roll", "noise", "hurt", "hit", "defeat", "enemy", "prop_hit", "prop_break", "metal_hit", "metal_break", "paper_break", "bottle_break"];
    var _lengths = [0.11, 0.18, 0.24, 0.32, 0.20, 0.09, 0.29, 0.14, 0.09, 0.28, 0.11, 0.30, 0.13, 0.17];
    for (var _i = 0; _i < array_length(_names); ++_i) {
        var _count = floor(22050 * _lengths[_i]);
        var _buf = buffer_create(_count * 2, buffer_fixed, 2);
        var _phase = 0;
        var _noise_seed = 173 + _i * 137;
        var _soft_noise = 0;
        for (var _s = 0; _s < _count; ++_s) {
            var _t = _s / _count;
            _noise_seed = (_noise_seed * 16807) mod 2147483647;
            var _noise = (_noise_seed / 1073741823.5) - 1;
            _soft_noise = lerp(_soft_noise, _noise, 0.22);
            var _hz = 220;
            var _level = 0;
            var _envelope = min(1, _s / 45) * sqr(1 - _t);
            switch (_names[_i]) {
                case "shot":
                    _hz = 310 - 190 * _t;
                    _level = 0.65 * sign(sin(_phase)) + 0.35 * _noise * (1 - _t);
                    break;
                case "reload":
                    _hz = _t < 0.43 ? 700 : 1080;
                    _envelope = _t < 0.43 ? min(1, _s / 35) * (1 - _t) : min(1, (_t - 0.43) * 35) * (1 - _t);
                    _level = 0.7 * sin(_phase) + 0.3 * sign(sin(_phase));
                    break;
                case "roll":
                    _hz = 240 - 120 * _t;
                    _level = 0.58 * _soft_noise + 0.42 * sin(_phase);
                    _envelope = sin(pi * _t) * 0.7;
                    break;
                case "noise":
                    _hz = 190 + 390 * _t;
                    _level = 0.6 * sin(_phase) + 0.25 * sin(_phase * 1.5) + 0.15 * _soft_noise;
                    _envelope = sin(pi * _t) * 0.85;
                    break;
                case "hurt":
                    _hz = 180 - 90 * _t;
                    _level = 0.6 * sign(sin(_phase)) + 0.4 * _soft_noise;
                    break;
                case "hit":
                    _hz = 420 - 260 * _t;
                    _level = 0.55 * _noise + 0.45 * sin(_phase);
                    break;
                case "defeat":
                    _hz = _t < 0.33 ? 620 : (_t < 0.66 ? 465 : 310);
                    _level = 0.7 * sin(_phase) + 0.3 * sign(sin(_phase));
                    _envelope = 0.7 * (1 - _t);
                    break;
                case "enemy":
                    _hz = 560 - 180 * _t;
                    _level = 0.7 * sin(_phase) + 0.3 * sign(sin(_phase));
                    break;
                case "prop_hit":
                    _hz = 190 - 100 * _t;
                    _level = 0.7 * _soft_noise + 0.3 * sin(_phase);
                    break;
                case "prop_break":
                    _hz = 280 - 210 * _t;
                    _level = 0.65 * _soft_noise + 0.35 * sign(sin(_phase));
                    _envelope = min(1, _s / 30) * (1 - _t);
                    break;
                case "metal_hit":
                    _hz = 930 - 270 * _t;
                    _level = 0.65 * sin(_phase) + 0.25 * sin(_phase * 2.4) + 0.1 * _noise;
                    break;
                case "metal_break":
                    _hz = 790 - 600 * _t;
                    _level = 0.5 * sin(_phase) + 0.25 * sin(_phase * 2.3) + 0.25 * _soft_noise;
                    _envelope = min(1, _s / 30) * (1 - _t);
                    break;
                case "paper_break":
                    _hz = 360 - 140 * _t;
                    _level = 0.8 * _soft_noise + 0.2 * _noise;
                    _envelope = sin(pi * _t) * 0.55;
                    break;
                case "bottle_break":
                    _hz = 760 - 510 * _t;
                    _level = 0.45 * sin(_phase) + 0.35 * _soft_noise + 0.2 * _noise;
                    _envelope = min(1, _s / 25) * sqr(1 - _t);
                    break;
            }
            _phase += 2 * pi * _hz / 22050;
            buffer_write(_buf, buffer_s16, round(clamp(_level * _envelope * 11500, -32767, 32767)));
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
