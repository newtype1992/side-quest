/// Original temporary pixel graphics, drawn at integer native coordinates.
function sq_rect(_x1, _y1, _x2, _y2, _colour) {
    draw_set_colour(_colour);
    draw_rectangle(floor(_x1), floor(_y1), floor(_x2), floor(_y2), false);
}

function sq_outline(_x1, _y1, _x2, _y2, _colour) {
    draw_set_colour(_colour);
    draw_rectangle(floor(_x1), floor(_y1), floor(_x2), floor(_y2), true);
}

function sq_actor_draw(_x, _y, _colour, _aim, _stride, _roll, _flash) {
    _x = floor(_x); _y = floor(_y);
    sq_rect(_x - 8, _y + 5, _x + 8, _y + 8, $24140F);
    var _bob = floor(sin(_stride) * 1.5);
    if (_roll) {
        sq_rect(_x - 8, _y - 5, _x + 8, _y + 5, $1F1515);
        sq_rect(_x - 6, _y - 4, _x + 5, _y + 3, _flash ? c_white : _colour);
        sq_rect(_x + 3, _y - 3, _x + 7, _y + 2, $99C4DF);
        sq_rect(_x - 5, _y - 3, _x - 2, _y + 2, c_white);
        return;
    }
    sq_rect(_x - 5, _y, _x - 1, _y + 6 + _bob, $291C1D);
    sq_rect(_x + 2, _y, _x + 5, _y + 6 - _bob, $291C1D);
    sq_rect(_x - 6, _y + 5 + _bob, _x - 1, _y + 7 + _bob, $BEA79C);
    sq_rect(_x + 2, _y + 5 - _bob, _x + 7, _y + 7 - _bob, $BEA79C);
    sq_rect(_x - 8, _y - 9, _x + 7, _y + 1, $20141C);
    sq_rect(_x - 6, _y - 8, _x + 5, _y, _flash ? c_white : _colour);
    sq_rect(_x - 2, _y - 8, _x, _y, $DFD2C0);
    sq_rect(_x - 6, _y - 17, _x + 5, _y - 8, $20141C);
    sq_rect(_x - 4, _y - 15, _x + 4, _y - 9, _flash ? c_white : $91BAD6);
    sq_rect(_x - 5, _y - 17, _x + 4, _y - 14, $315573);
    sq_rect(_x - 4, _y - 18, _x + 1, _y - 16, $538CAC);
    var _face = lengthdir_x(1, _aim) < 0 ? -3 : 2;
    sq_rect(_x + _face, _y - 13, _x + _face + 1, _y - 12, $20141C);
    var _gx = _x + lengthdir_x(10, _aim);
    var _gy = _y - 3 + lengthdir_y(10, _aim);
    draw_set_colour($21151E);
    draw_line_width(floor(_x), floor(_y - 3), floor(_gx + lengthdir_x(5, _aim)), floor(_gy + lengthdir_y(5, _aim)), 5);
    draw_set_colour(_flash ? c_white : $C4CFD4);
    draw_line_width(floor(_x + lengthdir_x(6, _aim)), floor(_y - 3 + lengthdir_y(6, _aim)), floor(_gx), floor(_gy), 3);
    sq_rect(_x - 1 + lengthdir_x(6, _aim), _y - 4 + lengthdir_y(6, _aim),
        _x + 1 + lengthdir_x(6, _aim), _y - 2 + lengthdir_y(6, _aim), $91BAD6);
}

