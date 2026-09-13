# Hype Man v8 playable animation proof

The approved compact concept is now the active player art in the Last Stop room. The curly head, brown skin, navy/cyan bomber and short sneakers are retained at a standing height of 28 native pixels. The 48 x 48 canvas uses a fixed foot origin at (24,44). Game rendering enlarges each native pixel 2x.

## Implemented

- Four body views: front, right, left and back. Left mirrors right.
- Idle: four frames, 800 ms loop, subtle body movement with planted feet.
- Run: six frames, 480 ms loop; analog movement changes playback speed, backward movement reverses the cycle, and the existing Hype buff speeds it up.
- Pistol: eight aim directions, independent hand/weapon layer and three recoil frames over the existing 170 ms firing interval. Vertical directions are foreshortened. The projectile starts at the first-frame muzzle anchor; cover still clips its origin.
- Dodge: six drawn poses over the existing 380 ms dodge, including anticipation, dive, tuck, inversion, landing and recovery. It uses the captured dodge direction and hides the pistol. Invulnerability remains 220 ms.
- Compact death key poses keep the player at the new scale, with a grounded final hold.

## What is still provisional

This is the idle/run/fire/dodge proof agreed for gameplay review, not the finished animation set. Reload and Make Some Noise currently retain the compact idle/run body while their existing gameplay and wave effects execute. Hit feedback uses a brief flash and one-pixel recoil. On a Roll still uses the previous effect layers. Death uses three concept key poses; front/back currently share the three-quarter fall, so a complete directional death pass is still required.

The compact gameplay proof was approved on 13 September 2026. Next, finish reload gestures, directional hit reactions, Make Some Noise gestures, resized On a Roll effects, and the full backward-fall/grounded death sequence. Review those at gameplay size before calling the character complete.

## Editable source and reproduction

- art/hypeman-v8-proof/Hype-Man-v8-Proof.aseprite: 100 frames, 24 animation tags, body and independent pistol layers.
- art/hypeman-v8-proof/model-source.png, run-source.png, roll-source.png: generated source sheets.
- art/hypeman-v8-proof/approved-model.png: approved concept reference.
- art/hypeman-v8-proof/build.lua: native extraction, palette, anchoring, export and preview assembly.
- art/hypeman-v8-proof/source-prompts.md: full prompts; source images used the built-in image generation tool, native assembly used Aseprite.
- art/hypeman-v8-proof/review/: review page, GIFs, native atlas and actual GameMaker renders.
- datafiles/hypeman-v8-proof/Hype-Man-Proof.png and .json: runtime atlas and clip/muzzle metadata, included in Side Quest.yyp.

Run Aseprite in batch mode with --script-param project=<project path>, --script-param preview=<existing preview directory>, and --script art/hypeman-v8-proof/build.lua. The script regenerates the master and runtime atlas, so retain any later hand-edited master as a separately versioned file before rebuilding.

## Verification — 13 September 2026

GameMaker LTS runtime 2026.0.0.23 compiled successfully. The gameplay suite reports **94 passed, 0 failed**, plus input-adapter and runtime smoke checks. The asset builder verified binary alpha, a 16-color palette, clear canvas margins, 100 frames and 24 clips. Actual engine captures cover combat, firing and the tucked dodge poses; these are framebuffer images, not concept composites.

The tests cover animation selection, timing, movement clock, eight-direction muzzle selection, first-shot flash, dodge priority and grounded death hold, alongside existing combat tests. The user approved the visual result and authorized publication. Physical controller feel remains a manual check.

Open Side Quest.yyp in GameMaker and press F5, or run Play.cmd. The window title reads "Side Quest - Hype Man v8 Animation Proof". Existing keyboard/mouse and controller mappings remain available.
