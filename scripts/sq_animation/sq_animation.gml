/// Hype Man v7: four body views, independent movement/actions, native pixel art.
function sq_animation_state() {
    return {idle: 0, move: 0, moving: false, backward: false, hit: -1,
        noise: -1, noise_facing: "right", death: -1, death_facing: "right",
        roll_facing: "right", hype: 0};
}

function sq_art_init() {
    var _file = file_text_open_read("hypeman/Hype-Man-Combat.json");
    var _text = "";
    while (!file_text_eof(_file)) { _text += file_text_read_string(_file); file_text_readln(_file); }
    file_text_close(_file);
    var _meta = json_parse(_text);
    var _tags = {};
    for (var _i = 0; _i < array_length(_meta.tags); ++_i) {
        var _tag = _meta.tags[_i]; variable_struct_set(_tags, _tag.name, _tag);
    }
    var _sprites = {};
    var _keys = ["body", "rear", "front", "body-impact", "body-flinch", "lower", "upper", "gesture-rear"];
    for (var _i = 0; _i < array_length(_keys); ++_i) {
        var _key = _keys[_i];
        var _sprite = sprite_add("hypeman/Hype-Man-" + _key + "-Atlas.png", 1, false, false, 0, 0);
        if (_sprite < 0) show_error("Unable to load Hype Man atlas: " + _key, true);
        variable_struct_set(_sprites, _key, _sprite);
    }
    _sprites.noise = sprite_add("hypeman/Hype-Man-Noise-Pulse.png", 8, false, false, 96, 96);
    _sprites.hype_rear = sprite_add("hypeman/Hype-Man-Hype-rear.png", 8, false, false, 24, 44);
    _sprites.hype_front = sprite_add("hypeman/Hype-Man-Hype-front.png", 8, false, false, 24, 44);
    if (_sprites.noise < 0 || _sprites.hype_rear < 0 || _sprites.hype_front < 0)
        show_error("Unable to load Hype Man effects", true);
    global.sq_art = {meta: _meta, tags: _tags, sprites: _sprites, surface: -1};
}

function sq_art_cleanup() {
    if (!variable_global_exists("sq_art")) return;
    var _a = global.sq_art;
    if (surface_exists(_a.surface)) surface_free(_a.surface);
    var _keys = variable_struct_get_names(_a.sprites);
    for (var _i = 0; _i < array_length(_keys); ++_i) {
        var _s = variable_struct_get(_a.sprites, _keys[_i]);
        if (sprite_exists(_s)) sprite_delete(_s);
    }
}

function sq_aim_direction(_angle) {
    var _i = floor((((_angle mod 360) + 360) mod 360 + 22.5) / 45) mod 8;
    var _directions = ["e", "ne", "n", "nw", "w", "sw", "s", "se"];
    return _directions[_i];
}

function sq_body_facing(_direction) {
    if (_direction == "n") return "back";
    if (_direction == "s") return "front";
    return (_direction == "w" || _direction == "nw" || _direction == "sw") ? "left" : "right";
}

function sq_animation_index(_name, _ms) {
    var _a = global.sq_art;
    var _tag = variable_struct_get(_a.tags, _name);
    var _sum = 0;
    for (var _i = _tag.from; _i <= _tag.to; ++_i) {
        _sum += _a.meta.frames[_i].duration;
        if (_ms < _sum) return _i;
    }
    return _tag.to;
}

function sq_animation_tick(_g, _input, _dt) {
    var _p = _g.player; var _a = _p.anim; var _ms = _dt * 1000;
    _a.idle = (_a.idle + _ms) mod 800;
    _a.hype = _p.hype > 0 ? (_a.hype + _ms) mod 640 : 0;
    if (_a.noise >= 0) { _a.noise += _ms; if (_a.noise >= 520) _a.noise = -1; }
    if (_a.hit >= 0) { _a.hit += _ms; if (_a.hit >= 150) _a.hit = -1; }
    var _speed = min(1, point_distance(0, 0, _input.mx, _input.my));
    _a.moving = _speed > 0.01 && _p.roll <= 0;
    _a.backward = _input.mx * lengthdir_x(1, _input.aim) + _input.my * lengthdir_y(1, _input.aim) < -0.1;
    if (_a.moving) _a.move = (_a.move + _ms * _speed * (_p.hype > 0 ? _g.cfg.hype_move : 1)) mod 600;
}

