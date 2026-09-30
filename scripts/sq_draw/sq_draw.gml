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
    sq_environment_draw(_g);
    if (variable_struct_exists(_g, "rooms")) sq_room_doors_draw(_g);
    // Actors use feet for gameplay positions and are sorted by feet for overlap.
    var _actors = [];
    for(var _j=0;_j<array_length(_g.obstacles);++_j) {
        var _o=_g.obstacles[_j];
        if(_o.kind!="clutter") array_push(_actors,{who:{y:_o.y2},player:false,prop:_o});
    }
    array_push(_actors, {who: _g.player, player: true});
    for (var _i = 0; _i < array_length(_g.enemies); ++_i)
        array_push(_actors, {who: _g.enemies[_i], player: false});
    array_sort(_actors, function(_a, _b) { return _a.who.y - _b.who.y; });
    for (var _i = 0; _i < array_length(_actors); ++_i) {
        var _a = _actors[_i];
        if(variable_struct_exists(_a,"prop")) {sq_environment_prop_draw(_a.prop,_g);continue;}
        var _who = _a.who;
        var _colour = _a.player ? $CBCE65 : (_who.kind == "melee" ? $668ADC : $AF72BD);
        if (_a.player) sq_hypeman_draw(_g);
        else sq_actor_draw(_who.x, _who.y, _colour, _who.aim, _who.stride, false, _who.flash > 0);
        if (!_a.player && _who.hp < _who.max_hp) {
            sq_rect(_who.x - 8, _who.y - 22, _who.x + 8, _who.y - 21, $2F1923);
            sq_rect(_who.x - 8, _who.y - 22, _who.x - 8 + 16 * _who.hp / _who.max_hp, _who.y - 21, $BBB1FF);
        }
        if (!_a.player && _who.stun > 0) sq_text(_who.x - 3, _who.y - 28, "*", $C0F5FF, 1);
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
        draw_set_colour(_fx.kind == "hurt" ? $8F8FFF : (_fx.kind == "noise" ? $D2FFC9 : (_fx.kind == "splinter" ? make_colour_rgb(213,168,120) : (_fx.kind == "paper" ? make_colour_rgb(240,232,206) : (_fx.kind == "bottle" ? make_colour_rgb(102,214,229) : (_fx.kind == "spark" ? make_colour_rgb(135,225,239) : $BDEAFF))))));
        if (_fx.kind == "noise") sq_noise_effect_draw(_fx);
        else {
            var _shatter=(_fx.kind=="splinter" || _fx.kind=="spark" || _fx.kind=="bottle") && _fx.size>8;
            var _pieces=_shatter ? 8 : 4;
            for (var _a = 0; _a < _pieces; ++_a) {
                var _angle=_a*360/_pieces+45;
                var _ex = floor(_fx.x + lengthdir_x(_fx.size * _progress, _angle));
                var _ey = floor(_fx.y + lengthdir_y(_fx.size * _progress, _angle));
                draw_rectangle(_ex, _ey, _ex + (_shatter && _a mod 2 == 0 ? 2 : 1), _ey + 1, false);
            }
        }
    }
    var _p = _g.player;
    var _muzzle = sq_weapon_origin(_g, false);
    var _rx = input_device == "CONTROLLER" ? _muzzle.x + lengthdir_x(54, _p.aim) : mouse_x;
    var _ry = input_device == "CONTROLLER" ? _muzzle.y + lengthdir_y(54, _p.aim) : mouse_y;
    if ((_g.mode == "combat" || _g.mode == "explore") && !paused) {
        sq_outline(_rx - 3, _ry - 3, _rx + 3, _ry + 3, $DCEFFF);
        sq_rect(_rx, _ry, _rx, _ry, $DCEFFF);
    }
}

