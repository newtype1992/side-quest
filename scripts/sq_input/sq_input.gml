/// Hardware adapter. Gameplay receives the same command struct for both devices.
function sq_read_input() {
    var _input = sq_neutral_input();
    var _keys = sq_vector(keyboard_check(ord("D")) - keyboard_check(ord("A")),
        keyboard_check(ord("S")) - keyboard_check(ord("W")), 0);
    var _mouse_moved = abs(mouse_x - last_mouse_x) + abs(mouse_y - last_mouse_y) > 1;
    var _mouse_fire = mouse_check_button(mb_left);
    var _keyboard_activity = _keys.x != 0 || _keys.y != 0 || _mouse_moved
        || _mouse_fire || keyboard_check_pressed(ord("R"))
        || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space)
        || mouse_check_button_pressed(mb_right) || keyboard_check_pressed(vk_enter);
    last_mouse_x = mouse_x; last_mouse_y = mouse_y;

    var _old_pad = pad_slot;
    if (pad_slot != -1 && !gamepad_is_connected(pad_slot)) {
        pad_slot = -1;
        if (input_device == "CONTROLLER" && game.mode == "combat") paused = true;
        input_device = "KEYBOARD";
    }
    // Do not assume XInput occupies slot zero. Search every available device.
    if (pad_slot == -1) {
        for (var _slot = 0; _slot < gamepad_get_device_count(); ++_slot) {
            if (gamepad_is_connected(_slot)) {
                pad_slot = _slot;
                gamepad_set_axis_deadzone(_slot, 0);
                gamepad_set_button_threshold(_slot, 0.3);
                break;
            }
        }
    }
    var _stick = {x: 0, y: 0};
    var _aim_stick = {x: 0, y: 0};
    var _pad_fire = false;
    var _pad_roll = false;
    var _pad_reload = false;
    var _pad_active = false;
    var _pad_pause = false;
    var _pad_confirm = false;
    if (pad_slot != -1) {
        _stick = sq_vector(gamepad_axis_value(pad_slot, gp_axislh),
            gamepad_axis_value(pad_slot, gp_axislv), game.cfg.stick_deadzone);
        _aim_stick = sq_vector(gamepad_axis_value(pad_slot, gp_axisrh),
            gamepad_axis_value(pad_slot, gp_axisrv), game.cfg.aim_deadzone);
        _pad_fire = gamepad_button_check(pad_slot, gp_shoulderrb);
        _pad_roll = gamepad_button_check_pressed(pad_slot, gp_face1)
            || gamepad_button_check_pressed(pad_slot, gp_shoulderl);
        _pad_reload = gamepad_button_check_pressed(pad_slot, gp_face3);
        _pad_active = gamepad_button_check_pressed(pad_slot, gp_shoulderr);
        _pad_pause = gamepad_button_check_pressed(pad_slot, gp_start);
        _pad_confirm = _pad_pause || gamepad_button_check_pressed(pad_slot, gp_face1);
        if (_stick.x != 0 || _stick.y != 0 || _aim_stick.x != 0 || _aim_stick.y != 0
            || _pad_fire || _pad_roll || _pad_reload || _pad_active || _pad_pause) {
            input_device = "CONTROLLER";
        }
    }
    if (_keyboard_activity) input_device = "KEYBOARD";
    _input.aim = game.player.aim;
    if (input_device == "CONTROLLER") {
        _input.mx = _stick.x; _input.my = _stick.y;
        if (_aim_stick.x != 0 || _aim_stick.y != 0)
            _input.aim = point_direction(0, 0, _aim_stick.x, _aim_stick.y);
        _input.fire = _pad_fire; _input.roll = _pad_roll;
        _input.reload = _pad_reload; _input.active = _pad_active;
    } else {
        _input.mx = _keys.x; _input.my = _keys.y;
        _input.aim = point_direction(game.player.x, game.player.y - 10, mouse_x, mouse_y);
        _input.fire = _mouse_fire;
        _input.roll = keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_right);
        _input.reload = keyboard_check_pressed(ord("R"));
        _input.active = keyboard_check_pressed(ord("E"));
    }
    _input.pause = keyboard_check_pressed(vk_escape) || _pad_pause;
    _input.confirm = keyboard_check_pressed(vk_enter) || _pad_confirm;
    return _input;
}