function sq_death_animation_tick(_g, _dt) {
    var _a = _g.player.anim;
    if (_a.death < 0) {
        _a.death = 0; _a.death_facing = sq_body_facing(sq_aim_direction(_g.player.aim));
    }
    _a.death = min(700, _a.death + max(0, _dt) * 1000);
    _a.noise = -1; _a.hit = -1; _a.moving = false;
}

function sq_animation_selection(_g) {
    var _p = _g.player; var _a = _p.anim;
    var _d = sq_aim_direction(_p.aim);
    var _b = sq_animation_index(_a.moving ? "walk_aim_" + _d : "aim_" + _d,
        _a.moving ? (_a.backward ? (600 - _a.move) mod 600 : _a.move) : _a.idle);
    var _action = sq_animation_index("aim_" + _d, _a.idle);
    if (_p.hp <= 0 || _g.mode == "dead")
        return {mode: "death", body: sq_animation_index("death_" + _a.death_facing, max(0, _a.death)), action: -1};
    if (_p.roll > 0) {
        var _time = (1 - _p.roll / _g.cfg.roll_duration) * 510;
        return {mode: "dodge", body: sq_animation_index("dodge_" + _a.roll_facing, _time), action: -1};
    }
    if (_p.reload > 0) _action = sq_animation_index("reload_" + _d, (1 - _p.reload / _g.cfg.reload_time) * 900);
    else if (_p.fire > 0) _action = sq_animation_index("shoot_" + _d, (1 - _p.fire / _g.cfg.fire_interval) * 170);
    if (_a.noise >= 0 && _p.reload <= 0 && _p.fire <= 0) {
        var _noise = sq_animation_index("noise_" + _a.noise_facing, _a.noise);
        // Keep the legs facing the gesture so turning aim cannot split the body.
        var _nd = "e";
        if (_a.noise_facing == "back") _nd = "n";
        else if (_a.noise_facing == "front") _nd = "s";
        else if (_a.noise_facing == "left") _nd = "w";
        _b = sq_animation_index(_a.moving ? "walk_aim_" + _nd : "aim_" + _nd, _a.moving ? _a.move : _a.idle);
        return {mode: "noise", body: _b, action: _noise};
    }
    return {mode: "combat", body: _b, action: _action};
}

function sq_weapon_origin(_g, _respect_cover) {
    var _p = _g.player;
    var _index = sq_animation_index("shoot_" + sq_aim_direction(_p.aim), 0);
    var _m = global.sq_art.meta.frames[_index].muzzle;
    var _x = _p.x - 24 + _m.x; var _y = _p.y - 44 + _m.y;
    if (!_respect_cover) return {x: _x, y: _y};
    var _steps = max(1, ceil(point_distance(_p.x, _p.y, _x, _y)));
    var _safe_x = _p.x; var _safe_y = _p.y;
    for (var _i = 1; _i <= _steps; ++_i) {
        var _next_x = lerp(_p.x, _x, _i / _steps); var _next_y = lerp(_p.y, _y, _i / _steps);
        if (sq_blocked(_g, _next_x, _next_y, _g.cfg.bullet_radius)) break;
        _safe_x = _next_x; _safe_y = _next_y;
    }
    return {x: _safe_x, y: _safe_y};
}

function sq_art_paint(_key, _index, _dx, _dy) {
    var _a = global.sq_art; var _f = _a.meta.frames[_index].frame;
    draw_sprite_part_ext(variable_struct_get(_a.sprites, _key), 0, _f.x, _f.y, 48, 48, _dx, _dy, 1, 1, c_white, 1);
}

