function sq_new_game() {
    var _cfg = sq_config();
    return {
        cfg: _cfg, mode: "briefing", time: 0, kills: 0, damage_taken: 0,
        shots: 0, hits: 0, nav_time: 0, nav: [], effects: [], bullets: [],
        player: {x: 88, y: 180, radius: _cfg.player_radius, aim: 0,
            hp: _cfg.health, ammo: _cfg.magazine, reload: 0, fire: 0,
            roll: 0, roll_dir: 0, roll_cooldown: 0, hurt: 0, hype: 0,
            active: 0, flash: 0, stride: 0, anim: sq_animation_state()},
        obstacles: [
            {x1: 176, y1: 108, x2: 224, y2: 152, kind: "shelf", hp: -1},
            {x1: 176, y1: 222, x2: 224, y2: 266, kind: "shelf", hp: -1},
            {x1: 376, y1: 108, x2: 424, y2: 152, kind: "shelf", hp: -1},
            {x1: 376, y1: 222, x2: 424, y2: 266, kind: "shelf", hp: -1},
            {x1: 290, y1: 178, x2: 310, y2: 198, kind: "crate", hp: 4}
        ],
        enemies: [sq_enemy(520, 98, "ranged", 0.8),
            sq_enemy(544, 264, "ranged", 1.7),
            sq_enemy(294, 84, "melee", 0),
            sq_enemy(312, 286, "melee", 0.4),
            sq_enemy(480, 184, "melee", 0.8)]
    };
}

function sq_enemy(_x, _y, _kind, _wait) {
    return {x: _x, y: _y, radius: 7, kind: _kind,
        hp: _kind == "melee" ? 6 : 8, max_hp: _kind == "melee" ? 6 : 8,
        state: "seek", timer: _wait, aim: 180, stun: 0, flash: 0, stride: 0};
}

function sq_obstacle_at(_g, _x, _y, _r) {
    for (var _i = 0; _i < array_length(_g.obstacles); ++_i) {
        var _o = _g.obstacles[_i];
        if (_o.hp == 0) continue;
        var _cx = clamp(_x, _o.x1, _o.x2);
        var _cy = clamp(_y, _o.y1, _o.y2);
        if (sqr(_x - _cx) + sqr(_y - _cy) <= sqr(_r)) return _i;
    }
    return -1;
}

function sq_blocked(_g, _x, _y, _r) {
    return _x - _r < 24 || _x + _r > 616 || _y - _r < 70 || _y + _r > 306
        || sq_obstacle_at(_g, _x, _y, _r) != -1;
}

function sq_move(_g, _actor, _dx, _dy) {
    var _steps = max(1, ceil(max(abs(_dx), abs(_dy)) / 2));
    _dx /= _steps; _dy /= _steps;
    repeat (_steps) {
        if (!sq_blocked(_g, _actor.x + _dx, _actor.y, _actor.radius)) _actor.x += _dx;
        if (!sq_blocked(_g, _actor.x, _actor.y + _dy, _actor.radius)) _actor.y += _dy;
    }
}

function sq_line_clear(_g, _x1, _y1, _x2, _y2, _r) {
    var _steps = max(1, ceil(point_distance(_x1, _y1, _x2, _y2) / 4));
    for (var _i = 0; _i <= _steps; ++_i) {
        if (sq_blocked(_g, lerp(_x1, _x2, _i / _steps), lerp(_y1, _y2, _i / _steps), _r)) return false;
    }
    return true;
}

/// Shared four-neighbour distance field prevents pursuers getting stuck on shelves.
function sq_build_nav(_g) {
    var _dist = array_create(40 * 23, -1);
    var _start = floor(_g.player.x / 16) + floor(_g.player.y / 16) * 40;
    var _queue = [_start];
    var _head = 0;
    _dist[_start] = 0;
    while (_head < array_length(_queue)) {
        var _cell = _queue[_head++];
        var _cx = _cell mod 40;
        var _cy = _cell div 40;
        var _next = [_cell - 1, _cell + 1, _cell - 40, _cell + 40];
        for (var _n = 0; _n < 4; ++_n) {
            var _index = _next[_n];
            if (_index < 0 || _index >= 920) continue;
            if (abs((_index mod 40) - _cx) + abs((_index div 40) - _cy) != 1) continue;
            if (_dist[_index] != -1) continue;
            if (sq_blocked(_g, (_index mod 40) * 16 + 8, (_index div 40) * 16 + 8, 8)) continue;
            _dist[_index] = _dist[_cell] + 1;
            array_push(_queue, _index);
        }
    }
    _g.nav = _dist;
}

function sq_seek_direction(_g, _e) {
    if (sq_line_clear(_g, _e.x, _e.y, _g.player.x, _g.player.y, _e.radius + 1))
        return point_direction(_e.x, _e.y, _g.player.x, _g.player.y);
    var _cell = clamp(floor(_e.x / 16) + floor(_e.y / 16) * 40, 0, 919);
    var _best = -1;
    var _value = 10000;
    var _next = [_cell, _cell - 1, _cell + 1, _cell - 40, _cell + 40];
    for (var _i = 0; _i < array_length(_next); ++_i) {
        var _index = _next[_i];
        if (_index < 0 || _index >= array_length(_g.nav)) continue;
        var _d = _g.nav[_index];
        if (_d >= 0 && _d < _value
            && sq_line_clear(_g, _e.x, _e.y, (_index mod 40) * 16 + 8, (_index div 40) * 16 + 8, _e.radius)) {
            _value = _d; _best = _index;
        }
    }
    if (_best == -1) return point_direction(_e.x, _e.y, _g.player.x, _g.player.y);
    return point_direction(_e.x, _e.y, (_best mod 40) * 16 + 8, (_best div 40) * 16 + 8);
}

function sq_effect(_g, _x, _y, _kind, _size) {
    array_push(_g.effects, {x: _x, y: _y, kind: _kind, size: _size, life: _kind == "noise" ? 0.4 : 0.24, total: _kind == "noise" ? 0.4 : 0.24});
}

function sq_update(_g, _input, _dt) {
    if (_g.mode == "dead") { sq_death_animation_tick(_g, clamp(_dt, 0, 1 / 30)); return; }
    if (_g.mode != "combat") return;
    _dt = clamp(_dt, 0, 1 / 30);
    _g.time += _dt;
    _g.nav_time -= _dt;
    if (_g.nav_time <= 0) { sq_build_nav(_g); _g.nav_time = 0.18; }
    for (var _i = array_length(_g.effects) - 1; _i >= 0; --_i) {
        _g.effects[_i].life -= _dt;
        if (_g.effects[_i].life <= 0) array_delete(_g.effects, _i, 1);
    }
    sq_player_step(_g, _input, _dt);
    sq_enemies_step(_g, _dt);
    sq_bullets_step(_g, _dt);
    if (_g.player.hp <= 0) { _g.mode = "dead"; _g.bullets = []; }
    else if (array_length(_g.enemies) == 0) { _g.mode = "cleared"; _g.bullets = []; }
}
