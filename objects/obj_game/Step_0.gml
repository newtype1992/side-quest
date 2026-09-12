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
var _input = sq_read_input();
if (!window_has_focus() && game.mode == "combat") paused = true;
if (game.mode == "briefing" || game.mode == "dead" || game.mode == "cleared") {
    if (game.mode == "dead") sq_update(game, _input, delta_time / 1000000);
    if (_input.confirm && (game.mode != "dead" || game.player.anim.death >= 700)) {
        game = sq_new_game(); game.mode = "combat"; paused = false;
    }
    exit;
}
if (_input.pause || (paused && _input.confirm)) {
    paused = !paused;
    exit; // The resume button never also fires or dodges.
}
if (paused || !window_has_focus()) exit;
sq_update(game, _input, delta_time / 1000000);
