// Screenshot is taken from the actual GameMaker render after the scene has drawn.
if ((test_mode || capture_mode) && test_frame == 120) {
    if (test_output != "" && surface_exists(application_surface)) {
        var _w = surface_get_width(application_surface);
        var _h = surface_get_height(application_surface);
        var _pixels = buffer_create(_w * _h * 4, buffer_fixed, 1);
        buffer_get_surface(_pixels, application_surface, 0);
        show_debug_message("SQ_FRAME_SIZE " + string(_w) + " " + string(_h));
        show_debug_message("SQ_FRAMEBUFFER " + buffer_base64_encode(_pixels, 0, buffer_get_size(_pixels)));
        buffer_delete(_pixels);
    } else if (test_output != "") show_debug_message("SQ_CAPTURE_NO_SURFACE");
    show_debug_message("SQ_RUNTIME_SMOKE_PASS");
}
