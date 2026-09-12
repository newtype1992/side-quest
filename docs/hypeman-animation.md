# Hype Man character integration

The player now uses the v7 Aseprite animation set: four body views, eight weapon aim directions, movement, shooting, reload, hit reaction, dodge, backward-fall death, Make Some Noise and the On a Roll visual effect.

Editable character/effect sources live in `art/hypeman/`. Runtime atlases and frame metadata are Included Files in `datafiles/hypeman/`. `sq_animation.gml` handles resource lifecycle, selection, composition and the two effects.

The death clip captures facing on the lethal hit and finishes before the results screen or restart input becomes available. Its final pose holds. Nonfatal hits preserve movement and weapon timing. The ability gesture can be interrupted by firing, reload or dodge, while its pulse remains visible. Reload is paused through a committed roll. The buff remains a separate visual loop.

Shots start at the sprite muzzle. A segment check keeps that origin on the player's side of cover. Mouse aiming uses the upper-body pivot; the controller reticle is drawn from the same muzzle used by shooting. Control bindings and gameplay cooldowns remain unchanged.

Run `powershell -ExecutionPolicy Bypass -File tools/Build.ps1 -Action Test` for the existing gameplay suite plus animation checks. The validated update passes 56 checks and a runtime render smoke test with the installed 2026.0.0.23 runtime.

The existing `--capture` path accepts `--capture-scene animation-noise`, `animation-hype`, `animation-death`, `animation-fire`, `animation-reload`, `animation-roll` and `animation-hit` for deterministic render fixtures. `ability` captures the pulse and gesture in the room. These options are only active when launching with the capture flag.

Next, play the room using both keyboard/mouse and the physical controller. Check aim transitions through north/south, walking and firing together, reload interrupted by roll, the ability while firing, buff visibility among bullets, and death/restart. The automated suite checks correctness; feel still needs hands-on review.
