# Hype Man action animation pass

29 September 2026. This is a playable, technically verified action pass awaiting creator visual review and hands-on feel testing. It preserves the approved v8 idle, run, fire and dodge work and does not alter the combat timings.

## Reference study

The target is the *readability and response* of Enter the Gungeon, using original Hype Man art and Side Quest rules. The [official gameplay trailer](https://www.youtube.com/watch?v=J3kPMRA_JYE) is the visual reference for compact characters acting amid dense bullets and props. Designer Dave Crooks describes shooting and dodge rolling as core mechanics, with the first part of a roll safe and the landing vulnerable in his [PlayStation gameplay guide](https://blog.playstation.com/2016/04/05/how-to-get-started-in-enter-the-gungeon-on-ps4/). In his [Game Developer interview](https://www.gamedeveloper.com/design/q-a-the-guns-and-dungeons-of-i-enter-the-gungeon-i-), he describes reload as a deliberate moment of tension and says constant active-reload demands were too much for new players. Side Quest therefore keeps its existing 0.9-second reload and dodge rules, and makes the action readable without adding a timing minigame.

This is an inference from those design statements, not a claim about Gungeon's exact sprite frame counts: a short, distinct action pose should acknowledge input promptly while bullets, player direction, and the vulnerable part of a roll remain legible. We adopt that staging principle and the protected-start/vulnerable-end dodge relationship. We do not copy Gungeon's character design, frames, weapons, or environment.

## What changed

| Group | Native animation and gameplay link |
| --- | --- |
| Reload | Three distinct pose phases in each of four body views over the existing 900 ms reload: 120 ms reach, 600 ms magazine contact, 180 ms return to aim. The pistol is part of the pose; dodge pauses reload and the animation resumes at its retained phase. |
| Hit | A directional body flinch and recovery in four views. Facing and incoming force direction are captured when damage occurs; the player can continue moving. The full-white flash lasts only 12 ms so it no longer obscures the pose. |
| Make Some Noise | Raised-arm gesture in four views, timed to the existing 520 ms cosmetic clock and pulse. It remains visible during reload; fire and dodge retain immediate priority. |
| On a Roll | Small cyan motes around the compact body replace the oversized v7 layers; the buff's gameplay duration and refresh are unchanged. |
| Death | Four-view 80 ms recoil, 240 ms backward fall, and 380 ms grounded hold. The final pose stays on screen until restart. |

While reload, hit, or Make Some Noise plays during movement, the renderer keeps the authored action upper body and uses the matching run-frame legs. Stationary actions retain their authored full-body poses. This keeps the hand gesture readable without making the character skate across the room.

The action source is [Hype-Man-v9-Actions.aseprite](../art/hypeman-v8-proof/Hype-Man-v9-Actions.aseprite). The [original action reference sheet](../art/hypeman-v8-proof/action-reference-v9.png) was generated from the approved Hype Man model; [build-v9.lua](../art/hypeman-v8-proof/build-v9.lua) converts its poses to the 16-color native palette, fixed 48×48 canvas, and (24,44) foot origin. It appends the new clips without overwriting the v8 master. The runtime atlas and metadata are `datafiles/hypeman-v8-proof/Hype-Man-Actions.*`.

## Verification and review evidence

- GameMaker LTS build, 105 gameplay and animation checks, input adapter check, and runtime smoke test passed on 29 September. Log: `work/test-da7d756daa0a41be86fbb50d1480edc7.log` (ignored local build output). The added checks cover moving reload legs and stationary authored feet.
- The new atlas has 144 native frames and 40 named clips. Export checks enforce the palette, binary alpha and clear canvas margins. Timed source previews are in [review-v9](../art/hypeman-v8-proof/review-v9/).
- An Aseprite pixel comparison found zero differences across all 100 approved v8 base frames in the new atlas.
- A fresh Aseprite CLI export of the saved v9 master recovered all 144 frames and 40 tags; every tag range and frame duration matched the runtime metadata.
- Actual 1280×720 GameMaker captures show [reload](../art/hypeman-v8-proof/review-v9/game-renders/reload.png), [hit](../art/hypeman-v8-proof/review-v9/game-renders/hit.png), [ability](../art/hypeman-v8-proof/review-v9/game-renders/ability.png), and [death fall](../art/hypeman-v8-proof/review-v9/game-renders/death-fall.png) in Last Stop. Four-view captures show the start, fall, and final death poses. These are rendered engine frames, not concept composites.
- The first capture exposed a source-grid error that placed detached shoes above reload poses. Manual cell bounds fixed it. A second capture exposed the old full-white hit flash hiding the new pose; it was reduced to an immediate 12 ms flash.
- A timing review found the return-to-aim pose began 300 ms before the pistol was actually ready. It now begins 180 ms before readiness, leaving the reload hold visible longer while preserving the 900 ms gameplay rule.
- Four-view engine captures of the [reload start](../art/hypeman-v8-proof/review-v9/game-renders/animation-reload-start.png), magazine contact, and [return to aim](../art/hypeman-v8-proof/review-v9/game-renders/animation-reload-ready.png) verify that all three source poses reach the runtime in the intended order.
- A dedicated [On a Roll room capture](../art/hypeman-v8-proof/review-v9/game-renders/hype.png) exposed motes that were too small and rendered yellow because of GameMaker's colour-literal ordering. The revised effect uses explicit RGB values and larger cyan/white clusters. Bullets draw later than the character effect, retaining their visibility.
- Actual GameMaker [moving reload](../art/hypeman-v8-proof/review-v9/game-renders/reload-moving.png) and [moving ability](../art/hypeman-v8-proof/review-v9/game-renders/ability-moving.png) captures show the action/run-leg composition in the room. Refreshed four-view [reload](../art/hypeman-v8-proof/review-v9/game-renders/animation-reload.png) and [ability](../art/hypeman-v8-proof/review-v9/game-renders/animation-noise.png) captures show its character-scale join. Still frames cannot establish live movement feel.
- The four-view hit fixture originally reused the right-facing hit latch for every label. It now sets each view's actual hit facing and impact direction. The corrected [engine hit gallery](../art/hypeman-v8-proof/review-v9/game-renders/animation-hit.png) shows distinct right, front, left, and back poses. The correction passed the 105-check suite, input adapter, and runtime smoke test again; log: `work/test-0ed7158004b147539cae1168a5b9f2c9.log`.

## What still needs judgment

- Creator feedback on 29 September: the reload animation looks good in play. Treat its current visual as accepted; keep the movement and dodge-interruption checks in the transition playtest.
- Review Hit, Make Some Noise, On a Roll, and Death in live play at the actual 2× game display. In particular, judge the force and direction of the hit, whether the ability gesture reads during movement, whether cyan buff motes distract from hostile bullets, and whether the backward fall finishes in a convincing grounded pose.
- Play several attempts on keyboard/mouse and a physical controller. Verify reload while moving, dodge interruption, turning aim during an action, hit reactions during reload, ability-to-fire response, damage readability, shelf occlusion, death and restart. Record concrete issues in [playtest.md](playtest.md).
- Overall creator visual approval has not yet been recorded. Reload has been accepted; the other actions and transitions remain pending. Automated checks and still captures cannot establish animation feel or match a reference game's quality.

## Process improvements to carry forward

1. Keep accepted masters immutable while building a versioned action source. Regeneration must not erase hand corrections.
2. Use explicit row and column crop bounds for generated reference sheets. Equal grid division admitted pixels from adjacent poses and was caught only in the engine capture.
3. Review an authored pose with all old flash and effect layers enabled. A mechanically passing animation can be invisible under legacy feedback.
4. Capture both enlarged four-view frames and the real combat room. Enlarged art exposes stray pixels; the room reveals whether actions survive its lighting, scale, shelves and bullets.
5. Keep technical validation, visual acceptance, and physical input feel as separate gates. Record which one each piece of evidence supports.
6. Capture world-space effects in the actual room. A character-only gallery omits them, and GameMaker colour literals can differ from a hex code's usual RGB reading; use explicit RGB construction for critical cues.
7. Check whether a full-body action pose holds the feet still while gameplay movement continues. Compose upper-body actions with locomotion legs when moving, then inspect the join at game scale and test the action timing separately.
8. Validate review fixtures as carefully as gameplay. Direction labels alone do not prove that a latched action state selected the corresponding sprite; initialize the latch for each view before capturing.

Newtype method used: game development lifecycle in production and testing; pixel-art animation production for timed action keys; GameMaker art integration for native export and runtime review. Runtime skills used: `pixel-art-animation-skill` and `gamemaker-art-integration-skill`. No Newtype agent was used.
