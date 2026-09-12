if (capture_mode && string_pos("animation-", capture_scene) == 1) {
    sq_animation_gallery(capture_scene);
    exit;
}
sq_scene_draw(game);
sq_hud_draw(game);
sq_overlay(game);
