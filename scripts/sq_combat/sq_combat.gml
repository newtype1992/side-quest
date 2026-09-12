function sq_player_step(_g, _input, _dt) {
    var _p = _g.player;
    var _c = _g.cfg;
    sq_animation_tick(_g, _input, _dt);
    _p.aim = _input.aim;
    _p.fire = max(0, _p.fire - _dt);
    _p.hurt = max(0, _p.hurt - _dt);
    _p.flash = max(0, _p.flash - _dt);
    _p.hype = max(0, _p.hype - _dt);
    _p.active = max(0, _p.active - _dt);
    _p.roll_cooldown = max(0, _p.roll_cooldown - _dt);
    if (_input.roll && _p.roll <= 0 && _p.roll_cooldown <= 0) {
        _p.roll = _c.roll_duration;
        _p.roll_cooldown = _c.roll_cooldown;
        _p.roll_dir = (_input.mx != 0 || _input.my != 0)
            ? point_direction(0, 0, _input.mx, _input.my) : _p.aim;
        _p.anim.roll_facing = sq_body_facing(sq_aim_direction(_p.roll_dir));
        _p.anim.noise = -1;
        sq_effect(_g, _p.x, _p.y, "roll", 12);
        sq_sound("roll");
    }
    if (_p.roll > 0) {
        var _travel = min(_dt, _p.roll);
        sq_move(_g, _p, lengthdir_x(_c.roll_speed * _travel, _p.roll_dir),
            lengthdir_y(_c.roll_speed * _travel, _p.roll_dir));
        _p.roll = max(0, _p.roll - _dt);
        return; // A committed roll pauses reload and prevents gun/ability use.
    }
    var _move = sq_vector(_input.mx, _input.my, 0);
    var _speed = _c.move_speed * (_p.hype > 0 ? _c.hype_move : 1);
    sq_move(_g, _p, _move.x * _speed * _dt, _move.y * _speed * _dt);
    _p.stride += point_distance(0, 0, _move.x, _move.y) * _dt * 10;
    if (_input.active && _p.active <= 0) sq_active(_g);
    if (_p.reload > 0) {
        _p.reload = max(0, _p.reload - _dt * (_p.hype > 0 ? _c.hype_reload : 1));
        if (_p.reload <= 0) { _p.ammo = _c.magazine; sq_sound("reload"); }
        return;
    }
    if ((_input.reload && _p.ammo < _c.magazine) || (_input.fire && _p.ammo <= 0)) {
        _p.reload = _c.reload_time;
        _p.anim.noise = -1;
        return;
    }
    if (_input.fire && _p.fire <= 0 && _p.ammo > 0) {
        _p.ammo -= 1; _p.fire = _c.fire_interval; _g.shots += 1;
        _p.anim.noise = -1;
        // Stop the muzzle segment at cover so the sprite cannot shoot through a shelf.
        var _origin = sq_weapon_origin(_g, true);
        sq_spawn_bullet(_g, _origin.x, _origin.y, _p.aim, _c.bullet_speed, "player", _c.bullet_damage);
        sq_sound("shot");
    }
}

function sq_active(_g) {
    var _p = _g.player;
    _p.active = _g.cfg.active_cooldown;
    _p.anim.noise = 0; _p.anim.noise_facing = sq_body_facing(sq_aim_direction(_p.aim));
    for (var _i = array_length(_g.bullets) - 1; _i >= 0; --_i) {
        var _b = _g.bullets[_i];
        if (_b.team == "enemy" && point_distance(_p.x, _p.y, _b.x, _b.y) <= _g.cfg.active_radius)
            array_delete(_g.bullets, _i, 1);
    }
    for (var _i = 0; _i < array_length(_g.enemies); ++_i) {
        var _e = _g.enemies[_i];
        if (point_distance(_p.x, _p.y, _e.x, _e.y) <= _g.cfg.active_radius) {
            var _dir = point_direction(_p.x, _p.y, _e.x, _e.y);
            sq_move(_g, _e, lengthdir_x(28, _dir), lengthdir_y(28, _dir));
            _e.stun = _g.cfg.active_stun; _e.state = "seek"; _e.timer = 0.5;
        }
    }
    sq_effect(_g, _p.x, _p.y, "noise", _g.cfg.active_radius);
    sq_sound("noise");
}