function sq_scene_draw(_g) {
    draw_clear($1D1510);
    // Quiet tile floor, with brighter bullets and silhouettes drawn above it.
    sq_rect(16, 48, 623, 312, $36251A);
    sq_rect(23, 68, 616, 306, $413529);
    for (var _tx = 24; _tx < 616; _tx += 16) {
        for (var _ty = 70; _ty < 306; _ty += 16) {
            sq_rect(_tx, _ty, _tx + 14, _ty + 14, ((_tx + _ty) div 16) mod 2 ? $41372D : $453B31);
            if ((_tx * 7 + _ty) mod 5 == 0) sq_rect(_tx + 5, _ty + 4, _tx + 6, _ty + 4, $4B4034);
        }
    }
    sq_rect(16, 48, 623, 67, $2B1B19);
    sq_rect(20, 49, 619, 51, $91614D);
    sq_rect(16, 68, 22, 311, $3B2620);
    sq_rect(617, 68, 623, 311, $3B2620);
    sq_rect(22, 307, 617, 313, $291B16);
    sq_rect(28, 52, 145, 64, $332122);
    sq_text(34, 55, "LAST STOP", $73EAC1, 1);
    sq_text(246, 55, "OPEN LATE. BAD IDEA.", $AE9B86, 1);
    sq_text(541, 55, "ICE $4", $F2DE9C, 1);
    // Room exit is visibly locked until every threat is defeated.
    sq_rect(15, 163, 27, 213, $1C1417);
    sq_rect(17, 167, 22, 209, _g.mode == "cleared" ? $93F0A2 : $927DEB);
    if (_g.mode != "cleared") {
        for (var _bar = 170; _bar < 210; _bar += 8) sq_rect(16, _bar, 27, _bar + 2, $E6A4FF);
    }
    for (var _i = 0; _i < array_length(_g.obstacles); ++_i) {
        var _o = _g.obstacles[_i];
        if (_o.kind == "crate") {
            if (_o.hp == 0) {
                sq_rect(_o.x1 + 2, _o.y1 + 6, _o.x1 + 9, _o.y1 + 8, $586479);
                sq_rect(_o.x2 - 7, _o.y2 - 5, _o.x2, _o.y2 - 3, $586479);
                continue;
            }
            sq_rect(_o.x1 - 1, _o.y1 + 3, _o.x2 + 3, _o.y2 + 4, $241A17);
            sq_rect(_o.x1, _o.y1, _o.x2, _o.y2, $526983);
            sq_outline(_o.x1 + 2, _o.y1 + 2, _o.x2 - 2, _o.y2 - 2, $87A4BA);
            sq_rect(_o.x1 + 8, _o.y1, _o.x1 + 11, _o.y2, $92B2CA);
        } else {
            sq_rect(_o.x1 - 2, _o.y1 + 3, _o.x2 + 4, _o.y2 + 5, $2B211B);
            sq_rect(_o.x1, _o.y1, _o.x2, _o.y2, $282321);
            sq_rect(_o.x1 + 2, _o.y1 + 2, _o.x2 - 2, _o.y2 - 3, $594634);
            for (var _row = 0; _row < 3; ++_row) {
                var _sy = _o.y1 + 5 + _row * 12;
                for (var _col = 0; _col < 6; ++_col) {
                    var _sx = _o.x1 + 5 + _col * 7;
                    var _c = [_o.y1 == 108 ? $848E68 : $756296, $759B9B, $907674][(_row + _col) mod 3];
                    sq_rect(_sx, _sy, _sx + 3, _sy + 6, _c);
                    sq_rect(_sx, _sy, _sx + 3, _sy + 1, $BBADA3);
                }
                sq_rect(_o.x1 + 2, _sy + 8, _o.x2 - 2, _sy + 9, $97856C);
            }
        }
    }
    // Attack indicators remain visible over the environment.
    for (var _i = 0; _i < array_length(_g.enemies); ++_i) {
        var _e = _g.enemies[_i];
        if (_e.state == "tell") {
            draw_set_colour(_e.kind == "melee" ? $67BFFF : $AD8EFF);
            draw_line(floor(_e.x), floor(_e.y), floor(_e.x + lengthdir_x(_e.kind == "melee" ? 60 : 100, _e.aim)),
                floor(_e.y + lengthdir_y(_e.kind == "melee" ? 60 : 100, _e.aim)));
            sq_text(_e.x - 2, _e.y - 28, "!", $E9ECFF, 1);
        }
    }
    // Actors use feet for gameplay positions and are sorted by feet for overlap.
    var _actors = [];
    array_push(_actors, {who: _g.player, player: true});
    for (var _i = 0; _i < array_length(_g.enemies); ++_i)
        array_push(_actors, {who: _g.enemies[_i], player: false});
    array_sort(_actors, function(_a, _b) { return _a.who.y - _b.who.y; });
    for (var _i = 0; _i < array_length(_actors); ++_i) {
        var _a = _actors[_i]; var _who = _a.who;
        var _colour = _a.player ? $CBCE65 : (_who.kind == "melee" ? $668ADC : $AF72BD);
        if (_a.player) sq_hypeman_draw(_g);
        else sq_actor_draw(_who.x, _who.y, _colour, _who.aim, _who.stride, false, _who.flash > 0);
        if (_a.player) {
            draw_set_colour(sq_player_invulnerable(_g) ? $FFFFBD : $BC8F50);
            draw_circle(floor(_who.x), floor(_who.y), 2, false);
            // The animated cyan motes show the passive without a floating label.
        } else if (_who.hp < _who.max_hp) {
            sq_rect(_who.x - 8, _who.y - 22, _who.x + 8, _who.y - 21, $2F1923);
            sq_rect(_who.x - 8, _who.y - 22, _who.x - 8 + 16 * _who.hp / _who.max_hp, _who.y - 21, $BBB1FF);
        }
        if (!_a.player && _who.stun > 0) sq_text(_who.x - 3, _who.y - 28, "*", $C0F5FF, 1);
    }
    for (var _i = 0; _i < array_length(_g.bullets); ++_i) {
        var _b = _g.bullets[_i];
        draw_set_colour($281324);
        draw_circle(round(_b.x), round(_b.y), _b.radius + 1, false);
        draw_set_colour(_b.team == "enemy" ? $AD7EFF : $A8F4FF);
        draw_circle(round(_b.x), round(_b.y), _b.radius, false);
        sq_rect(round(_b.x) - 1, round(_b.y) - 1, round(_b.x), round(_b.y), $F2F6FF);
    }
    for (var _i = 0; _i < array_length(_g.effects); ++_i) {
        var _fx = _g.effects[_i];
        var _progress = 1 - _fx.life / _fx.total;
        draw_set_colour(_fx.kind == "hurt" ? $8F8FFF : (_fx.kind == "noise" ? $D2FFC9 : $BDEAFF));
        if (_fx.kind == "noise") sq_noise_effect_draw(_fx);
        else {
            for (var _a = 0; _a < 4; ++_a) {
                var _ex = floor(_fx.x + lengthdir_x(_fx.size * _progress, _a * 90 + 45));
                var _ey = floor(_fx.y + lengthdir_y(_fx.size * _progress, _a * 90 + 45));
                draw_rectangle(_ex, _ey, _ex + 1, _ey + 1, false);
            }
        }
    }
    var _p = _g.player;
    var _muzzle = sq_weapon_origin(_g, false);
    var _rx = input_device == "CONTROLLER" ? _muzzle.x + lengthdir_x(54, _p.aim) : mouse_x;
    var _ry = input_device == "CONTROLLER" ? _muzzle.y + lengthdir_y(54, _p.aim) : mouse_y;
    if (_g.mode == "combat" && !paused) {
        sq_outline(_rx - 3, _ry - 3, _rx + 3, _ry + 3, $DCEFFF);
        sq_rect(_rx, _ry, _rx, _ry, $DCEFFF);
    }
}

