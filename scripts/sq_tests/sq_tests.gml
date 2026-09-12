/// Run these against the real GML implementation with --self-test.
function sq_check(_condition, _label) {
    if (_condition) { global.sq_pass += 1; show_debug_message("SQ_PASS " + _label); }
    else { global.sq_fail += 1; show_debug_message("SQ_FAIL " + _label); }
}

function sq_test_game() {
    var _g = sq_new_game(); _g.mode = "combat"; return _g;
}

function sq_self_tests() {
    global.sq_pass = 0; global.sq_fail = 0;
    var _input = sq_neutral_input();
    var _v = sq_vector(1, 1, 0);
    sq_check(abs(point_distance(0, 0, _v.x, _v.y) - 1) < 0.0001, "diagonal movement normalized");
    _v = sq_vector(0.1, 0.1, 0.2);
    sq_check(_v.x == 0 && _v.y == 0, "controller drift deadzone");
    _v = sq_vector(0.6, 0, 0.2);
    sq_check(abs(_v.x - 0.5) < 0.0001, "analog speed preserved after radial deadzone");

    var _g = sq_test_game();
    _input.mx = 1;
    repeat (60) sq_player_step(_g, _input, 1 / 60);
    sq_check(abs(_g.player.x - 200) < 0.01, "112 native pixels per second");
    var _g30 = sq_test_game();
    repeat (30) sq_player_step(_g30, _input, 1 / 30);
    sq_check(abs(_g30.player.x - _g.player.x) < 0.01, "movement consistent at 30 and 60 updates");
    _g = sq_test_game(); _g.player.x = 150; _g.player.y = 128;
    sq_move(_g, _g.player, 180, 0);
    sq_check(_g.player.x < 170 && !sq_blocked(_g, _g.player.x, _g.player.y, 6), "large moves cannot tunnel through shelf");
    _g = sq_test_game();
    sq_move(_g, _g.player, -1000, -1000);
    sq_check(_g.player.x >= 30 && _g.player.y >= 76, "room boundaries enforced");

    _g = sq_test_game(); _input = sq_neutral_input(); _input.roll = true; _input.mx = 1;
    sq_player_step(_g, _input, 1 / 60);
    sq_check(sq_player_invulnerable(_g), "early roll invulnerable");
    sq_check(!sq_damage_player(_g, 1) && _g.player.hp == 6, "roll rejects incoming damage");
    var _roll_x = _g.player.x;
    _input.mx = -1; _input.roll = false; _input.fire = true; _input.aim = 180;
    sq_player_step(_g, _input, 1 / 60);
    sq_check(_g.player.x > _roll_x && _g.shots == 0, "roll direction committed and shooting blocked");
    _g.player.roll = 0.1;
    sq_check(!sq_player_invulnerable(_g), "late roll vulnerable");
    sq_check(sq_damage_player(_g, 1) && _g.player.hp == 5, "late roll can take damage");
    sq_check(!sq_damage_player(_g, 1) && _g.player.hp == 5, "hurt grace prevents multiple same-frame hits");

    _g = sq_test_game(); _input = sq_neutral_input(); _input.fire = true;
    sq_player_step(_g, _input, 1 / 60);
    sq_check(_g.player.ammo == 7 && _g.shots == 1 && array_length(_g.bullets) == 1, "gun fires immediately and consumes ammo");
    sq_player_step(_g, _input, 1 / 60);
    sq_check(_g.shots == 1, "fire cadence enforced");
    _input.fire = false; _input.reload = true;
    sq_player_step(_g, _input, 1 / 60);
    sq_check(_g.player.reload > 0, "manual reload begins");
    _input.reload = false;
    repeat (60) sq_player_step(_g, _input, 1 / 60);
    sq_check(_g.player.ammo == 8 && _g.player.reload == 0, "reload refills magazine");
    _g.player.ammo = 0; _input.fire = true;
    sq_player_step(_g, _input, 1 / 60);
    sq_check(_g.player.reload > 0 && _g.player.ammo == 0, "empty magazine starts automatic reload");

    _g = sq_test_game(); _g.enemies = [sq_enemy(130, 180, "melee", 0)];
    sq_spawn_bullet(_g, 100, 180, 0, 5000, "player", 6);
    sq_bullets_step(_g, 1 / 30);
    sq_check(array_length(_g.enemies) == 0 && _g.kills == 1, "fast projectile hits instead of tunneling");
    sq_check(_g.player.hype == _g.cfg.hype_duration, "kill activates passive");
    sq_update(_g, sq_neutral_input(), 1 / 60);
    sq_check(_g.mode == "cleared" && array_length(_g.bullets) == 0, "last kill clears room and stray bullets");
    _g = sq_test_game(); _g.player.hype = 2; _g.enemies = [sq_enemy(130, 180, "melee", 0)];
    sq_damage_enemy(_g, 0, 10, 0);
    sq_check(_g.player.hype == 2.5, "passive refreshes without stacking");

    _g = sq_test_game(); _g.enemies = [sq_enemy(240, 128, "melee", 0)];
    sq_spawn_bullet(_g, 160, 128, 0, 5000, "player", 20);
    sq_bullets_step(_g, 1 / 30);
    sq_check(_g.enemies[0].hp == 6 && array_length(_g.bullets) == 0, "shelf blocks fast player bullets");
    _g = sq_test_game();
    sq_spawn_bullet(_g, 275, 188, 0, 500, "player", 4);
    sq_bullets_step(_g, 0.08);
    sq_check(_g.obstacles[4].hp == 0 && sq_obstacle_at(_g, 300, 188, 2) == -1, "breakable crate releases collision");

    _g = sq_test_game(); _g.enemies = [sq_enemy(120, 180, "melee", 0)];
    sq_spawn_bullet(_g, 100, 180, 0, 10, "enemy", 1);
    sq_spawn_bullet(_g, 300, 180, 0, 10, "enemy", 1);
    sq_spawn_bullet(_g, 100, 180, 0, 10, "player", 2);
    _input = sq_neutral_input(); _input.active = true;
    sq_player_step(_g, _input, 1 / 60);
    sq_check(array_length(_g.bullets) == 2, "active only clears nearby hostile bullets");
    sq_check(_g.enemies[0].stun > 0 && _g.enemies[0].x > 120, "active stuns and pushes enemy");
    sq_spawn_bullet(_g, 100, 180, 0, 10, "enemy", 1);
    sq_player_step(_g, _input, 1 / 60);
    sq_check(array_length(_g.bullets) == 3, "active cannot bypass cooldown");

    _g = sq_test_game(); _g.player.x = 500; _g.player.y = 180;
    sq_build_nav(_g);
    sq_check(_g.nav[8 * 40 + 9] >= 0, "navigation reaches other side of shelf");
    _g.enemies = [sq_enemy(100, 128, "melee", 0)];
    var _initial_distance = point_distance(100, 128, 500, 180);
    repeat (360) sq_enemies_step(_g, 1 / 60);
    sq_check(point_distance(_g.enemies[0].x, _g.enemies[0].y, 500, 180) < _initial_distance - 180,
        "melee navigates around shelves over time");

    _g = sq_test_game(); _g.enemies = [sq_enemy(180, 180, "ranged", 0)]; sq_build_nav(_g);
    sq_enemies_step(_g, 1 / 60);
    sq_check(_g.enemies[0].state == "tell" && array_length(_g.bullets) == 0, "ranged enemy telegraphs before firing");
    repeat (38) sq_enemies_step(_g, 1 / 60);
    sq_check(array_length(_g.bullets) == 3, "ranged volley has three spaced bullets");

    _g = sq_test_game(); _g.player.hp = 1;
    sq_damage_player(_g, 1); sq_update(_g, sq_neutral_input(), 1 / 60);
    sq_check(_g.mode == "dead" && _g.player.hp == 0, "zero health enters death state");
    var _before = _g.time;
    sq_update(_g, sq_neutral_input(), 1);
    sq_check(_g.time == _before, "dead run no longer simulates");
    _g = sq_new_game();
    sq_check(_g.player.hp == 6 && _g.player.ammo == 8 && array_length(_g.enemies) == 5
        && _g.kills == 0 && _g.player.active == 0 && array_length(_g.bullets) == 0,
        "restart resets combat state");
    sq_animation_tests();
    show_debug_message("SQ_TEST_RESULTS pass=" + string(global.sq_pass) + " fail=" + string(global.sq_fail));
}