function sq_player_invulnerable(_g) {
    var _p = _g.player;
    return _p.hurt > 0 || (_p.roll > _g.cfg.roll_duration - _g.cfg.roll_invulnerable);
}

function sq_damage_player(_g, _amount) {
    if (_g.player.hp <= 0 || sq_player_invulnerable(_g)) return false;
    _g.player.hp = max(0, _g.player.hp - _amount);
    _g.player.hurt = _g.cfg.hurt_invulnerable;
    _g.player.flash = 0.14; _g.damage_taken += _amount;
    _g.player.anim.hit = 0;
    if (_g.player.hp <= 0) {
        _g.player.anim.death = 0;
        _g.player.anim.death_facing = sq_body_facing(sq_aim_direction(_g.player.aim));
        _g.player.anim.noise = -1; _g.player.anim.hit = -1;
    }
    sq_effect(_g, _g.player.x, _g.player.y, "hurt", 16);
    sq_sound("hurt");
    return true;
}

function sq_damage_enemy(_g, _index, _damage, _dir) {
    var _e = _g.enemies[_index];
    _e.hp -= _damage; _e.flash = 0.08;
    sq_move(_g, _e, lengthdir_x(3, _dir), lengthdir_y(3, _dir));
    sq_effect(_g, _e.x, _e.y, "hit", 6);
    if (_e.hp <= 0) {
        sq_effect(_g, _e.x, _e.y, "defeat", 14);
        array_delete(_g.enemies, _index, 1);
        _g.kills += 1;
        _g.player.hype = _g.cfg.hype_duration; // Refreshes, never stacks.
        _g.player.anim.hype = 0;
        sq_sound("defeat");
    } else sq_sound("hit");
}

function sq_spawn_bullet(_g, _x, _y, _angle, _speed, _team, _damage) {
    array_push(_g.bullets, {x: _x, y: _y, angle: _angle, vx: lengthdir_x(_speed, _angle),
        vy: lengthdir_y(_speed, _angle), team: _team, damage: _damage,
        radius: _team == "player" ? _g.cfg.bullet_radius : 3, life: 4});
}

function sq_bullets_step(_g, _dt) {
    for (var _i = array_length(_g.bullets) - 1; _i >= 0; --_i) {
        var _b = _g.bullets[_i];
        var _remove = false;
        _b.life -= _dt;
        var _steps = max(1, ceil(max(abs(_b.vx), abs(_b.vy)) * _dt / 2));
        for (var _s = 0; _s < _steps; ++_s) {
            _b.x += _b.vx * _dt / _steps; _b.y += _b.vy * _dt / _steps;
            if (sq_blocked(_g, _b.x, _b.y, _b.radius)) {
                var _cover = sq_obstacle_at(_g, _b.x, _b.y, _b.radius);
                if (_cover != -1 && _g.obstacles[_cover].hp > 0) {
                    var _o = _g.obstacles[_cover];
                    _o.hp = max(0, _o.hp - _b.damage);
                    if (_o.hp == 0) { sq_effect(_g, _b.x, _b.y, "defeat", 12); _g.nav_time = 0; }
                }
                sq_effect(_g, _b.x, _b.y, "hit", 4);
                _remove = true; break;
            }
            if (_b.team == "player") {
                for (var _e = array_length(_g.enemies) - 1; _e >= 0; --_e) {
                    var _enemy = _g.enemies[_e];
                    if (point_distance(_b.x, _b.y, _enemy.x, _enemy.y) <= _b.radius + _enemy.radius) {
                        _g.hits += 1;
                        sq_damage_enemy(_g, _e, _b.damage, _b.angle);
                        _remove = true; break;
                    }
                }
            } else if (point_distance(_b.x, _b.y, _g.player.x, _g.player.y) <= _b.radius + _g.player.radius) {
                // Invulnerable rolls pass through bullets; bullets remain a threat after the roll.
                if (!sq_player_invulnerable(_g)) { sq_damage_player(_g, _b.damage); _remove = true; }
            }
            if (_remove) break;
        }
        if (_remove || _b.life <= 0) array_delete(_g.bullets, _i, 1);
    }
}
