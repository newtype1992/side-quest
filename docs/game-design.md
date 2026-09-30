# Side Quest game design

Stage 2 design specification, 29 September 2026. This is the canonical rule set for the first Steam on Windows release. It implements the [Stage 1 concept](game-concept.md) as a 25–35 minute, combat-led night out. These are **design decisions**, not claims that the current single-room GameMaker prototype already contains them. The [Bring Ice specification](bring-ice-level-design.md) defines the first buildable slice.

## Player promise and run loop

Fast, readable room combat leads. The errand and group-chat framing gives every level a funny objective without obscuring bullets or interrupting an active fight. A run follows this fixed order:

1. Choose Hype Man or, after unlocking them, Chaos Friend.
2. **Bring Ice:** fight through a generated convenience-store route, defeat the Armored Night Manager, take the ice and escape.
3. **Get Cash:** fight through a generated nightclub/ATM route, defeat Club Security, secure the cash and escape. The cash is a quest item, not spendable currency.
4. **Find the Lost Phone:** fight through a generated underground fight-club route, defeat its Champion, recover the phone and escape.
5. Reach the house party. Show a short, character-specific result with fade-to-black romantic outcomes where appropriate. Arrival is the win condition; time, accuracy and damage can be displayed but do not select the ending.

The three errands are levels. A room is one encounter or resource space within a level. Later runs vary through room arrangement, encounters, pickups, the carried gun and the selected friend; the first release does not shuffle or skip the three errands.

## Level and room rules

| Rule | Required behavior |
| --- | --- |
| Room assembly | Each errand uses a run seed to assemble 4–6 non-boss rooms from authored, theme-specific pieces, including the entrance. The same seed and game content reproduce the same layout, encounters and rewards for QA. |
| Topology | The room graph is connected, has at least one fork and one loop, and gives a reachable route from entrance to boss. Side routes are optional and may offer healing, a consumable, gear, a found gun or ammo. There is no required key or all-room-clear gate. |
| Templates | Authored room pieces define doors, walkable space, cover, spawn zones and environment identity. Generated connections must match doors; no exit may lead into a wall or inaccessible spawn. The existing Last Stop art is the approved visual reference for store pieces. |
| Combat lock | Entering an uncleared combat room closes its exits until its enemies are defeated. Clearing removes remaining hostile bullets and opens exits. Revisited cleared rooms do not respawn enemies or rewards. Entrance and resource rooms are safe unless explicitly marked as combat templates. |
| Navigation | The small map shows discovered rooms and the player's position. View on controller or M on keyboard opens the full discovered-room map. An unseen boss room is not revealed early; once discovered it remains marked. |
| Boss | Every errand ends in a fixed authored arena with readable cover, tells and dodge routes. Finding the boss room is enough to fight it. The boss room stays locked during combat. Boss defeat reveals its one-time quest objective. |
| Level completion | Boss defeat alone does not advance the run. The player must take the objective and use the exit. At exit, restore 2 health up to the existing maximum of 6, preserve carried health, guns, ammo, consumables and gear, then begin the next errand. No reward or objective can be collected twice. |

The first implementation should show at least a short entrance-to-boss route and a genuinely optional branch on every seed. A loop supplies an alternate return route so exploration does not depend on long dead-end backtracking. Procedural assembly varies the route; combat-room layout and boss geometry remain authored for readable fights.

## Combat, inventory and input

Keep the current movement, eight-way independent aiming, Pocket Pistol, committed dodge, health, hit grace, reload and Hype Man abilities as prototype tuning defaults until playtesting identifies a change. The Pocket Pistol has its existing eight-round magazine and unlimited reserve ammunition. The player carries it plus **one** found gun. Found guns have limited total ammunition, retain it across rooms and levels, and can be swapped with a ground gun using Interact; the replaced gun drops. An empty found gun remains carried until replaced. The small first-release pool adds a short-range scatter role and a controlled burst-fire role, with grounded gun behavior and comic errand/nightlife presentation. Optional rooms can supply limited found-gun ammo; level transitions do not refill it.

The player has two consumable slots, one use per slot with no stacking, and one passive equipment slot. **Pocket Sand** briefly interrupts and blinds ordinary enemies in front of the player. **Hot Sauce** temporarily adds burn to gun hits; a second use refreshes rather than stacks the effect. **Questionable Sneakers** make a dodge leave a short slippery trail that disrupts pursuers, without changing the dodge's invulnerability timing. Bosses may briefly stagger from a consumable but cannot be stun-locked or have an entire attack phase skipped. A pickup fills an empty slot; when both consumable slots are full, the player must use one before taking another. Equipment duplicates have no effect.

| Action | Keyboard/mouse | Controller | Status |
| --- | --- | --- | --- |
| Move / aim / fire | WASD / mouse / left mouse | Left stick / right stick / RT | Existing |
| Dodge / reload / friend active | Space or right mouse / R / E | A or LB / X / RB | Existing |
| Select consumable | 1 or 2 | D-pad left or right | New; selection does not consume |
| Use selected consumable | Q | LT | New; empty slot gives feedback without an action |
| Swap Pocket Pistol and found gun | Tab or mouse wheel | Y | New; unavailable when no found gun is carried |
| Interact with objective, gun, item or exit | F | B | New; only when a nearby prompt is shown |
| Full discovered-room map | M | View | New; exploration pauses while open |
| Pause / confirm | Escape / Enter | Start / A or Start | Existing; combat bindings do not trigger behind menus |

