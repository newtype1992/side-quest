function sq_enemies_step(_g, _dt) {
    for (var _i = 0; _i < array_length(_g.enemies); ++_i) {
        var _e = _g.enemies[_i];
        var _p = _g.player;
        _e.flash = max(0, _e.flash - _dt);
        if (_e.stun > 0) { _e.stun = max(0, _e.stun - _dt); continue; }
        _e.timer = max(0, _e.timer - _dt);
        var _distance = point_distance(_e.x, _e.y, _p.x, _p.y);
        if (_e.state == "tell") {
            if (_e.timer <= 0) {
                if (_e.kind == "ranged") {
                    for (var _fan = -1; _fan <= 1; ++_fan)
                        sq_spawn_bullet(_g, _e.x, _e.y, _e.aim + _fan * 13, 108, "enemy", 1);
                    _e.state = "recover"; _e.timer = 1.4;
                    sq_sound("enemy");
                } else { _e.state = "charge"; _e.timer = 0.24; }
            }
        } else if (_e.state == "charge") {
            sq_move(_g, _e, lengthdir_x(190 * _dt, _e.aim), lengthdir_y(190 * _dt, _e.aim));
            if (point_distance(_e.x, _e.y, _p.x, _p.y) < _e.radius + _p.radius + 2)
                sq_damage_player(_g, 1);
            if (_e.timer <= 0) { _e.state = "recover"; _e.timer = 0.7; }
        } else if (_e.state == "recover") {
            if (_e.timer <= 0) _e.state = "seek";
        } else {
            var _can_attack = (_e.kind == "melee" ? _distance < 56 : _distance < 200)
                && sq_line_clear(_g, _e.x, _e.y, _p.x, _p.y, 3);
            if (_can_attack && _e.timer <= 0) {
                _e.aim = point_direction(_e.x, _e.y, _p.x, _p.y);
                _e.state = "tell"; _e.timer = _e.kind == "melee" ? 0.4 : 0.6;
            } else {
                var _dir = sq_seek_direction(_g, _e);
                _e.aim = _dir;
                var _speed = _e.kind == "melee" ? 55 : 34;
                if (!_can_attack) {
                    sq_move(_g, _e, lengthdir_x(_speed * _dt, _dir), lengthdir_y(_speed * _dt, _dir));
                    _e.stride += _dt * 7;
                }
                // Small collision-aware separation keeps enemy silhouettes readable.
                for (var _j = 0; _j < _i; ++_j) {
                    var _other = _g.enemies[_j];
                    if (point_distance(_e.x, _e.y, _other.x, _other.y) < 16) {
                        var _away = point_direction(_other.x, _other.y, _e.x, _e.y);
                        sq_move(_g, _e, lengthdir_x(24 * _dt, _away), lengthdir_y(24 * _dt, _away));
                    }
                }
            }
        }
    }
}
