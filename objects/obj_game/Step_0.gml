if (test_mode || capture_mode) {
    test_frame += 1;
    if (test_mode && test_frame < 120) {
        var _test_input = sq_neutral_input();
        _test_input.aim = 0;
        _test_input.fire = true;
        sq_update(game, _test_input, 1 / 60);
    }
    if (test_frame > 125) game_end();
    exit;
}
if (keyboard_check_pressed(vk_f2)) input_debug = !input_debug;
var _input = sq_read_input();
debug_input_fire = _input.fire;
if (!window_has_focus() && game.mode == "combat") paused = true;
if (game.mode == "briefing" || game.mode == "dead" || game.mode == "cleared") {
    if (game.mode == "dead") sq_update(game, _input, delta_time / 1000000);
    if (_input.confirm && (game.mode != "dead" || game.player.anim.death >= 700)) {
        game = sq_new_game(); game.mode = "combat"; paused = false;
        camera_set_view_pos(sq_camera, 0, 0);
    }
    exit;
}
if (_input.pause || (paused && _input.confirm)) {
    paused = !paused;
    exit; // The resume button never also fires or dodges.
}
if (paused || !window_has_focus()) exit;
sq_update(game, _input, delta_time / 1000000);
sq_camera_advance(game, delta_time / 1000000, false);
camera_set_view_pos(sq_camera, game.camera.x, game.camera.y);
