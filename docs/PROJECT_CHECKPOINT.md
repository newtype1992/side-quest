# Side Quest — resume here

Checkpoint: 13 September 2026; Git state reconciled 28 September 2026. This is the current handoff; older art and validation documents describe earlier passes.

## Where we stopped

The user approved the detailed Last Stop convenience-store room and the compact Hype Man gameplay proof, then requested publication. The approved build is on the public repository's main branch at commit 95f6bebf7af3821c06421c45c5ad1df846e4c408:
https://github.com/newtype1992/side-quest/commit/95f6bebf7af3821c06421c45c5ad1df846e4c408

The next production task is **reload and hit-reaction animations for the approved compact Hype Man**, followed by the remaining abilities and death pass. Do not restart character concept design or simplify the approved room again. The current checkpoint is an approved visual/gameplay proof, not a finished character or complete mission.

## What is complete

| Area | Current state |
| --- | --- |
| Game foundation | Native GameMaker/GML Windows combat prototype; one handmade Last Stop encounter. |
| Controls | Keyboard/mouse and controller support, independent movement/aim, analog movement, eight-direction weapon aiming, device switching and pause handling. |
| Combat | Eight-round pistol, reload, dodge/invulnerability, health, death/restart, two enemy archetypes, five-enemy encounter, tells, projectiles, solid shelves and breakable crate. |
| Hype Man gameplay | Make Some Noise clears nearby hostile bullets and pushes/stuns enemies; On a Roll grants a temporary movement/reload buff after kills. |
| Environment | Approved detailed store art, stocked displays, lighting and perimeter details; independent shelf/crate depth sorting and occlusion fading. |
| Character design | Approved large curly head, brown skin, navy/cyan bomber, short legs and white/cyan sneakers. Original art informed by Enter the Gungeon's readability and compact proportions. |
| Character animation proof | Four body views; idle, six-frame run, eight-way pistol recoil/fire and six-pose tucked dodge integrated into gameplay. |
| Sources | Editable Aseprite files, generated source sheets, export scripts, runtime atlases, metadata and review GIFs stored in the Side Quest project. |
| Verification | Latest build: 94 passing gameplay/animation checks, zero failures, input-adapter check and runtime smoke pass. Actual GameMaker captures reviewed; user approved the visual result. |
| GitHub | Approved code/art published as 95f6beb on main; existing animated repository banner preserved. |

Standing character height is 28 native pixels on a 48 × 48 canvas, with foot origin (24,44). Gameplay coordinates are 640 × 360; the game renders at 1280 × 720. Idle loops in 800 ms, run in 480 ms, fire in 170 ms, and dodge in 380 ms. Dodge invulnerability remains 220 ms. Preserve the working timings unless a playtest identifies a reason to change them.

## Next milestone: combat-ready Hype Man in Last Stop

This completes the current character pass and the existing Milestone 1 combat-feel gate. Art approval has moved ahead of the original roadmap's later art milestone. No additional rooms, items or friends are required for this gate.

Five animation groups remain. Each needs gameplay integration and review at actual display size, not just an attractive enlarged sprite sheet.

| Order | Remaining work | Current fallback | Completion check |
| --- | --- | --- | --- |
| 1 | Reload | Compact idle/run body while reload logic executes. | Readable hand/pistol gesture, appropriate views for eight-way aim, works while moving, respects dodge interruption and Hype reload speed. |
| 2 | Hit reactions | Brief flash and one-pixel recoil. | Clear directional flinch when shot, consistent compact silhouette, no accidental interruption of movement or higher-priority actions. |
| 3 | Make Some Noise | Gameplay pulse works; compact body has no finished gesture. | Expressive gesture in the four views, aligned with the existing pulse and compatible with movement/action priorities. |
| 4 | On a Roll | Earlier effect layers around the new body. | Effects fit the compact sprite, preserve bullet readability and cleanly start, refresh and expire. |
| 5 | Death | Three compact concept keys; front/back share the three-quarter fall. | Character visibly gets shot and falls backward into a convincing lying-dead pose in each view. Redraw the fall/tuck/ground contact; do not rotate a standing sprite. Hold the final grounded pose. |

After those five groups:

