# Side Quest — resume here

Checkpoint: 30 September 2026. Bring Ice route proof is the current build step; read the approved action pass in [hypeman-v9-action-pass.md](hypeman-v9-action-pass.md) for earlier animation work.

The creator revisited Stage 1 of the Newtype game development lifecycle and defined the [game concept](game-concept.md): fast combat with a funny night-out story for PC action roguelite players; complete each level to reach the party; Steam on Windows first; more explicit language with fade-to-black romantic outcomes. Stage 2 now defines the [three-errand game design](game-design.md) and [Bring Ice first slice](bring-ice-level-design.md). These are design specifications, not implemented or playtested levels. They do not revoke the approved Hype Man animation or Last Stop art.

## Current work

The v9 action pass now includes reload, hit, Make Some Noise, compact On a Roll motes, and a three-phase directional death in the native GameMaker room. Moving reload, hit, and ability actions now retain animated run legs. The v8 approved master is preserved. The project passed 108 animation checks plus input-adapter and runtime smoke checks on 29 September (`work/test-ef74a8d86020482fa534a5758a27bf7c.log`). Actual engine captures and timed previews are saved in `art/hypeman-v8-proof/review-v9/`; the [visual review page](hypeman-v9-visual-review.md) gathers the action clips and room captures. The creator approved the animations as a group on 29 September. The Scuf input incident is closed: the creator reports RT fire and switching from mouse to controller work, and suspects the short-trigger setting. See [controller-rt-diagnostic.md](controller-rt-diagnostic.md). The combat-feel pass was accepted by the creator on 30 September; the first full level remains unbuilt.

The creator then identified five combat-feel fixes. The [local revision](combat-feel-revision.md) implements arcade-style original sound cues, visible-body bullet collision, grounded dodge movement and shadow, a compact Gungeon-informed Side Quest HUD, breakable small clutter, and cover with three durability tiers. The creator accepted controls, arcade sound, visible bullet hits, the roll animation, and the general HUD, then reported that the dodge did not travel far enough to escape bullets. The current roll tuning targets about 79 native pixels over the same 380 ms animation, with 250 ms of invulnerability. Existing uncommitted `Side Quest.yyp` and `docs/playtest.md` edits remain the creator's work.

For the lower-right overlap, the creator chose camera movement rather than relocating the gun card. The card is fixed; the camera follows Hype Man across the room and pans into a dark margin at the right/bottom edge. The held gun and HUD icon have brighter accents. The creator says the longer roll feels "a lot better" and explicitly accepted closing the combat pass on 30 September. The last successful automated run passed 130 checks plus input-adapter and smoke checks; a camera corner capture was reviewed. Later GameMaker runner launches stalled during audio initialization before game code started, including hidden and visible self-test attempts. This is a tooling verification follow-up.

The first Bring Ice implementation step now connects a safe entrance, the accepted Last Stop combat encounter and a marked manager-arena staging room. F or controller B enters a nearby green-marked door. The combat room locks its doors until enemies are defeated; revisiting it retains defeated enemies and broken cover, while health and pistol ammo carry across rooms. Death or restart creates fresh room state. The route uses reusable room records and door links, but all three states temporarily reuse the approved Last Stop art. The manager fight, unique room pieces, seeded layout, map, rewards, ice and result are still unbuilt. This route proof compiles; its new runtime checks have not executed because the Runner stalls at `Audio_Init()`.

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

Standing character height is 28 native pixels on a 48 × 48 canvas, with foot origin (24,44). Gameplay coordinates are 640 × 360; the game renders at 1280 × 720. Idle loops in 800 ms, run in 480 ms, fire in 170 ms, and dodge in 380 ms. After playtest feedback about insufficient travel, dodge invulnerability is 250 ms, leaving a vulnerable 130 ms landing.

## Accepted milestone: combat-ready Hype Man in Last Stop

The creator closed the character and Milestone 1 combat-feel pass on 30 September 2026 after iterative live feedback. Art production moved ahead of the original roadmap's later art milestone. This approval establishes a working combat baseline; it does not complete the Bring Ice level.

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
- [x] Review and revise combat feel in live play: controls, sound, bullet hits, dodge, HUD, camera, props, gun emphasis and longer-roll travel received creator feedback and final pass acceptance.
- [ ] Complete the formal attempt table in docs/playtest.md if quantitative comparisons are needed; the creator's direct feedback is the acceptance evidence for this gate.
- [x] Fix the concrete problems found in the playtest and record the accepted tuning in [combat-feel-revision.md](combat-feel-revision.md).
- [x] Get the animation pass reviewed by the creator and record the approval here.
- [x] Approve the combat-feel build for direct publication on main without a PR.

The accepted build has the approved five animation groups and creator-reviewed combat feel on keyboard/mouse and SCUF. Automated tests alone did not establish feel or enjoyment. The hidden runner's later audio-initialization stall is recorded separately from live gameplay acceptance; retry that verification before relying on the new roll tests.

## Exact next session

1. Play the new entrance → combat → arena-staging route with keyboard/mouse and SCUF; check door prompts, combat lock, room revisit and death reset. Finish distinct authored art/collision for the entrance and manager arena.
2. Build seeded 4–6-room assembly with a fork, loop and discovered-room map on the new room-state and door-link foundation.
3. Add the found gun and item rules, manager boss, guarded ice, exit and result. Verify the first slice through full keyboard/mouse and SCUF attempts.
4. Retry the hidden GameMaker self-test runner when its pre-game `Audio_Init()` stall is resolved; the latest successful full run was 130 checks.

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

Latest successful local combat-feel test: 130 checks plus input-adapter and runtime smoke checks in work/test-1a361197e94941b498030d657d98ddc3.log. Subsequent runner launches stalled during audio initialization, before game Create; final camera follow timing needs a live visual check. The revised props, gun, HUD and camera are documented in docs/combat-feel-revision.md. Reproduction details and current animation limitations: docs/hypeman-v8-proof.md.

## Git state

On 28 September 2026, the local checkout was reconciled with GitHub main and the planning update was published as 851a806. The creator-approved v9 player animation pass was fast-forwarded directly to GitHub main at 8a03132 on 29 September 2026. The merged local review branch was removed. The creator accepted the combat-feel pass on 30 September for direct main publication. The pre-existing local `Side Quest.yyp` ordering and `docs/playtest.md` edits are preserved separately. Receipt for the earlier art publication: work/github-publication-20260913.json.

## After this milestone

Follow the Stage 2 design: prove a generated Bring Ice store maze with Hype Man, selected items, one found gun, an authored manager boss, ice pickup and result. Then build Get Cash and Find the Lost Phone, add Chaos Friend and the character-specific party result. The selected item slots and controls are recorded in [game-design.md](game-design.md).

Not built: seeded room assembly, complete multi-room mission flow, ice pickup/delivery, inventory/items/equipment, found guns, bosses, Chaos Friend, persistent content unlock, party results or a complete run. The route proof still contains one combat encounter. Enemy art remains temporary. Co-op, large weapon collections and broader party systems remain deferred. Windows standalone packaging previously failed under the installed profile; local F5/Play.cmd works, and packaging is a separate distribution task.
