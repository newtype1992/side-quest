# Bring Ice first playable level

Stage 2 build specification, 29 September 2026. This is one short errand level that proves the [full-run game design](game-design.md) with Hype Man. The approved Last Stop environment and Hype Man animations remain the visual baseline. The current fixed combat room is a prototype, not evidence that this level already runs.

## Player route and result

The friends are leaving for the party when a group message asks for ice. Hype Man enters the convenience store. A run seed assembles 4–6 store rooms before the fixed Armored Night Manager arena. The player can explore a fork and loop, clear encountered combat rooms, and use an optional branch for a resource. Finding the boss room is sufficient; clearing every store room is unnecessary. The manager guards the last bag of ice. Defeating the manager exposes it, and Hype Man must take it and use the exit. The result screen confirms **ice secured**, shows time, kills, accuracy and damage, and offers a new attempt. It does not pretend the friends have reached the party.

Death anywhere in this slice ends the attempt and restarts Bring Ice with a new seed, full baseline health, the Pocket Pistol and empty item slots. The slice has no Chaos Friend unlock because it is not a full three-errand clear. Chat appears before combat and at the result, never over active bullet patterns.

## Generated store contract

- **Count:** 4–6 non-boss rooms, including a safe entrance. The fixed manager arena is additional. The boss room is reachable by at least one cleared route without entering every side room.
- **Shape:** connected graph with at least one choice of route and one loop; one reward or recovery room is optional. All doors connect matching authored sockets. Revisited cleared rooms stay clear.
- **Room bank:** at least eight authored store pieces covering entrance, checkout, snack aisle, produce, freezer front, refrigerated aisle, stockroom and loading/receiving. A piece may serve a combat or resource role only when its cover, spawn and door zones support that role. Reuse approved Last Stop materials and scale; do not copy its one fixed layout as every generated room.
- **Assembly:** seed chooses topology, pieces, enemy groups and pickups. Save/log the seed for reproduction. Reject and regenerate any layout with an unreachable boss, disconnected optional room, blocked doorway, blocked player/enemy spawn or an unwinnable combat lock. A generated room's walkable space, bullet lanes and shelf fading must remain readable at 1280×720.
- **Navigation:** show discovered rooms and current position on a small map; M/View opens the full discovered map while exploration pauses. Show the boss marker only after its room is found. The map shows the route through the loop so the player can return without guessing.

Two topology examples, with **E** entrance, **C** combat, **R** optional resource, **B** boss. The comma-separated links are undirected doors. B is not part of the 4–6 non-boss count.

| Example | Non-boss rooms and links | Required proof |
| --- | --- | --- |
| Four rooms | `E-C1, C1-C2, C1-R, R-C2, C2-B` | `E→C1→C2→B` reaches boss; `C1→R→C2→C1` makes R optional and forms a loop. |
| Six rooms | `E-C1, C1-C2, C1-C3, C2-C3, C2-C4, C3-R, C4-B` | `E→C1→C2→C4→B` reaches boss; `C1→C3→C2→C1` forms a loop, while R is an optional resource branch. |

For both examples, combat locks apply only to the room entered. The map generator may produce other valid graphs within the same contract. A branch can be skipped without preventing the boss fight; optional rewards must never contain a required key or the ice.

## Encounter and pickup design

The first slice starts with Hype Man's current six-health, eight-round Pocket Pistol, dodge and abilities. Store combat rooms mix the existing melee charge and ranged fan enemies in increasing combinations, with safe spawn spacing, visible tells and cover that helps rather than traps the player. A cleared room stops spawning enemies and hostile bullets before doors reopen. Backtracking never repeats a pickup.

The optional branch and combat rewards demonstrate one limited-ammo **Stockroom Scattergun**, Pocket Sand, Hot Sauce, Questionable Sneakers and a small health recovery. The player can carry the Pocket Pistol plus one found gun, two single-use consumables and one passive equipment item. Found-gun ammo and carried items persist through rooms; the pistol remains usable after the scattergun is empty. Side rewards vary by seed but the test fixture must expose every item at least once across recorded seeds. No shop, spendable cash, ice-as-weapon choice or second friend is part of this proof.

The new controls are the full-design controls: 1/2 or D-pad selects a consumable, Q/LT uses it, Tab or mouse wheel/Y swaps guns, F/B interacts with a pickup, ice or exit, and M/View opens the map. Existing movement, aim, fire, dodge, reload, active and pause remain intact. A prompt names the active device's control. Empty-slot use, an empty found gun and a full inventory give clear feedback without consuming another action.

## Armored Night Manager

The manager fights in a fixed store/freezer arena with clear floor markings and useful but nonblocking cover. Their attacks are deliberately different from the existing melee and ranged enemies:

1. **Cart lane:** a visible straight lane and committed direction precede an armored cart charge. After the charge, the manager has a recovery window. The charge cannot turn to track the player after the tell.
2. **Freezer volley:** a visible wind-up precedes separated projectiles with a dodgeable gap. Bullets stand out against freezer lighting and remain visible over props.
3. **Stock toss:** a marked landing area precedes a thrown stock item. The mark and impact are readable even while Hype Man's active pulse or buff is visible.

The manager cannot be stun-locked by Pocket Sand or Hype Man's active. A hit can briefly interrupt but must not skip every committed attack. The fight ends on boss defeat, clears hostile bullets, and reveals the one bag of ice. The ice cannot be collected before victory or twice. The exit remains inactive until Hype Man takes it; leaving then shows the result.

## Build order and acceptance

1. Extract the approved combat room into a reusable room-state boundary while preserving its art, collision, enemy behavior and input feel. Prove one authored entrance, combat room and boss transition before random assembly.
2. Add seeded topology and authored piece selection, discovered map and room-clear persistence. Verify the two sample graphs and many generated seeds before adding reward randomness.
3. Add the scattergun, two consumable slots, Sneakers and new controls. Verify selection, use, replacement, limited ammo, death reset and device switching.
4. Add the manager encounter, guarded ice pickup and exit/result. Record GameMaker captures and play several keyboard/mouse and physical-controller attempts.

Acceptance requires: reproducible connected 4–6-room layouts with a fork and loop; optional rewards that are genuinely skippable; no blocked spawn or door; readable combat and boss tells at gameplay size; no duplicated reward or ice; correct death/restart; and a result that unmistakably says the ice errand is complete. The first-slice completion claim also needs human playtest evidence. It does not claim the full night, Chaos Friend, remaining errands or party ending are built.
