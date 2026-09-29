# Combat HUD placement pass

29 September 2026. The user supplied an Enter the Gungeon screenshot as a placement and style reference. In it, reload progress sits just above the character, while the equipped gun and clip count sit at the lower right. Side Quest uses those information positions with its own Pocket Pistol icon and existing cool navy, cyan, cream, and muted metal palette.

## Implemented

- A 42-pixel reload meter follows Hype Man's head during an active reload. It fills according to the existing reload timer, stays within the playable view at room edges, and disappears when reload ends or the player dies.
- The lower-right weapon panel displays an original pixel Pocket Pistol silhouette, its name, and current rounds over magazine capacity. Ammo comes from live player state; capacity comes from game configuration.
- The previous top-strip weapon, ammo, and reload display was removed. Ability readiness and threat count now use that space. The group-chat and control strips remain legible.

## Evidence and review state

GameMaker LTS compiled and passed 105 gameplay/animation checks, the input-adapter check, and the runtime smoke test. Log: `work/test-c018b6ecdd0c4ba5957db21923e9d83c.log` (ignored local build output). Actual 1280×720 engine captures: [combat](../art/hypeman-v8-proof/review-v9/game-renders/combat.png) and [reload](../art/hypeman-v8-proof/review-v9/game-renders/reload.png). Both use 640×360 native game coordinates at 2× display size. The reload capture shows the bar over the player and the updated count at lower right.

Technical integration and in-context legibility have been checked. Creator visual acceptance and live play with keyboard and physical controller are pending. The panel may be refined after those reviews, especially if it hides an important encounter cue at the lower-right edge.

## Process note

Transfer information hierarchy and placement from a reference, then redraw the symbol in the project's own palette and pixel scale. Verify the actual engine framebuffer: the HUD can look tidy in isolation while colliding with the room, chat, or projectiles.

Newtype source: pixel-art UI practice, style selection, and pixel-art quality checklist. Runtime skill: `pixel-art-ui-skill`. No Newtype agent was used.