function sq_hypeman_draw(_g) {
    var _p = _g.player; var _a = _p.anim; var _art = global.sq_art;
    var _sel = sq_animation_selection(_g);
    var _x = floor(_p.x); var _y = floor(_p.y);
    var _buff = _p.hype > 0 && _p.hp > 0;
    draw_set_colour($24140F); draw_ellipse(_x - 9, _y - 2, _x + 9, _y + 3, false);
    if (_buff) draw_sprite(_art.sprites.hype_rear, floor(_a.hype / 80), _x, _y);
    if (!surface_exists(_art.surface)) _art.surface = surface_create(48, 48);
    if (!surface_exists(_art.surface)) return;
    surface_set_target(_art.surface); draw_clear_alpha(c_black, 0);
    if (_sel.mode == "death" || _sel.mode == "dodge") sq_art_paint("body", _sel.body, 0, 0);
    else if (_sel.mode == "noise") {
        sq_art_paint("gesture-rear", _sel.action, 0, 0);
        sq_art_paint("lower", _sel.body, 0, 0); sq_art_paint("upper", _sel.action, 0, 0);
    } else {
        var _key = "body"; var _dx = 0; var _dy = 0;
        if (_a.hit >= 0 && _a.hit < 90) {
            _key = _a.hit < 40 ? "body-impact" : "body-flinch";
            var _face = sq_body_facing(sq_aim_direction(_p.aim));
            _dx = _face == "left" ? 1 : (_face == "right" ? -1 : 0);
            _dy = _face == "front" ? -1 : (_face == "back" ? 1 : 0);
        }
        var _bob = _art.meta.frames[_sel.body].overlayOffsetY;
        sq_art_paint("rear", _sel.action, _dx, _dy + _bob);
        sq_art_paint(_key, _sel.body, 0, 0);
        sq_art_paint("front", _sel.action, _dx, _dy + _bob);
    }
    if (_a.hit >= 0 && _a.hit < 40 && _p.hp > 0) {
        // Fill only the existing silhouette and preserve the surface alpha.
        gpu_set_blendmode_ext_sepalpha(bm_dest_alpha, bm_zero, bm_zero, bm_one);
        draw_set_colour($D5EEFA); draw_rectangle(0, 0, 47, 47, false);
        gpu_set_blendmode(bm_normal); draw_set_colour(c_white);
    }
    surface_reset_target(); draw_surface(_art.surface, _x - 24, _y - 44);
    if (_buff) draw_sprite(_art.sprites.hype_front, floor(_a.hype / 80), _x, _y);
}

function sq_noise_effect_draw(_fx) {
    var _ms = (1 - _fx.life / _fx.total) * 400;
    var _times = [40, 40, 40, 40, 60, 60, 60, 60]; var _sum = 0; var _frame = 7;
    for (var _i = 0; _i < 8; ++_i) { _sum += _times[_i]; if (_ms < _sum) { _frame = _i; break; } }
    draw_sprite_ext(global.sq_art.sprites.noise, _frame, floor(_fx.x), floor(_fx.y), _fx.size / 84, _fx.size / 84, 0, c_white, 1);
}

