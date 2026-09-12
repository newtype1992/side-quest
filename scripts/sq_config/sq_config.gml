/// Prototype values in native pixels and seconds. These are playtest defaults.
function sq_config() {
    return {
        width: 640, height: 360, move_speed: 112, player_radius: 6, health: 6,
        roll_speed: 270, roll_duration: 0.38, roll_invulnerable: 0.22,
        roll_cooldown: 0.65, hurt_invulnerable: 0.85,
        magazine: 8, reload_time: 0.9, fire_interval: 0.17,
        bullet_speed: 360, bullet_damage: 2, bullet_radius: 2,
        active_radius: 84, active_cooldown: 10, active_stun: 0.7,
        hype_duration: 2.5, hype_move: 1.15, hype_reload: 1.25,
        stick_deadzone: 0.2, aim_deadzone: 0.25
    };
}

function sq_vector(_x, _y, _deadzone) {
    var _length = sqrt(_x * _x + _y * _y);
    if (_length <= _deadzone) return {x: 0, y: 0};
    var _magnitude = clamp((_length - _deadzone) / (1 - _deadzone), 0, 1);
    return {x: _x / _length * _magnitude, y: _y / _length * _magnitude};
}

function sq_neutral_input() {
    return {mx: 0, my: 0, aim: 0, fire: false, roll: false,
        reload: false, active: false, pause: false, confirm: false};
}