function sq_hud_draw(_g) {
    var _p = _g.player;
    sq_rect(0, 0, 639, 43, $201713);
    sq_text(16, 9, "SIDE QUEST", $E8E4D6, 2);
    sq_text(17, 30, "COMBAT PROTOTYPE  /  01", $99897D, 1);
    sq_text(192, 8, "HYPE MAN", $CBCE65, 1);
    for (var _i = 0; _i < _g.cfg.health; ++_i) {
        var _hx = 192 + _i * 12;
        sq_rect(_hx, 24, _hx + 8, 30, _i < _p.hp ? $AD8DF4 : $443632);
        sq_rect(_hx + 2, 22, _hx + 6, 32, _i < _p.hp ? $AD8DF4 : $443632);
    }
    sq_text(290, 8, "POCKET PISTOL", $B0B6B5, 1);
    sq_text(290, 24, string(_p.ammo) + "/8", $E8E4D6, 1);
    sq_text(321, 24, _p.reload > 0 ? "RELOADING" : "UNLIMITED RESERVE", _p.reload > 0 ? $A8F4FF : $817C78, 1);
    if (_p.reload > 0) {
        sq_rect(290, 35, 422, 36, $4C3933);
        sq_rect(290, 35, 290 + 132 * (1 - _p.reload / _g.cfg.reload_time), 36, $A8F4FF);
    }
    sq_text(462, 8, "MAKE SOME NOISE", $B0B6B5, 1);
    sq_text(462, 24, _p.active <= 0 ? "READY" : string(ceil(_p.active)) + "S", _p.active <= 0 ? $A8F4B8 : $99897D, 1);
    sq_text(550, 24, string(array_length(_g.enemies)) + " THREATS", $B0B6B5, 1);
    sq_rect(16, 319, 623, 337, $2C211D);
    sq_text(23, 324, "GROUP CHAT", $CBCE65, 1);
    sq_text(101, 324, _g.mode == "cleared" ? "THE PLANNER: GREAT. NOW ACTUALLY BUY THE ICE." : "THE PLANNER: JUST GRAB ICE. HOW HARD CAN IT BE?", $BBB4A3, 1);
    var _hint = input_device == "CONTROLLER"
        ? "LS MOVE  RS AIM  RT FIRE  A/LB DODGE  X RELOAD  RB NOISE  START PAUSE"
        : "WASD MOVE  MOUSE AIM  LMB FIRE  SPACE/RMB DODGE  R RELOAD  E NOISE  ESC PAUSE";
    sq_text(16, 346, _hint, $AA9D8D, 1);
    if (_p.roll_cooldown > 0) {
        sq_rect(_p.x - 9, _p.y + 12, _p.x + 9, _p.y + 13, $4C3933);
        sq_rect(_p.x - 9, _p.y + 12, _p.x - 9 + 18 * (1 - _p.roll_cooldown / _g.cfg.roll_cooldown), _p.y + 13, $CBCE65);
    }
}

