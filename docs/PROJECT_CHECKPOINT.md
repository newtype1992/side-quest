# Side Quest — resume here

Checkpoint: 29 September 2026. Read the current action pass in [hypeman-v9-action-pass.md](hypeman-v9-action-pass.md); earlier approval and Git history remain below.

The creator revisited Stage 1 of the Newtype game development lifecycle and defined the [game concept](game-concept.md): fast combat with a funny night-out story for PC action roguelite players; complete each level to reach the party; Steam on Windows first; more explicit language with fade-to-black romantic outcomes. Stage 2 rules and the first playable slice still need design and testing. This concept review does not revoke the approved Hype Man animation or Last Stop art.

## Current work

The v9 action pass now includes reload, hit, Make Some Noise, compact On a Roll motes, and a three-phase directional death in the native GameMaker room. Moving reload, hit, and ability actions now retain animated run legs. The v8 approved master is preserved. The current project compiled and passed 108 checks plus input-adapter and runtime smoke checks on 29 September (`work/test-ef74a8d86020482fa534a5758a27bf7c.log`). Actual engine captures and timed previews are saved in `art/hypeman-v8-proof/review-v9/`; the [visual review page](hypeman-v9-visual-review.md) gathers the action clips and room captures. The creator approved reload in play and subsequently approved the animations as a group on 29 September. The Scuf input incident is closed: the creator reports RT fire and switching from mouse to controller work, and suspects the short-trigger setting. See [controller-rt-diagnostic.md](controller-rt-diagnostic.md). The player animation pass is approved; the broader repeated-attempt combat-feel playtest remains pending, so the complete level gate is not yet approved.

## Approved baseline from 13 September 2026

The user approved the detailed Last Stop convenience-store room and the compact Hype Man gameplay proof, then requested publication. The approved build is on the public repository's main branch at commit 95f6bebf7af3821c06421c45c5ad1df846e4c408:
https://github.com/newtype1992/side-quest/commit/95f6bebf7af3821c06421c45c5ad1df846e4c408

At that baseline, reload and hit-reaction animations were the next tasks, followed by the abilities and death pass. Those actions are now built in the local v9 pass described above. Do not restart character concept design or simplify the approved room again.

## What was complete at the approved v8 baseline

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

Passing this review will complete the current character pass and the existing Milestone 1 combat-feel gate. Art production has moved ahead of the original roadmap's later art milestone. No additional rooms, items or friends are required for this gate.

The five groups below were open at the v8 baseline. Each is now implemented in the v9 action pass, technically checked, and approved by the creator for animation.

| Order | Group | v8 fallback | Completion check |
| --- | --- | --- | --- |
| 1 | Reload | Compact idle/run body while reload logic executes. | Readable hand/pistol gesture, appropriate views for eight-way aim, works while moving, respects dodge interruption and Hype reload speed. |
| 2 | Hit reactions | Brief flash and one-pixel recoil. | Clear directional flinch when shot, consistent compact silhouette, no accidental interruption of movement or higher-priority actions. |
| 3 | Make Some Noise | Gameplay pulse works; compact body has no finished gesture. | Expressive gesture in the four views, aligned with the existing pulse and compatible with movement/action priorities. |
| 4 | On a Roll | Earlier effect layers around the new body. | Effects fit the compact sprite, preserve bullet readability and cleanly start, refresh and expire. |
| 5 | Death | Three compact concept keys; front/back share the three-quarter fall. | Character visibly gets shot and falls backward into a convincing lying-dead pose in each view. Redraw the fall/tuck/ground contact; do not rotate a standing sprite. Hold the final grounded pose. |

After those five groups:

- [x] Run the GameMaker suite and smoke test with new animation and input-switch behavior covered: 108 checks passed.
- [x] Review the player animations in play; creator approved the v9 action pass on 29 September 2026.
- [ ] Finish the broader transition and combat-feel playtest: idle/run/fire/reload/hit/roll/active/buff/death/restart, overlaps, action priority, feet, shadow, pistol/muzzle and shelf occlusion at gameplay size.
- [ ] Complete several keyboard/mouse and physical-controller attempts using docs/playtest.md. Record controller model, aim/deadzones, drift, disconnect/reconnect, reload/dodge behavior, readable damage and restart.
- [ ] Fix the concrete problems found in that playtest; record preferred tuning and remaining nonblocking issues.
- [x] Get the animation pass reviewed by the creator and record the approval here.
- [ ] Publish the next accepted build after the separate combat-feel gate is resolved.

The milestone is reached when the five new animation groups are integrated and approved, both input methods meet the combat-feel checks, damage is understandable, repeated attempts remain interesting, and no blocking runtime/transition bugs remain. Passing automated tests alone does not establish feel or enjoyment. There is no time estimate or completion percentage yet.

## Exact next session

1. Run Play.cmd or open Side Quest.yyp in GameMaker LTS and press F5. If the IDE reports external project changes, reload the resources from disk before editing; do not save stale in-memory resources over this work.
2. Play several attempts with keyboard/mouse and a physical controller using [playtest.md](playtest.md). Check reload during movement, dodge interruption, active ability, hits, death and restart.
3. Record specific gameplay or transition findings and revise those issues in the versioned source. Preserve the approved v8 source and the creator-approved v9 visual direction.
4. Publish the next level milestone after the combat-feel gate is met.

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
| art/hypeman-v8-proof/Hype-Man-v9-Actions.aseprite and build-v9.lua | Versioned current action source and builder; the approved v8 master remains intact. |
| art/hypeman-v8-proof/review-v9/ | Current timed action previews and actual GameMaker captures. |
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

On 28 September 2026, the local checkout was reconciled with GitHub main and the planning update was published as 851a806. The creator-approved v9 player animation pass was fast-forwarded directly to GitHub main at 8a03132 on 29 September 2026. The merged local review branch was removed. The separate full level combat-feel gate remains open. Receipt for the earlier art publication: work/github-publication-20260913.json.

## After this milestone

Follow the broader roadmap: decide item slots/controls and prototype a small item set, then build the three-room Bring Ice mission with quest state, ice pickup, transitions and results. A second friend and more enemy art come later.

Not built: procedural room generation, multi-room mission flow, ice pickup/delivery, inventory/items/equipment, additional playable friends, progression/save systems or a complete game. Current rooms are handmade. Enemy art remains temporary. Co-op, large weapon collections and broader party systems remain deferred. Windows standalone packaging previously failed under the installed profile; local F5/Play.cmd works, and packaging is a separate distribution task.