function sq_room_doors_draw(_g) {
    var _open = _g.mode != "combat";
    var _colour = _open ? $A8F4B8 : $D9828B;
    var _doors = _g.rooms[_g.room_id].doors;
    for (var _d = 0; _d < array_length(_doors); ++_d) {
        var _door = _doors[_d];
        var _point = sq_room_door_position(_door.side);
        if (_door.side == "left" || _door.side == "right") {
            sq_rect(_point.x - 12, _point.y - 20, _point.x + 11, _point.y - 17, _colour);
            sq_rect(_point.x - 12, _point.y + 23, _point.x + 11, _point.y + 26, _colour);
            sq_outline(_point.x - 12, _point.y - 16, _point.x + 11, _point.y + 22, _colour);
        } else {
            sq_rect(_point.x - 20, _point.y - 6, _point.x - 17, _point.y + 6, _colour);
            sq_rect(_point.x + 17, _point.y - 6, _point.x + 20, _point.y + 6, _colour);
            sq_outline(_point.x - 16, _point.y - 6, _point.x + 16, _point.y + 6, _colour);
        }
    }
}

function sq_hud_draw(_g) {
    var _p = _g.player;
    draw_set_alpha(0.85);
    sq_rect(9, 4, 182, 43, make_colour_rgb(16,23,34));
    sq_rect(535, 8, 630, 28, make_colour_rgb(16,23,34));
    draw_set_alpha(1);
    sq_outline(9, 4, 182, 43, make_colour_rgb(82,103,121));
    sq_outline(535, 8, 630, 28, make_colour_rgb(82,103,121));
    sq_text(17, 8, "HYPE MAN", make_colour_rgb(233,235,223), 1);
    for (var _i = 0; _i < _g.cfg.health; ++_i) {
        sq_heart_draw(17 + _i * 17, 18, _i < _p.hp);
    }
    sq_rect(17, 32, 26, 40, _p.active <= 0 ? make_colour_rgb(76,216,231) : make_colour_rgb(53,76,91));
    sq_text(19, 33, "N", make_colour_rgb(17,27,40), 1);
    sq_text(32, 33, _p.active <= 0 ? "NOISE READY" : "NOISE " + string(ceil(_p.active)) + "S", _p.active <= 0 ? make_colour_rgb(169,241,229) : make_colour_rgb(170,177,180), 1);
    sq_text(543, 15, _g.mode == "combat" ? string(array_length(_g.enemies)) + " THREATS" : "NO THREATS", make_colour_rgb(233,235,223), 1);
    draw_set_alpha(0.86); sq_rect(9, 322, 482, 343, make_colour_rgb(16,23,34)); draw_set_alpha(1);
    sq_outline(9, 322, 482, 343, make_colour_rgb(82,103,121));
    sq_text(17, 329, "CHAT", make_colour_rgb(76,216,231), 1);
    var _chat = _g.mode == "cleared" ? "PLANNER: GREAT. NOW ACTUALLY BUY THE ICE." : "PLANNER: JUST GRAB ICE. HOW HARD CAN IT BE?";
    if (variable_struct_exists(_g, "rooms")) {
        if (_g.room_id == 0) _chat = "PLANNER: CHECK THE AISLES. WE STILL NEED ICE.";
        if (_g.room_id == 1 && _g.rooms[1].cleared) _chat = "PLANNER: AISLES CLEAR. FIND THE MANAGER.";
        if (_g.room_id == 2) _chat = "PLANNER: THE ICE IS IN HERE SOMEWHERE.";
    }
    sq_text(51, 329, _chat, make_colour_rgb(215,214,200), 1);
    if (_g.mode == "briefing" || paused) {
        var _hint = input_device == "CONTROLLER"
            ? "LS MOVE  RS AIM  RT FIRE  A/LB DODGE  X RELOAD  RB NOISE  START PAUSE"
            : "WASD MOVE  MOUSE AIM  LMB FIRE  SPACE/RMB DODGE  R RELOAD  E NOISE  ESC PAUSE";
        sq_text(16, 348, _hint, $AA9D8D, 1);
    }
    sq_weapon_hud_draw(_g);
    if (variable_struct_exists(_g, "rooms")) sq_room_hud_draw(_g);
    if (_p.reload > 0 && _p.hp > 0 && _g.mode == "combat") sq_reload_bar_draw(_g);
    if (_p.roll_cooldown > 0) {
        sq_rect(_p.x - 9, _p.y + 12, _p.x + 9, _p.y + 13, $4C3933);
        sq_rect(_p.x - 9, _p.y + 12, _p.x - 9 + 18 * (1 - _p.roll_cooldown / _g.cfg.roll_cooldown), _p.y + 13, $CBCE65);
    }
}

