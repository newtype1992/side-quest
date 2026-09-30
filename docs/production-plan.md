# Side Quest production plan

Updated 29 September 2026. **Resume with [PROJECT_CHECKPOINT.md](PROJECT_CHECKPOINT.md)** for the approved baseline, exact next task and Git state. [Stage 2 game design](game-design.md) and the [Bring Ice build specification](bring-ice-level-design.md) now define the full run and first slice.

The immediate objective is a combat room worth replaying. The attached Side Quest Project Brief supplies the design direction: a single-player, top-down action roguelite about adult friends trying to reach a house party while ordinary errands become dangerous detours. GameMaker is the intended engine, and true pixel art and responsive gun combat are central to the direction.

This plan treats confirmed design choices, proposed examples, and open questions separately. The brief's roadmap is design context, not an instruction to implement every feature at once. The direct request authorized planning or beginning production; the follow-up specifically added controller support from the start.

## Current production baseline

The first combat room has been implemented in the existing GameMaker project structure. It includes movement and independent aiming, keyboard/mouse and controller input, one pistol, reload, dodge, health, death, restart, two enemy archetypes, solid shelves, a breakable crate, attack tells, hit cues, sound, and clear/death results. Hype Man's proposed passive and active are implemented for immediate testing.

The detailed Last Stop room and full compact Hype Man animation pass are approved and published on main. Enemy graphics and combat tuning still need work. The build establishes a baseline for tuning; it has not established that the combat is fun or matches the reference's feel. A combat clear is the current ending. There is no ice pickup or multi-room mission yet.

## Working decisions

| Decision | Status and reason |
| --- | --- |
| GameMaker and GML | Follows the brief and the existing project. |
| Steam on Windows first | Confirmed Stage 1 platform and first store. Packaging and Steam release checks are later gates. |
| Keyboard/mouse and controller | Controller support explicitly requested during this task. |
| Hype Man first, Chaos Friend second | Hype Man starts available; a first full-night clear unlocks Chaos Friend for later runs. |
| 640 × 360 gameplay coordinates; 1280 × 720 rendering | Approved room display; compact character stands 28 native pixels tall and displays at 2×. |
| Eight-round pistol and infinite reserve | The starter remains a fallback; the first-release found-gun pool has limited ammunition. |
| One handmade encounter | Current prototype only. Each designed errand assembles 4–6 themed rooms before a fixed boss arena. |
| Three-errand night | Bring Ice, Get Cash, Find the Lost Phone, then the party; 25–35 minute successful-run target. Death restarts the night. |
| Adult cast and original assets | Follows the brief's 21+ character direction and original nightlife setting. |

## Milestone 1 Combat feel

**Status:** combat baseline, approved room, and all five Hype Man finishing animation groups complete. A recorded repeated-attempt playtest on keyboard/mouse and a physical controller remains before this milestone exits.

Reload, hit reactions, Make Some Noise gestures, resized On a Roll effects and directional backward-fall death are integrated and creator-approved. See the [animation action pass](hypeman-v9-action-pass.md) for reference research, sources, checks, and process lessons. This character art work moved ahead of the original later art milestone.

Play several attempts with each input device. Tune movement, stick response, dodge commitment, the vulnerable end of the roll, projectile speed, enemy tells, and gun feedback. Change one major variable per comparison. The relevant inputs and metrics are available in the build and the playtest form.

**Exit gate:** the remaining compact character animations are integrated and approved at gameplay size; movement and aiming feel reliable with both devices; players can explain why damage occurred; enemies remain reachable around cover; death and restart stay quick; repeated attempts remain interesting. Do not count automated checks as evidence of enjoyment. Record the preferred tuning and any unresolved issues before increasing content.

## Milestone 2 Character and item choices

**Status:** Hype Man abilities exist. Stage 2 has fixed item capacity, controls and first-slice choices; implementation and physical playtesting remain.

