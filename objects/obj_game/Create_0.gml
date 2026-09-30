game_set_speed(60, gamespeed_fps);
gpu_set_texfilter(false);
window_set_size(1280, 720);
window_center();
window_set_caption("Side Quest - Hype Man Action Pass");
window_set_cursor(cr_none);
display_set_gui_size(640, 360);
// Keep gameplay units unchanged, but render the approved art at display resolution.
sq_camera = camera_create_view(0,0,640,360,0,noone,-1,-1,-1,-1);
view_enabled=true; view_visible[0]=true; view_camera[0]=sq_camera;
view_xport[0]=0; view_yport[0]=0; view_wport[0]=1280; view_hport[0]=720;
surface_resize(application_surface,1280,720);
game = sq_new_game();
paused = false;
pad_slot = -1;
input_device = "KEYBOARD";
input_debug = false;
debug_input_fire = false;
last_mouse_x = window_mouse_get_x();
last_mouse_y = window_mouse_get_y();
test_mode = false;
test_frame = 0;
capture_mode = false;
capture_scene = "combat";
test_output = "";
for (var _arg = 1; _arg <= parameter_count(); ++_arg) {
    if (parameter_string(_arg) == "--self-test") test_mode = true;
    if (parameter_string(_arg) == "--capture") capture_mode = true;
    if (parameter_string(_arg) == "--capture-scene" && _arg < parameter_count()) capture_scene = parameter_string(_arg + 1);
    if (parameter_string(_arg) == "--test-output" && _arg < parameter_count()) test_output = parameter_string(_arg + 1);
}
global.sq_quiet = test_mode || capture_mode;
global.sq_font = sq_font_data();
sq_audio_init();
sq_art_init();
sq_environment_init();
if (test_mode) {
    sq_self_tests();
    var _hardware = sq_read_input();
    show_debug_message("SQ_INPUT_ADAPTER_PASS controller_slot=" + string(pad_slot));
    if (pad_slot != -1) {
        show_debug_message("SQ_PAD_DESCRIPTION " + gamepad_get_description(pad_slot));
        show_debug_message("SQ_PAD_MAPPING " + gamepad_get_mapping(pad_slot));
        show_debug_message("SQ_PAD_RT_VALUE " + string(gamepad_button_value(pad_slot, gp_shoulderrb)));
    }
    for (var _slot = 0; _slot < gamepad_get_device_count(); ++_slot)
        if (gamepad_is_connected(_slot)) show_debug_message("SQ_PAD_SLOT " + string(_slot) + " " + gamepad_get_description(_slot));
    game.mode = "combat";
}
if (capture_mode) {
    if (capture_scene == "audio") {
        var _cue_names = variable_struct_get_names(global.sq_audio);
        for (var _cue_index = 0; _cue_index < array_length(_cue_names); ++_cue_index) {
            var _cue = variable_struct_get(global.sq_audio, _cue_names[_cue_index]);
            show_debug_message("SQ_AUDIO_PCM " + _cue_names[_cue_index] + " "
                + buffer_base64_encode(_cue.buffer, 0, buffer_get_size(_cue.buffer)));
        }
    }
    game.mode = "combat";
    game.player.x = 265; game.player.y = 188; game.player.aim = 8;
    game.enemies[0].state = "tell"; game.enemies[0].aim = 192; game.enemies[0].timer = 0.45;
    sq_spawn_bullet(game, 461, 163, 190, 108, "enemy", 1);
    sq_spawn_bullet(game, 455, 183, 180, 108, "enemy", 1);
    sq_spawn_bullet(game, 461, 202, 170, 108, "enemy", 1);
    sq_spawn_bullet(game, 342, 177, 8, 360, "player", 2);
    if (capture_scene == "briefing") game.mode = "briefing";
    if (capture_scene == "cleared") { game.mode = "cleared"; game.enemies = []; game.kills = 5; }
    if (capture_scene == "dead") { game.mode = "dead"; game.player.hp = 0; game.player.anim.death = 700; }
    if (capture_scene == "ability") {
        game.player.anim.noise = 170; game.player.anim.noise_facing = "right";
        game.player.hype = 2.5; game.player.anim.hype = 160;
        game.effects = [{x: game.player.x, y: game.player.y, kind: "noise", size: 84, life: 0.2, total: 0.4}];
    }
    if (capture_scene == "reload") { game.player.ammo=3; game.player.reload=0.46; }
    if (capture_scene == "reload-moving") { game.player.ammo=3; game.player.reload=0.46; game.player.anim.moving=true; game.player.anim.compact_move=160; }
    if (capture_scene == "roll") { game.player.roll=0.19; game.player.roll_dir=0; game.player.anim.roll_facing="right"; }
    if (capture_scene == "hud-corner") { game.player.x=570; game.player.y=292; game.player.aim=45; }
    if (capture_scene == "camera-mid") { game.player.x=400; game.player.y=210; game.player.aim=0; }
    if (capture_scene == "clutter-broken") {
        game.obstacles[6].hp=0; game.obstacles[11].hp=0;
        game.obstacles[12].hp=0; game.obstacles[13].hp=0;
    }
    if (capture_scene == "hype") { game.player.hype=2.5; game.player.anim.hype=160; }
    if (capture_scene == "ability-moving") { game.player.anim.noise=170; game.player.anim.noise_facing="right"; game.player.anim.moving=true; game.player.anim.compact_move=160; }
    if (capture_scene == "hit") { game.player.anim.hit=20; game.player.anim.hit_facing="right"; game.player.anim.hit_dir=180; }
    if (capture_scene == "death-fall") { game.player.hp=0; game.mode="dead"; game.player.anim.death=160; game.player.anim.death_facing="right"; }
    if (capture_scene == "depth") {
        game.player.x=224;game.player.y=150;game.player.aim=0;
        game.enemies=[sq_enemy(224,260,"melee",0),sq_enemy(408,152,"ranged",0)];game.bullets=[];
    }
    if (capture_scene == "destroyed") { game.obstacles[4].hp=0; game.mode="combat"; }
    if (capture_scene == "cover-destroyed") {
        game.obstacles[0].hp=0; game.obstacles[4].hp=0; game.obstacles[10].hp=0;
    }
    if (capture_scene == "cover-damaged") {
        game.obstacles[0].hp=7; game.obstacles[4].hp=2; game.obstacles[10].hp=4;
    }
    if (capture_scene == "paused") paused = true;
    if (capture_scene == "controller") input_device = "CONTROLLER";
    if (capture_scene == "input-diagnostic") {
        input_debug = true;
        var _diagnostic_input = sq_read_input();
        debug_input_fire = _diagnostic_input.fire;
    }
    sq_camera_advance(game, 1, true);
    camera_set_view_pos(sq_camera, game.camera.x, game.camera.y);
}