function sq_room_hud_draw(_g) {
    if (_g.mode == "briefing" || _g.mode == "dead") return;
    var _label = _g.rooms[_g.room_id].name;
    draw_set_alpha(0.88); sq_rect(193, 4, 469, 33, $101722); draw_set_alpha(1);
    sq_outline(193, 4, 469, 33, $526779);
    sq_text(201, 8, "BRING ICE  /  " + _label, $EBE9DB, 1);
    var _message = "";
    if (_g.mode == "combat") _message = "DOORS LOCKED: CLEAR THIS ROOM";
    else {
        _message = _g.room_id == 2 ? "ARENA PREVIEW / BOSS PENDING" : "FOLLOW THE GREEN DOOR MARKER";
        var _doors = _g.rooms[_g.room_id].doors;
        for (var _d = 0; _d < array_length(_doors); ++_d) {
            if (sq_room_at_door(_g, _doors[_d])) {
                _message = input_device == "CONTROLLER" ? "B: ENTER DOOR" : "F: ENTER DOOR";
                break;
            }
        }
    }
    sq_text(201, 20, _message, _g.mode == "combat" ? $D9828B : $A8F4B8, 1);
}

function sq_heart_draw(_x, _y, _full) {
    var _ink=make_colour_rgb(9,14,23);
    var _fill=_full ? make_colour_rgb(236,113,146) : make_colour_rgb(58,67,80);
    sq_rect(_x+1,_y,_x+4,_y+1,_ink); sq_rect(_x+7,_y,_x+10,_y+1,_ink);
    sq_rect(_x,_y+2,_x+11,_y+4,_ink);
    sq_rect(_x+1,_y+5,_x+10,_y+5,_ink);
    sq_rect(_x+2,_y+6,_x+9,_y+6,_ink);
    sq_rect(_x+3,_y+7,_x+8,_y+7,_ink);
    sq_rect(_x+4,_y+8,_x+7,_y+8,_ink);
    sq_rect(_x+5,_y+9,_x+6,_y+9,_ink);
    sq_rect(_x+2,_y+1,_x+4,_y+2,_fill); sq_rect(_x+7,_y+1,_x+9,_y+2,_fill);
    sq_rect(_x+1,_y+3,_x+10,_y+4,_fill);
    sq_rect(_x+2,_y+5,_x+9,_y+5,_fill);
    sq_rect(_x+3,_y+6,_x+8,_y+6,_fill);
    sq_rect(_x+4,_y+7,_x+7,_y+7,_fill);
    sq_rect(_x+5,_y+8,_x+6,_y+8,_fill);
    if(_full) sq_rect(_x+2,_y+2,_x+3,_y+2,make_colour_rgb(255,225,211));
}

function sq_reload_bar_draw(_g) {
    var _p = _g.player;
    var _x = clamp(floor(_p.x) - 21, 8, 590);
    var _y = max(49, floor(_p.y) - 53);
    var _progress = clamp(1 - _p.reload / _g.cfg.reload_time, 0, 1);
    sq_rect(_x - 2, _y - 2, _x + 43, _y + 5, make_colour_rgb(16, 23, 34));
    sq_outline(_x - 1, _y - 1, _x + 42, _y + 4, make_colour_rgb(233, 235, 223));
    sq_rect(_x, _y, _x + 41, _y + 3, make_colour_rgb(46, 57, 66));
    var _filled = floor(42 * _progress);
    if (_filled > 0) sq_rect(_x, _y, _x + _filled - 1, _y + 3, make_colour_rgb(69, 214, 237));
}