The item, weapon, interact and map bindings are design targets, not existing input behavior. Keep on-screen prompts matched to the active input device. Selection and swapping cannot fire, dodge, reload or trigger the friend's active. A committed dodge or death prevents using an item or interacting until that state ends. Room transitions clear bullets and transient attack effects; cooldowns and temporary buffs continue according to their remaining time rather than resetting for a free advantage.

## Friends and progression

Hype Man is available from the first run, using the approved visual and current On a Roll and Make Some Noise rules. Completing the **first full three-errand night** unlocks Chaos Friend for future runs. Chaos Friend shares movement, aim, gun and dodge controls. Their passive increases damage at close range. Their active is a committed forward charge that knocks enemies aside and breaks breakable cover; it gives no automatic invulnerability and cannot pass through solid walls. Exact damage and timing are playtest values, not a different control scheme.

Health, guns, ammo, consumables and gear persist only during a night. Death anywhere ends that night, clears all run resources and returns to character selection before a fresh Bring Ice seed. Unlocked content persists between runs; there are no permanent health, damage or other combat-strength upgrades. Reaching the party records completion and leaves Chaos Friend unlocked. A new night always starts with baseline health, Pocket Pistol and empty item slots. No in-progress room or objective carries into a new run.

## Errand identity and bosses

| Level | Room identity | Boss and readable attack intent | Objective after boss |
| --- | --- | --- | --- |
| Bring Ice | Checkout, aisles, fridges, freezer and stockroom pieces in one convenience store. | **Armored Night Manager:** marked cart lane charge, spaced freezer-volley projectiles and a marked stock toss. Cover and clear gaps support dodge timing. | Take the last bag of ice and leave. It is carried as a quest flag, not a consumable. |
| Get Cash | Club entrance, dance floor edge, service corridor and guarded ATM. | **Club Security:** visible spotlight/aim lock, a short baton rush and a separated projectile burst. The tells must remain visible against club lighting. | Secure the group cash and leave. It cannot be spent. |
| Find the Lost Phone | Back corridors, lockers and ringside rooms in an underground fight club. | **Fight Club Champion:** marked melee arcs, a committed rush and an expanding attack with a dodgeable gap. The arena keeps the player and tells visible. | Recover the phone and leave. |

Each boss has a fixed authored arena, distinct silhouettes and a vulnerable recovery after committed attacks. Later errands increase combinations and pressure through encounter composition rather than hiding tells or granting unavoidable damage. Original assets and night-out humor distinguish Side Quest from its combat reference.

## Stage 2 boundaries and current implementation gap

The first playable proof is **Bring Ice with Hype Man**: generated store rooms, map, one found scatter-role gun, two consumables and Sneakers, the manager boss, ice pickup and an escape/result. It does not need Chaos Friend, the other errands or the party scene. Completing this slice proves one level, not the full run or the 25–35 minute target.

The current GameMaker project contains one fixed Last Stop encounter, a single gun, no inventory or item commands, no generated room graph or map, no boss, no ice pickup, no cross-room run state and no persistent unlock. Its combat and approved art remain the starting point. [The Bring Ice specification](bring-ice-level-design.md) defines the first conversion. The recorded keyboard/mouse and physical-controller combat-feel playtest remains a separate gate; passing automated checks or writing this design does not close it.

## Design verification scenarios

| Walkthrough | Expected state |
| --- | --- |
| From Bring Ice entrance, clear a route to the boss while skipping the optional resource room; defeat the manager, take ice and use the exit. | Get Cash starts. Boss discovery never requires clearing every room. Objective pickup and exit, not the kill alone, advance the level. |
| Enter a combat room, clear it, leave and return; later discover the boss. | The old room stays clear, rewards do not respawn and the boss appears on the discovered map only after discovery. |
| Leave Bring Ice at 4 health with a partly used found gun and one consumable. | Get Cash begins at 6 health after the +2 recovery; the same gun, remaining ammo and consumable carry forward. Exiting cannot grant the heal twice. |
| Die in any room or boss fight. | The night ends. A new attempt begins at Bring Ice with baseline health, Pocket Pistol, empty items and a fresh seed; a previously unlocked Chaos Friend remains available. |
| Complete all three errands for the first time, then start another night as Chaos Friend. | The party result uses the selected friend's variant; Chaos Friend is permanently available. Score and quest-item handling do not change that ending selection. |
| Use new item, gun, interact and map controls on keyboard/mouse and controller. | Existing fire, dodge, reload, friend active and pause still respond to their original inputs; controls do not leak through a menu or committed dodge. |

Static design review on 29 September checked the four- and six-room example graphs in [bring-ice-level-design.md](bring-ice-level-design.md): both are connected, have a fork and loop, and retain a route to the boss when the optional resource room is skipped. The proposed new keyboard/controller bindings do not duplicate existing gameplay bindings in `sq_input.gml`. Generated layouts, encounter balance and physical input feel still require runtime testing after implementation.

The design is complete when these rules, the first-slice contract and the project plan agree. Runtime behavior remains unverified until the features are implemented and played.