function sq_overlay(_g) {
    if (_g.mode == "combat" && !paused) return;
    if (_g.mode == "dead" && _g.player.anim.death < 700) return;
    draw_set_alpha(0.8); sq_rect(0, 44, 639, 315, $150F12); draw_set_alpha(1);
    var _title = paused ? "TAKE A BREATHER" : "ONE QUICK STOP";
    if (_g.mode == "dead") _title = "NIGHT CUT SHORT";
    if (_g.mode == "cleared") _title = "AISLES CLEAR";
    sq_text(140, 87, _title, $EBE9DB, 2);
    sq_rect(140, 112, 498, 113, $806047);
    if (_g.mode == "briefing") {
        sq_text(140, 129, "LAST STOP CONVENIENCE  /  11:47 PM", $CBCE65, 1);
        sq_text(140, 149, "FIVE THREATS. ONE PISTOL. A VERY SMALL ERRAND.", $C2BBAA, 1);
        sq_text(140, 170, "DODGE THROUGH BULLETS EARLY IN YOUR ROLL.", $C2BBAA, 1);
        sq_text(140, 186, "THE END OF A ROLL IS VULNERABLE. USE THE AISLES.", $C2BBAA, 1);
        sq_text(140, 207, "KILLS BOOST MOVEMENT AND RELOAD FOR 2.5 SECONDS.", $A8F4B8, 1);
        sq_text(140, 223, "NOISE CLEARS NEARBY BULLETS. 10 SECOND COOLDOWN.", $A8F4B8, 1);
    } else if (paused) {
        sq_text(140, 137, "THE NIGHT CAN WAIT.", $CBCE65, 1);
        sq_text(140, 166, "KEYBOARD AND CONTROLLER WORK IN THE SAME ROOM.", $C2BBAA, 1);
        sq_text(140, 185, "FOCUS LOSS OR CONTROLLER DISCONNECT PAUSES PLAY.", $C2BBAA, 1);
        sq_text(140, 219, "ENTER / A / START OR ESC TO RESUME", $A8F4B8, 1);
    } else {
        sq_text(140, 134, _g.mode == "cleared" ? "YOU SURVIVED THE COMBAT TEST." : "THE PARTY IS STILL HAPPENING WITHOUT YOU.", $CBCE65, 1);
        sq_text(140, 164, "TIME     " + string_format(_g.time, 0, 1) + " SECONDS", $C2BBAA, 1);
        sq_text(140, 182, "KILLS    " + string(_g.kills) + "/5", $C2BBAA, 1);
        var _accuracy = _g.shots > 0 ? round(100 * _g.hits / _g.shots) : 0;
        sq_text(140, 200, "ACCURACY " + string(_accuracy) + "%", $C2BBAA, 1);
        sq_text(140, 219, "DAMAGE   " + string(_g.damage_taken), $C2BBAA, 1);
    }
    if (!paused) {
        sq_rect(140, 250, 498, 274, $CBCE65);
        sq_text(153, 259, input_device == "CONTROLLER"
            ? "A / START  " + (_g.mode == "briefing" ? "ENTER THE STORE" : "TRY AGAIN")
            : "ENTER  " + (_g.mode == "briefing" ? "ENTER THE STORE" : "TRY AGAIN"), $241911, 1);
    }
    sq_text(140, 293, "HYPE MAN V7  /  FIRST COMBAT ROOM  /  NO SAVED PROGRESS", $7F766B, 1);
}
