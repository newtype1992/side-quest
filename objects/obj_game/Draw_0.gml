if (capture_mode && string_pos("animation-", capture_scene) == 1) {
    sq_animation_gallery(capture_scene);
    exit;
}
sq_scene_draw(game);
// Project the fixed 640x360 HUD into the current camera view.
matrix_set(matrix_world, matrix_build(game.camera.x, game.camera.y, 0, 0, 0, 0, 1, 1, 1));
sq_hud_draw(game);
sq_overlay(game);
if (input_debug) sq_input_diagnostic_draw();
matrix_set(matrix_world, matrix_build_identity());
