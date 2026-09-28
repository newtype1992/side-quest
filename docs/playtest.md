# Combat milestone playtest

Current scope: approved Last Stop environment and compact Hype Man v8. See [PROJECT_CHECKPOINT.md](PROJECT_CHECKPOINT.md). A visual approval is recorded; this form still needs a physical-device playtest.

Use this after compiling the current project. Test several attempts with keyboard/mouse and then with a physical controller. Record your initial reaction before tuning. The aim is to discover one concrete issue to fix next.

Build/date: ______  Input device/controller model: ______

| Attempt | Cleared or died | Time | Accuracy | Damage | One observation |
| --- | --- | --- | --- | --- | --- |
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |
| 4 | | | | | |

## Input and lifecycle checks

- [ ] Move in all directions without diagonal speed gain.
- [ ] Aim behind you while moving forward; hold fire through a reload.
- [ ] With controller, release the right stick and confirm aim stays put.
- [ ] Test light and full left-stick movement and check for unwanted drift.
- [ ] Roll while moving; try changing direction during the roll.
- [ ] Dodge an incoming projectile early in the roll and compare a late hit.
- [ ] Reload, roll, and confirm the reload resumes after landing.
- [ ] Use Make Some Noise near bullets, then press it again during cooldown.
- [ ] Switch between mouse/keyboard and controller during an attempt.
- [ ] Disconnect the active controller; verify pause and resume after reconnecting.
- [ ] Switch away from the game window and back; verify explicit resume.
- [ ] Die, restart, clear the room, and restart again; confirm fresh health and enemies.

## Feel and readability

For each hit you take, describe what hit you and what you expected to happen. Check that bullets remain visible over shelves and sprites. Watch for enemies stuck at obstacles, overlapping tells, misleading hitboxes, or an active ability that solves every encounter automatically.

Rate movement, aim, dodge, gun feedback, and readability from 1 to 5. State whether you wanted another attempt and why. A failed room can still be a good test if its mistakes were understandable.

Biggest issue: ______

Proposed single tuning change: ______

Result after repeating the same input device and encounter: ______

Keep balance observations separate from bugs. Preserve a working version before changing the tuning values. Do not expand content until both input devices meet the combat gate in the production plan.

## Compact character completion checks

Run after the five finishing animation groups are integrated. Mark unfinished groups as pending rather than passing their current fallback poses.

- [ ] Feet and shadow remain anchored across idle/run/aim changes at gameplay size.
- [ ] Fire and reload read correctly in every aim direction, while standing and moving.
- [ ] Dodge interrupts/rejoins reload cleanly; gun hides during the tucked roll and returns without a pop.
- [ ] Hit reaction is clear without freezing movement or overriding roll/death incorrectly.
- [ ] Make Some Noise gesture matches its pulse; On a Roll effects fit the body and do not hide bullets.
- [ ] Death recoils backward, falls and holds a grounded pose in every view; restart resets animation state.
- [ ] Shelves occlude/fade correctly around the character and its weapon/effects.

Animation issues and reproduction steps: ______

Milestone decision (ready / needs another pass): ______

Reason and exact next fix: ______
