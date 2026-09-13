# Last Stop environment correction

The first implementation simplified the approved concept too aggressively. This revision uses the approved imagery as the asset source, preserving its architecture, lighting, detailed product displays, wall posters, security camera, plants, wet-floor sign, floor wear and perimeter stock.

Two built-in image_gen edits removed characters/projectiles from the reference and created the clean floor beneath removable props. Aseprite then resized and sliced those plates into a layered room source, left and right shelf sources, and a crate source. These are concept-derived raster assets; individual wall posters and products are not independent procedural tiles.

All sources, reference plates, exports and the preparation script are stored inside the Side Quest project in art/environment-v2 and datafiles/environment-v2. Earlier assets are retained for history; the room renderer uses the environment-v2 exports.

The game now renders at 1280 × 720 with a 640 × 360 camera, preserving gameplay units and input mappings. The fixed background retains lighting and perimeter art; shelves and crate draw independently with ground sorting. Tall props fade when an actor occupies the lane behind them. Collision footprints and spawns match the retained prop positions.

The assembled room is preserved in art/environment-v2/assembly-preview.png; the current game capture is in art/hypeman-v8-proof/review/game-renders/combat.png. The unchanged game HUD, live actors, projectiles and clearance states differ from the concept. Cleanup edits and resolution conversion mean this is not a byte-for-byte copy of the original image.

The detailed room design is approved. Its original environment pass passed 77 gameplay/layout checks; the combined environment and compact Hype Man v8 build now passes 94 checks plus the runtime smoke test. Visual captures confirm 1280 × 720 output. The compact idle/run/fire/dodge proof is also approved; the remaining character animation work is listed in docs/hypeman-v8-proof.md. Physical controller feel remains a manual playtest check.