function sq_animation_tests() {
    var _g = sq_test_game(); var _in = sq_neutral_input();
    sq_check(global.sq_art.meta.frameCount == 304, "304 character frames loaded");
    sq_check(sq_body_facing(sq_aim_direction(90)) == "back" && sq_body_facing(sq_aim_direction(270)) == "front", "north and south select new body views");
    for (var _i = 0; _i < 8; ++_i) {
        _g.player.aim = _i * 45; var _s = sq_animation_selection(_g);
        sq_check(_s.body >= 0 && _s.action >= 0, "aim direction " + string(_i) + " has body and weapon art");
    }
    _in.mx = 1; _in.active = true; sq_player_step(_g, _in, 1 / 60);
    sq_check(_g.player.anim.noise == 0 && sq_animation_selection(_g).mode == "noise", "active triggers directional gesture while moving");
    _in.active = false; _in.fire = true; sq_player_step(_g, _in, 1 / 60);
    sq_check(_g.player.anim.noise == -1 && _g.shots == 1, "shooting interrupts cosmetic gesture immediately");
    sq_check(array_length(_g.effects) >= 1, "ability wave survives interrupted gesture");
    _g = sq_test_game(); _g.player.ammo = 3; _in = sq_neutral_input(); _in.reload = true;
    sq_player_step(_g, _in, 1 / 60); _in.reload = false; _in.roll = true; _in.my = -1;
    sq_player_step(_g, _in, 1 / 60); var _reload = _g.player.reload;
    sq_check(_g.player.anim.roll_facing == "back" && sq_animation_selection(_g).mode == "dodge", "northward roll uses back roll and overrides reload");
    _in.roll = false; sq_player_step(_g, _in, 1 / 60);
    sq_check(_g.player.reload == _reload, "reload timing remains paused during roll");
    _g = sq_test_game(); _g.player.aim = 270; _g.player.hp = 1; sq_damage_player(_g, 1); _g.mode = "dead";
    _g.player.aim = 90; sq_update(_g, sq_neutral_input(), 1 / 30);
    sq_check(_g.player.anim.death_facing == "front", "death captures facing at lethal hit");
    repeat (240) sq_update(_g, sq_neutral_input(), 1 / 30);
    var _last = variable_struct_get(global.sq_art.tags, "death_front").to;
    sq_check(sq_animation_selection(_g).body == _last && _g.player.anim.death == 700 && _g.time == 0, "corpse holds final frame without simulating combat");
    _g = sq_test_game();
    sq_check(_g.player.anim.death == -1 && _g.player.anim.noise == -1 && _g.player.anim.hit == -1, "restart resets all animation states");
    _g.player.x = 169; _g.player.y = 140; _g.player.aim = 0;
    var _m = sq_weapon_origin(_g, true);
    sq_check(_m.x < 176 && !sq_blocked(_g, _m.x, _m.y, 2), "muzzle stops before shelf instead of shooting through cover");
    _g = sq_test_game(); _in = sq_neutral_input(); _in.active = true;
    sq_player_step(_g, _in, 1 / 60); _in.active = false;
    repeat (32) sq_player_step(_g, _in, 1 / 60);
    sq_check(_g.player.anim.noise == -1 && sq_animation_selection(_g).mode == "combat", "ability returns to ready after 520 ms");
    _g.player.hype = 0.08;
    repeat (8) sq_player_step(_g, _in, 1 / 60);
    sq_check(_g.player.hype == 0 && _g.player.anim.hype == 0, "passive visual clock resets when the buff expires");
    _g.player.reload = 0.8; _g.player.anim.moving = true; _g.player.anim.hit = 20;
    var _selected = sq_animation_selection(_g);
    sq_check(_selected.mode == "combat" && _selected.action == sq_animation_index("reload_e", 100), "hit reaction preserves reload phase");
}

/// Deterministic render fixtures, entered only with the existing --capture flag.
function sq_animation_gallery(_scene) {
    draw_clear($402C20);
    sq_text(18, 18, "HYPE MAN / GAMEMAKER RENDER", $EED310, 2);
    sq_text(18, 44, string_upper(_scene), $BBC7D2, 1);
    var _angles = [0, 270, 180, 90];
    var _labels = ["RIGHT", "FRONT", "LEFT", "BACK"];
    for (var _i = 0; _i < 4; ++_i) {
        var _g = sq_test_game(); var _p = _g.player;
        _p.x = -100; _p.y = -100; _p.aim = _angles[_i];
        var _face = sq_body_facing(sq_aim_direction(_p.aim));
        _p.anim.moving = true; _p.anim.move = 200;
        if (_scene == "animation-noise") { _p.anim.noise = 170; _p.anim.noise_facing = _face; }
        if (_scene == "animation-fire") _p.fire = 0.15;
        if (_scene == "animation-reload") _p.reload = 0.46;
        if (_scene == "animation-roll") { _p.roll = 0.19; _p.anim.roll_facing = _face; }
        if (_scene == "animation-death") { _p.hp = 0; _g.mode = "dead"; _p.anim.death = 700; _p.anim.death_facing = _face; }
        if (_scene == "animation-hit") _p.anim.hit = 15;
        sq_hypeman_draw(_g);
        var _x = _i * 160 + 8; var _y = 100;
        sq_text(_x + 34, 78, _labels[_i], $BBC7D2, 1);
        if (_scene == "animation-hype")
            draw_sprite_ext(global.sq_art.sprites.hype_rear, 3, _x + 72, _y + 132, 3, 3, 0, c_white, 1);
        draw_surface_ext(global.sq_art.surface, _x, _y, 3, 3, 0, c_white, 1);
        if (_scene == "animation-hype")
            draw_sprite_ext(global.sq_art.sprites.hype_front, 3, _x + 72, _y + 132, 3, 3, 0, c_white, 1);
    }
    sq_text(18, 291, "48 X 48 NATIVE ART / 3X NEAREST PIXEL DISPLAY", $BBC7D2, 1);
    sq_text(18, 312, "ACTUAL ENGINE FRAMEBUFFER", $8C9EAF, 1);
}
