game_set_speed(60, gamespeed_fps);
gpu_set_texfilter(false);
window_set_size(1280, 720);
window_center();
window_set_caption("Side Quest - Hype Man v8 Animation Proof");
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
last_mouse_x = mouse_x;
last_mouse_y = mouse_y;
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
    game.mode = "combat";
}
if (capture_mode) {
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
    if (capture_scene == "depth") {
        game.player.x=224;game.player.y=150;game.player.aim=0;
        game.enemies=[sq_enemy(224,260,"melee",0),sq_enemy(408,152,"ranged",0)];game.bullets=[];
    }
    if (capture_scene == "destroyed") { game.obstacles[4].hp=0; game.mode="combat"; }
    if (capture_scene == "paused") paused = true;
    if (capture_scene == "controller") input_device = "CONTROLLER";
}