- [ ] Verify all transitions: idle/run/fire/reload/hit/roll/active/buff/death/restart; check overlaps and action priority.
- [ ] Check feet, shadow, pistol/muzzle, shelf occlusion and palette/alpha at gameplay size in all views.
- [ ] Run the existing GameMaker suite and smoke test; add meaningful coverage for new animation behavior where needed. Record the resulting count rather than assuming it stays 94.
- [ ] Complete several keyboard/mouse and physical-controller attempts using docs/playtest.md. Record controller model, aim/deadzones, drift, disconnect/reconnect, reload/dodge behavior, readable damage and restart.
- [ ] Fix the concrete problems found in that playtest; record preferred tuning and remaining nonblocking issues.
- [ ] Get the completed character pass reviewed in the actual room; update this checkpoint and publish the next accepted build.

The milestone is reached when the five new animation groups are integrated and approved, both input methods meet the combat-feel checks, damage is understandable, repeated attempts remain interesting, and no blocking runtime/transition bugs remain. Passing automated tests alone does not establish feel or enjoyment. There is no time estimate or completion percentage yet.

## Exact next session

1. Read this file, then docs/hypeman-v8-proof.md. Open art/hypeman-v8-proof/review/review.html and compare the approved model with the live character.
2. Run Play.cmd or open Side Quest.yyp in GameMaker LTS and press F5. If the IDE reports external project changes, reload the resources from disk before editing; do not save stale in-memory resources over this work.
3. Start a versioned working copy of the approved Aseprite source. Build **reload first, then hit reactions**, preserving the existing model, palette, foot anchor and responsive movement/aim.
4. Integrate those two groups, test their interactions with firing and dodge, and show actual-size gameplay previews before moving on to abilities and death.
5. Record completed work, validation and the next exact task here. Preserve previous approved assets while iterating.

## Where everything lives

Main project: C:/Users/Kareem/Projects/Side Quest

| Project-relative path | Purpose |
| --- | --- |
| Side Quest.yyp / Play.cmd | Open or run the native game. |
| scripts/sq_animation/sq_animation.gml | Active compact animation rendering, timing, selection and muzzle logic; older v7 code/effects are retained. |
| scripts/sq_combat/sq_combat.gml | Combat actions and gameplay state. |
| scripts/sq_input/sq_input.gml | Keyboard/mouse/controller adapter. |
| scripts/sq_draw/sq_draw.gml | Room and actor rendering. |
| scripts/sq_config/sq_config.gml | Gameplay tuning values. |
| art/hypeman-v8-proof/Hype-Man-v8-Proof.aseprite | Approved compact native master: 100 frames, 24 tags, body and pistol layers. |
| art/hypeman-v8-proof/build.lua | Recreates the atlas/master from source sheets. It overwrites generated outputs; preserve later hand edits before rebuilding. |
| art/hypeman-v8-proof/review/ | Animated previews, frame sheets, interactive review and actual game captures. |
| datafiles/hypeman-v8-proof/ | Runtime PNG atlas and JSON metadata. |
| art/environment-v2/ / datafiles/environment-v2/ | Approved detailed room sources and runtime art. |
| art/hypeman/ / art/environment/ | Earlier source sets, retained for history and existing effects. |
| tools/Build.ps1 | Compile/run/test helper. |
| work/ | Ignored local build files and test logs. |

Validation command from the project folder:

    powershell -NoProfile -ExecutionPolicy Bypass -File tools/Build.ps1 -Action Test

Latest pre-publication test log: work/test-f253f53a99014cfda91ba41eb88d505e.log. Reproduction details and current animation limitations: docs/hypeman-v8-proof.md.

## Git state

On 28 September 2026, the live GitHub main was verified at 95f6beb and this project checkout was fast-forwarded to it. The locally prepared project files matched the published code and art. The remaining local-only planning updates were retained, and the published README banner and its assets were preserved. This checkpoint and planning update are the next commit after 95f6beb. Receipt for the earlier publication: work/github-publication-20260913.json.

## After this milestone

Follow the broader roadmap: decide item slots/controls and prototype a small item set, then build the three-room Bring Ice mission with quest state, ice pickup, transitions and results. A second friend and more enemy art come later.

Not built: procedural room generation, multi-room mission flow, ice pickup/delivery, inventory/items/equipment, additional playable friends, progression/save systems or a complete game. Current rooms are handmade. Enemy art remains temporary. Co-op, large weapon collections and broader party systems remain deferred. Windows standalone packaging previously failed under the installed profile; local F5/Play.cmd works, and packaging is a separate distribution task.