function sq_weapon_hud_draw(_g) {
    var _p = _g.player;
    // Stronger pistol silhouette and a cyan sight echo the held weapon.
    draw_set_alpha(0.9); sq_rect(501, 267, 636, 315, make_colour_rgb(16,23,34)); draw_set_alpha(1);
    sq_outline(501, 267, 636, 315, make_colour_rgb(102,157,175));
    sq_rect(506, 267, 550, 268, make_colour_rgb(76,216,231));
    sq_rect(506, 272, 550, 309, make_colour_rgb(33,48,63));
    sq_outline(506, 272, 550, 309, make_colour_rgb(127,166,180));
    sq_rect(509, 283, 546, 291, make_colour_rgb(7, 8, 12));
    sq_rect(511, 284, 540, 288, make_colour_rgb(208, 221, 222));
    sq_rect(516, 282, 534, 283, make_colour_rgb(250, 244, 216));
    sq_rect(538, 285, 549, 287, make_colour_rgb(204, 225, 225));
    sq_rect(546, 283, 549, 284, make_colour_rgb(76,216,231));
    sq_rect(516, 289, 528, 292, make_colour_rgb(71, 84, 94));
    sq_rect(518, 293, 527, 302, make_colour_rgb(7, 8, 12));
    sq_rect(520, 293, 525, 300, make_colour_rgb(103, 73, 47));
    sq_text(557, 274, "POCKET PISTOL", make_colour_rgb(233,235,223), 1);
    sq_text(557, 285, string(_p.ammo) + " / " + string(_g.cfg.magazine),
        _p.reload > 0 ? make_colour_rgb(76,216,231) : make_colour_rgb(233,235,223), 1);
    for(var _i=0;_i<_g.cfg.magazine;++_i) {
        var _bx=558+_i*8;
        sq_rect(_bx,300,_bx+3,307,_i<_p.ammo ? make_colour_rgb(217,177,110) : make_colour_rgb(52,68,84));
        sq_rect(_bx+1,298,_bx+2,299,_i<_p.ammo ? make_colour_rgb(246,218,157) : make_colour_rgb(52,68,84));
    }
}

function sq_camera_target(_g) {
    // The approved 640x360 room stays intact; the extra room area is night-dark overscan.
    return {x: clamp(_g.player.x - 320, 0, room_width - 640),
        y: clamp(_g.player.y - 180, 0, room_height - 360)};
}

function sq_camera_advance(_g, _dt, _instant) {
    var _target = sq_camera_target(_g);
    var _blend = _instant ? 1 : 1 - power(0.5, clamp(_dt, 0, 1 / 30) / 0.12);
    // A safety edge prevents camera easing from letting the sprite enter the HUD.
    _g.camera.smooth_x = clamp(max(lerp(_g.camera.smooth_x, _target.x, _blend), _g.player.x - 465), 0, room_width - 640);
    _g.camera.smooth_y = clamp(max(lerp(_g.camera.smooth_y, _target.y, _blend), _g.player.y - 252), 0, room_height - 360);
    _g.camera.x = round(_g.camera.smooth_x);
    _g.camera.y = round(_g.camera.smooth_y);
}

