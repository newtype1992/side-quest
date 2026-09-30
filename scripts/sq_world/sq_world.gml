function sq_new_game() {
    var _cfg = sq_config();
    return {
        bounds:{left:44,top:116,right:600,bottom:306},
        cfg: _cfg, mode: "briefing", time: 0, kills: 0, damage_taken: 0,
        shots: 0, hits: 0, nav_time: 0, nav: [], effects: [], bullets: [],
        camera: {x: 0, y: 0, smooth_x: 0, smooth_y: 0},
        player: {x: 88, y: 180, radius: _cfg.player_radius, aim: 0,
            hp: _cfg.health, ammo: _cfg.magazine, reload: 0, fire: 0,
            roll: 0, roll_dir: 0, roll_cooldown: 0, hurt: 0, hype: 0,
            active: 0, flash: 0, stride: 0, anim: sq_animation_state()},
        obstacles: sq_environment_layout(),
        enemies: [sq_enemy(520, 136, "ranged", 0.8),
            sq_enemy(544, 264, "ranged", 1.7),
            sq_enemy(294, 128, "melee", 0),
            sq_enemy(312, 286, "melee", 0.4),
            sq_enemy(480, 184, "melee", 0.8)]
    };
}

/// First Bring Ice route proof. Each room state owns its enemies and props;
/// run resources remain on the shared player and game struct.
function sq_new_bring_ice_game() {
    var _g = sq_new_game();
    _g.rooms = [
        {name: "STORE ENTRANCE", kind: "entrance", visited: false, cleared: true,
            doors: [{side: "right", to: 1}], obstacles: sq_environment_layout(), enemies: []},
        {name: "LAST STOP AISLES", kind: "combat", visited: false, cleared: false,
            doors: [{side: "left", to: 0}, {side: "right", to: 2}],
            obstacles: _g.obstacles, enemies: _g.enemies},
        {name: "MANAGER ARENA", kind: "arena_staging", visited: false, cleared: true,
            doors: [{side: "left", to: 1}], obstacles: sq_environment_layout(), enemies: []}
    ];
    _g.room_id = -1;
    sq_room_enter(_g, 0);
    _g.mode = "briefing";
    return _g;
}

function sq_room_enter(_g, _next) {
    var _previous = _g.room_id;
    if (_previous >= 0) {
        _g.rooms[_previous].obstacles = _g.obstacles;
        _g.rooms[_previous].enemies = _g.enemies;
    }
    var _room = _g.rooms[_next];
    _g.room_id = _next;
    _room.visited = true;
    _g.obstacles = _room.obstacles;
    _g.enemies = _room.enemies;
    _g.bullets = [];
    _g.effects = [];
    _g.nav = [];
    _g.nav_time = 0;
    _g.player.x = 88; _g.player.y = 180;
    for (var _d = 0; _d < array_length(_room.doors); ++_d) {
        if (_room.doors[_d].to != _previous) continue;
        var _entry = sq_room_door_position(_room.doors[_d].side);
        _g.player.x = _entry.x + (_entry.x < 320 ? 18 : -18);
        _g.player.y = _entry.y + (_entry.y < 180 ? 18 : (_entry.y > 180 ? -18 : 0));
        break;
    }
    _g.player.roll = 0;
    _g.player.reload = 0;
    _g.mode = _room.kind == "combat" && !_room.cleared ? "combat" : "explore";
    _g.camera.x = 0; _g.camera.y = 0;
    _g.camera.smooth_x = 0; _g.camera.smooth_y = 0;
}

function sq_room_door_position(_side) {
    if (_side == "left") return {x: 88, y: 180};
    if (_side == "right") return {x: 560, y: 180};
    if (_side == "top") return {x: 320, y: 128};
    return {x: 320, y: 290};
}

function sq_room_at_door(_g, _door) {
    var _position = sq_room_door_position(_door.side);
    return point_distance(_g.player.x, _g.player.y, _position.x, _position.y) < 26;
}

