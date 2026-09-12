# Side Quest production plan

The immediate objective is a combat room worth replaying. The attached Side Quest Project Brief supplies the design direction: a single-player, top-down action roguelite about adult friends trying to reach a house party while ordinary errands become dangerous detours. GameMaker is the intended engine, and true pixel art and responsive gun combat are central to the direction.

This plan treats confirmed design choices, proposed examples, and open questions separately. The brief's roadmap is design context, not an instruction to implement every feature at once. The direct request authorized planning or beginning production; the follow-up specifically added controller support from the start.

## Current production baseline

The first combat room has been implemented in the existing GameMaker project structure. It includes movement and independent aiming, keyboard/mouse and controller input, one pistol, reload, dodge, health, death, restart, two enemy archetypes, solid shelves, a breakable crate, attack tells, hit cues, sound, and clear/death results. Hype Man's proposed passive and active are implemented for immediate testing.

The graphics, room layout, weapon identity, combat numbers, and Hype Man appearance are temporary. The build establishes a baseline for tuning; it has not established that the combat is fun or matches the reference's feel. A combat clear is the current ending. There is no ice pickup or multi-room mission yet.

## Working decisions

| Decision | Status and reason |
| --- | --- |
| GameMaker and GML | Follows the brief and the existing project. |
| Windows first | Provisional development target matching the installed environment. |
| Keyboard/mouse and controller | Controller support explicitly requested during this task. |
| Hype Man first | Provisional selection: both proposed abilities work in one room. |
| 640 × 360 native, integer scaling | Provisional readability test; approve before final asset production. |
| Eight-round pistol and infinite reserve | Isolates shooting and reload feel from ammunition economy. |
| One handmade encounter | Keeps tuning repeatable while testing combat fundamentals. |
| Adult cast and original assets | Follows the brief's 21+ character direction and original nightlife setting. |

## Milestone 1 Combat feel

**Status:** implementation baseline complete; human playtest pending.

Play several attempts with each input device. Tune movement, stick response, dodge commitment, the vulnerable end of the roll, projectile speed, enemy tells, and gun feedback. Change one major variable per comparison. The relevant inputs and metrics are available in the build and the playtest form.

**Exit gate:** movement and aiming feel reliable with both devices; players can explain why damage occurred; enemies remain reachable around cover; death and restart stay quick; repeated attempts remain interesting. Do not count automated checks as evidence of enjoyment. Record the preferred tuning and any unresolved issues before increasing content.

## Milestone 2 Character and item choices

**Status:** Hype Man abilities are available for tuning; item work remains.

Validate the kill buff and ten-second projectile clear first. Decide how consumables are held and activated, then implement two consumables and one equipment item. Suggested candidates from the brief are Pocket Sand, Party Popper, and Questionable Sneakers. Check whether Party Popper duplicates the Hype Man active too closely; replace or differentiate it if testing shows no meaningful choice. Keep item slots and character active input separate.

**Exit gate:** the player can describe a useful situation for every item, activate it comfortably on controller and keyboard, and still read enemy bullets and damage cues. Add automated checks for consumption, cooldowns, interruption rules, and restart reset when those systems exist.

## Milestone 3 Bring Ice playable slice

**Status:** planned.

Build three handmade rooms: departure and group message, convenience-store encounter, and escape/result. Add an explicit quest state sequence: not started, accepted, ice collected, escaped, result. Integrate the player and combat modules into room definitions, retain health/items across room transitions, and prevent repeated rewards or pickups.

Start with intact ice delivery. Once the full sequence works, add the proposed choice of using the bag in combat for a reduced reward if that choice improves the mission. Write short original group-chat reactions for success and failure. The party and romance systems are unnecessary for this gate.

**Exit gate:** someone unfamiliar with the project can understand the errand, finish the three-room sequence, recognize the result, and restart. Dialogue does not obscure an active fight. Quest state survives intended transitions and resets on a new run.

## Milestone 4 Second friend and art slice

**Status:** planned after the first mission is stable.

The Chaos Friend is a useful second candidate because close-range damage and a destructive charge can be tested without shops or a full inventory. This is a recommendation, not a finalized cast decision. Give that friend exactly one passive and one active; preserve the shared movement, aim, gun, and dodge systems. The charge must remain distinct from an invulnerable dodge.

In parallel with this milestone's design work, settle the art grid and create one approved friend, one enemy, a gun/projectile, and a convenience-store room at actual gameplay scale. Replace the temporary graphics in a contained art pass. Do not expand a sprite catalogue until silhouettes, bullet contrast, animations, and alignment work in the build.

**Exit gate:** character choice changes tactics using the same combat foundation, and the small art set remains clear during movement and incoming fire.

## Ordered next backlog

1. Run the keyboard and physical controller playtest; record the controller model and any mapping issues.
2. Fix input or readability failures before balancing difficulty.
3. Tune roll timing, gun cadence, enemy cadence, and arena composition using repeated attempts.
4. Decide item capacity, selection, and activation controls; prototype the three small items.
5. Implement reusable room definitions and the three-room quest state flow.
6. Test the complete Bring Ice sequence, then choose the second friend and approve the art slice.

## Open decisions and deferred scope

Choose the final cast, city setting, art dimensions and palette before expanding narrative or asset production. Weapon switching and a second gun belong after the single-gun feel gate; ammunition scarcity is still undecided. Inventory behavior precedes item production. Run length, death consequences, time progression, permanent unlocks, and party endings need decisions before a broader run structure is built.

Co-op, companion AI, procedural maps, multiple districts, networking, large weapon collections, and elaborate party endings remain deferred. A modular single-player prototype does not make later co-op automatic. No release date, commercial model, budget, or title clearance is assumed.

## Technical references

The implementation and local build workflow were checked against the official [GameMaker command-line build documentation](https://manual.gamemaker.io/lts/en/Settings/Building_via_Command_Line.htm), [gamepad input reference](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Game_Input/GamePad_Input/Gamepad_Input.htm), and [audio buffer API](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Buffers/audio_create_buffer_sound.htm). The product scope comes from the supplied brief and the user's controller follow-up.
