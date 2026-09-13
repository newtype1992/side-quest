# Last Stop environment v1

Six original editable Aseprite sources and PNG exports. Room art uses a 16-pixel floor grid at 640 x 360. Layered sources separate architecture, stock, lighting, and shadows. All runtime files are included in the GameMaker project.

Palette: navy/violet architecture, blue-gray quiet floor, cyan refrigerator strips and warm checkout light. Sign and fridge highlights animate slowly in GML with the run clock; pause freezes them.

Rebuild from the project root using Aseprite batch with --script-param project="<absolute project path>" --script art/environment/build-art.lua. This deliberately regenerates all six sources/exports; preserve manual Aseprite edits before regenerating.

Ground footprints and render anchors live together in sq_environment_layout. The room remains handmade. Actor collisions use footprints, not the upper artwork. Shelves fade to 42% when a player or enemy occupies the walkable space behind them.