function sq_room_try_interact(_g) {
    if (!variable_struct_exists(_g, "rooms") || _g.mode != "explore") return false;
    var _doors = _g.rooms[_g.room_id].doors;
    for (var _d = 0; _d < array_length(_doors); ++_d) {
        if (sq_room_at_door(_g, _doors[_d])) {
            sq_room_enter(_g, _doors[_d].to);
            return true;
        }
    }
    return false;
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
    return _x - _r < _g.bounds.left || _x + _r > _g.bounds.right || _y - _r < _g.bounds.top || _y + _r > _g.bounds.bottom
        || sq_obstacle_at(_g, _x, _y, _r) != -1;
}

function sq_move(_g, _actor, _dx, _dy) {
    var _steps = max(1, ceil(max(abs(_dx), abs(_dy)) / 2));
    _dx /= _steps; _dy /= _steps;
    repeat (_steps) {
        if (_actor == _g.player) sq_touch_clutter(_g, _actor.x + _dx, _actor.y, _actor.radius);
        if (!sq_blocked(_g, _actor.x + _dx, _actor.y, _actor.radius)) _actor.x += _dx;
        if (_actor == _g.player) sq_touch_clutter(_g, _actor.x, _actor.y + _dy, _actor.radius);
        if (!sq_blocked(_g, _actor.x, _actor.y + _dy, _actor.radius)) _actor.y += _dy;
    }
}

function sq_touch_clutter(_g, _x, _y, _radius) {
    for (var _i = 0; _i < array_length(_g.obstacles); ++_i) {
        var _o = _g.obstacles[_i];
        if (_o.kind != "clutter" || _o.hp <= 0) continue;
        var _cx = clamp(_x, _o.x1, _o.x2);
        var _cy = clamp(_y, _o.y1, _o.y2);
        if (sqr(_x - _cx) + sqr(_y - _cy) <= sqr(_radius))
            sq_destroy_clutter(_g, _o, _cx, _cy);
    }
}

function sq_destroy_clutter(_g, _o, _x, _y) {
    if (_o.hp <= 0) return;
    _o.hp = 0;
    _g.nav_time = 0;
    var _kind = _o.clutter == "paper" ? "paper" : (_o.clutter == "boxes" ? "splinter" : "bottle");
    sq_effect(_g, _x, _y, _kind, _kind == "paper" ? 7 : 11);
    sq_sound(_kind == "paper" ? "paper_break" : (_kind == "bottle" ? "bottle_break" : "prop_break"));
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
    var _life = _kind == "noise" ? 0.4 : ((_kind == "spark" || _kind == "splinter") && _size > 8 ? 0.34 : 0.24);
    array_push(_g.effects, {x: _x, y: _y, kind: _kind, size: _size, life: _life, total: _life});
}

function sq_update(_g, _input, _dt) {
    if (_g.mode == "dead") { sq_death_animation_tick(_g, clamp(_dt, 0, 1 / 30)); return; }
    if (_g.mode != "combat" && _g.mode != "explore") return;
    _dt = clamp(_dt, 0, 1 / 30);
    _g.time += _dt;
    _g.nav_time -= _dt;
    if (_g.mode == "combat" && _g.nav_time <= 0) { sq_build_nav(_g); _g.nav_time = 0.18; }
    for (var _i = array_length(_g.effects) - 1; _i >= 0; --_i) {
        _g.effects[_i].life -= _dt;
        if (_g.effects[_i].life <= 0) array_delete(_g.effects, _i, 1);
    }
    if (_g.mode == "explore") {
        _input.fire = false;
        _input.reload = false;
        _input.active = false;
    }
    sq_player_step(_g, _input, _dt);
    if (_g.mode == "combat") {
        sq_enemies_step(_g, _dt);
        sq_bullets_step(_g, _dt);
    }
    if (_g.player.hp <= 0) { _g.mode = "dead"; _g.bullets = []; }
    else if (_g.mode == "combat" && array_length(_g.enemies) == 0) {
        _g.bullets = [];
        if (variable_struct_exists(_g, "rooms")) {
            _g.rooms[_g.room_id].cleared = true;
            _g.mode = "explore";
        } else _g.mode = "cleared";
    }
    if (_g.mode == "explore" && _input.interact) sq_room_try_interact(_g);
}