Validate the kill buff and ten-second projectile clear in play. Implement two one-use consumable slots (Pocket Sand and Hot Sauce), one passive equipment slot (Questionable Sneakers), and one limited-ammo found-gun slot alongside the Pocket Pistol. Item selection uses 1/2 or D-pad; Q/LT uses the selected item. Weapon swap uses Tab/mouse wheel or Y. Keep these separate from the friend active on E/RB. See [game-design.md](game-design.md) for pickup, persistence and death rules.

**Exit gate:** the player can describe a useful situation for every item, activate it comfortably on controller and keyboard, and still read enemy bullets and damage cues. Add automated checks for consumption, cooldowns, interruption rules, and restart reset when those systems exist.

## Milestone 3 Bring Ice playable slice

**Status:** Stage 2 design complete; implementation not started. See [bring-ice-level-design.md](bring-ice-level-design.md).

Build one Bring Ice level from 4–6 seeded, authored convenience-store room pieces with a fork and loop, a discovered-room map and a fixed Armored Night Manager arena. The current approved Last Stop encounter supplies visual and combat direction; it is not the complete generated level. Add explicit quest states: accepted, exploring, boss defeated, ice collected, escaped, result. Preserve room-clear and pickup state on revisits; prevent repeated rewards.

After boss defeat, take the guarded ice and use the exit to show an ice-secured result. The ice is a quest item, not a consumable weapon in this slice. Write short original group-chat reactions before combat and at the result. The party and romance systems are unnecessary for this gate.

**Exit gate:** someone unfamiliar with the project can understand the errand, navigate several generated layouts, choose or skip an optional branch, defeat the manager, take the ice, recognize the result and restart. All layouts are connected and reproducible by seed. Dialogue does not obscure an active fight. Quest and room state survive revisits and reset on a new attempt.

## Milestone 4 Second friend and art slice

**Status:** Chaos Friend is the selected second playable character for the first release. Build after the first mission and shared combat systems are stable.

Chaos Friend's close-range damage passive and destructive, non-invulnerable charge are the selected contrast with Hype Man. Give that friend exactly one passive and one active; preserve the shared movement, aim, gun, dodge and item systems. A full-night clear with Hype Man unlocks Chaos Friend for later runs.

The Last Stop environment and compact Hype Man design were brought forward and approved during Milestone 1. At this later stage, expand the approved art direction to the second friend and enemy art, then review gun/projectile consistency. Keep silhouettes, bullet contrast, animations and alignment readable in the build.

**Exit gate:** character choice changes tactics using the same combat foundation, and the small art set remains clear during movement and incoming fire.

## Ordered next backlog

1. Complete and record repeated keyboard/mouse and physical-controller combat playtests; fix concrete input, readability and feel issues to close Milestone 1.
2. Refactor the fixed encounter into reusable room state, then build seeded authored-room assembly and the Bring Ice map.
3. Implement the selected item/weapon rules, the manager boss, ice pickup and escape/result; verify the first slice on both input methods.
4. Build Get Cash and Find the Lost Phone with their bosses, then add Chaos Friend, persistent content unlock and character-specific party results for the full run.

## Open decisions and deferred scope

The first-release cast is Hype Man and Chaos Friend; the final city name and detailed writing remain open. Preserve the approved compact Hype Man proportions/palette and detailed room direction when expanding asset production. The design fixes run length target, death reset, one found-gun slot with limited ammo, two consumable slots, one gear slot, content-only unlock and friend-specific party endings. Exact drop frequencies, damage and durations remain prototype tuning values until playtesting.

Co-op, companion AI, fully generated room geometry, extra districts, networking, large weapon collections, permanent combat upgrades and elaborate party-ending systems remain deferred. The first-release room **routes** are procedurally assembled from authored pieces. A modular single-player prototype does not make later co-op automatic. No release date, commercial model, budget or title clearance is assumed.

## Technical references

The implementation and local build workflow were checked against the official [GameMaker command-line build documentation](https://manual.gamemaker.io/lts/en/Settings/Building_via_Command_Line.htm), [gamepad input reference](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Game_Input/GamePad_Input/Gamepad_Input.htm), and [audio buffer API](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Buffers/audio_create_buffer_sound.htm). The product scope comes from the supplied brief and the user's controller follow-up.