function sq_overlay(_g) {
    if ((_g.mode == "combat" || _g.mode == "explore") && !paused) return;
    if (_g.mode == "dead" && _g.player.anim.death < 700) return;
    draw_set_alpha(0.8); sq_rect(0, 44, 639, 315, $150F12); draw_set_alpha(1);
    var _title = paused ? "TAKE A BREATHER" : "ONE QUICK STOP";
    if (_g.mode == "dead") _title = "NIGHT CUT SHORT";
    if (_g.mode == "cleared") _title = "AISLES CLEAR";
    sq_text(140, 87, _title, $EBE9DB, 2);
    sq_rect(140, 112, 498, 113, $806047);
    if (_g.mode == "briefing") {
        sq_text(140, 129, "LAST STOP CONVENIENCE  /  11:47 PM", $CBCE65, 1);
        sq_text(140, 149, "ENTER THE STORE, CLEAR THE AISLES, FIND THE ARENA.", $C2BBAA, 1);
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
    sq_text(140, 293, variable_struct_exists(_g, "rooms")
        ? "BRING ICE ROUTE PROOF  /  MANAGER FIGHT COMING NEXT"
        : "HYPE MAN V7  /  FIRST COMBAT ROOM  /  NO SAVED PROGRESS", $7F766B, 1);
}

/// Approved Last Stop layout: coordinates are native pixels; bounds are ground footprints.
function sq_environment_layout() {
    return [
        {x1:202,y1:164,x2:237,y2:245,kind:"shelf",hp:14,max_hp:14,art:"shelf_left",draw_x:199,draw_y:144},
        {x1:384,y1:164,x2:417,y2:245,kind:"shelf",hp:14,max_hp:14,art:"shelf_right",draw_x:381,draw_y:144},
        {x1:64,y1:112,x2:172,y2:138,kind:"counter",hp:-1,art:"",draw_x:64,draw_y:100},
        {x1:382,y1:108,x2:575,y2:114,kind:"fridges",hp:-1,art:"",draw_x:382,draw_y:67},
        {x1:290,y1:192,x2:312,y2:212,kind:"crate",hp:4,max_hp:4,art:"crate",draw_x:288,draw_y:182},
        {x1:30,y1:268,x2:43,y2:306,kind:"stock",hp:-1,art:"",draw_x:30,draw_y:266},
        {x1:582,y1:272,x2:613,y2:306,kind:"clutter",clutter:"water_cases",hp:1,draw_x:580,draw_y:268,draw_w:34,draw_h:39,patch_x:532},
        {x1:601,y1:178,x2:616,y2:270,kind:"stock",hp:-1,art:"",draw_x:601,draw_y:178},
        {x1:30,y1:232,x2:43,y2:268,kind:"stock",hp:-1,art:"",draw_x:30,draw_y:232},
        {x1:594,y1:114,x2:616,y2:163,kind:"stock",hp:-1,art:"",draw_x:594,draw_y:114},
        {x1:453,y1:229,x2:475,y2:249,kind:"crate",hp:8,max_hp:8,art:"crate",draw_x:451,draw_y:219},
        {x1:44,y1:268,x2:75,y2:306,kind:"clutter",clutter:"boxes",hp:1,draw_x:44,draw_y:268,draw_w:32,draw_h:39,patch_x:140},
        {x1:76,y1:273,x2:104,y2:306,kind:"clutter",clutter:"bottles",hp:1,draw_x:76,draw_y:270,draw_w:29,draw_h:37,patch_x:172},
        {x1:148,y1:264,x2:161,y2:272,kind:"clutter",clutter:"paper",hp:1,draw_x:147,draw_y:259,draw_w:16,draw_h:14}
    ];
}
function sq_environment_init() {
    var _names=["background","shelf_left","shelf_right","crate"];
    var _files=["Room","Shelf-Left","Shelf-Right","Crate"];
    global.sq_environment={};
    for(var _i=0;_i<array_length(_names);++_i) {
        var _s=sprite_add("environment-v2/"+_files[_i]+".png",1,false,false,0,0);
        if(_s<0) show_error("Missing Last Stop environment asset: "+_files[_i],true);
        variable_struct_set(global.sq_environment,_names[_i],_s);
    }
}
function sq_environment_cleanup() {
    if(!variable_global_exists("sq_environment")) return;
    var _keys=variable_struct_get_names(global.sq_environment);
    for(var _i=0;_i<array_length(_keys);++_i) {
        var _s=variable_struct_get(global.sq_environment,_keys[_i]);
        if(sprite_exists(_s)) sprite_delete(_s);
    }
}
function sq_environment_draw(_g) {
    draw_clear(make_colour_rgb(13,18,32));
    draw_sprite_ext(global.sq_environment.background,0,0,0,0.5,0.5,0,c_white,1);
    // Preserve the approved OPEN sign; only the actual combat lock is dynamic.
    if(_g.mode!="cleared") for(var _y=169;_y<209;_y+=8) {
        sq_rect(16,_y,27,_y+2,make_colour_rgb(247,170,213));
        sq_rect(17,_y,25,_y,make_colour_rgb(255,214,232));
    }
    // Local, restrained glints layered onto the approved lamp/fridge pixels.
    draw_set_alpha(0.035+0.015*(floor(_g.time*2) mod 3));
    sq_rect(538,78,567,79,make_colour_rgb(167,250,255));
    sq_rect(115,95,120,99,make_colour_rgb(255,220,140));
    draw_set_alpha(1);
    for(var _i=0;_i<array_length(_g.obstacles);++_i) {
        var _clutter=_g.obstacles[_i];
        if(_clutter.kind=="clutter") sq_environment_clutter_draw(_clutter);
    }
}

function sq_environment_clutter_draw(_o) {
    if(_o.clutter!="paper") {
        // Restore the approved stock pixels over a floor tile sampled at matching grid alignment.
        draw_sprite_part_ext(global.sq_environment.background,0,_o.patch_x*2,_o.draw_y*2,
            _o.draw_w*2,_o.draw_h*2,_o.draw_x,_o.draw_y,0.5,0.5,c_white,1);
        if(_o.hp>0) draw_sprite_part_ext(global.sq_environment.background,0,_o.draw_x*2,_o.draw_y*2,
            _o.draw_w*2,_o.draw_h*2,_o.draw_x,_o.draw_y,0.5,0.5,c_white,1);
    }
    if(_o.clutter=="paper" && _o.hp>0) {
        sq_rect(_o.draw_x+1,_o.draw_y+9,_o.draw_x+14,_o.draw_y+13,make_colour_rgb(21,31,43));
        sq_rect(_o.draw_x+2,_o.draw_y+5,_o.draw_x+13,_o.draw_y+10,make_colour_rgb(226,225,206));
        sq_rect(_o.draw_x+4,_o.draw_y+3,_o.draw_x+15,_o.draw_y+8,make_colour_rgb(245,239,216));
        sq_rect(_o.draw_x+7,_o.draw_y+5,_o.draw_x+12,_o.draw_y+5,make_colour_rgb(89,162,179));
        sq_rect(_o.draw_x+5,_o.draw_y+7,_o.draw_x+10,_o.draw_y+7,make_colour_rgb(89,162,179));
    }
    if(_o.hp==0) {
        var _cx=floor((_o.x1+_o.x2)*0.5),_cy=_o.y2-4;
        var _debris=_o.clutter=="boxes" ? make_colour_rgb(166,119,79)
            : (_o.clutter=="paper" ? make_colour_rgb(231,226,206) : make_colour_rgb(86,177,199));
        sq_rect(_cx-7,_cy-2,_cx-4,_cy-1,_debris);
        sq_rect(_cx+3,_cy-5,_cx+5,_cy-4,_debris);
        sq_rect(_cx-1,_cy,_cx+1,_cy+1,_debris);
    }
}
function sq_environment_prop_draw(_o,_g) {
    if(_o.hp==0) {
        sq_rect(_o.x1+2,_o.y2-4,_o.x1+10,_o.y2-2,make_colour_rgb(128,91,67));
        sq_rect(_o.x2-10,_o.y2-6,_o.x2-3,_o.y2-4,make_colour_rgb(174,132,91));
        if(_o.kind=="shelf") {
            sq_rect(_o.x1+8,_o.y2-10,_o.x1+11,_o.y2-5,make_colour_rgb(60,94,111));
            sq_rect(_o.x2-13,_o.y2-3,_o.x2-7,_o.y2-1,make_colour_rgb(60,94,111));
            sq_rect(_o.x1+15,_o.y2-6,_o.x1+19,_o.y2-4,make_colour_rgb(209,81,129));
            sq_rect(_o.x2-16,_o.y2-11,_o.x2-13,_o.y2-8,make_colour_rgb(83,182,200));
        }
        return;
    }
    if(_o.art=="") return;
    // A tall shelf may overlap actors in the walkable lane behind it.
    var _alpha=sq_environment_prop_occludes(_o,_g) ? 0.42 : 1;
    draw_set_alpha(_alpha);
    draw_sprite_ext(variable_struct_get(global.sq_environment,_o.art),0,_o.draw_x,_o.draw_y,0.5,0.5,0,c_white,draw_get_alpha());
    if(_o.hp>0 && variable_struct_exists(_o,"max_hp") && _o.hp<_o.max_hp) {
        var _cx=floor((_o.x1+_o.x2)*0.5);
        var _cy=_o.kind=="shelf" ? _o.y2-19 : _o.y2-10;
        draw_set_colour(make_colour_rgb(216,184,139));
        draw_line(_cx-4,_cy-3,_cx,_cy+1);
        draw_line(_cx,_cy+1,_cx+4,_cy-2);
        if(_o.hp<=_o.max_hp*0.5) draw_line(_cx,_cy+1,_cx-1,_cy+6);
    }
    draw_set_alpha(1);

}

function sq_environment_prop_occludes(_o,_g) {
 if(_o.art=="" || _o.hp==0) return false;
 var _all=[_g.player];
 for(var _i=0;_i<array_length(_g.enemies);++_i) array_push(_all,_g.enemies[_i]);
 for(var _i=0;_i<array_length(_all);++_i) {
  var _a=_all[_i];
  if(_a.x+10>_o.x1 && _a.x-10<_o.x2 && _a.y>=_o.draw_y && _a.y<_o.y1) return true;
 }
 return false;
}
