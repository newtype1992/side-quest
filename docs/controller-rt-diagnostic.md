# Scuf RT diagnostic

29 September 2026. The physical Scuf controller still cannot fire with RT after the input-source priority fix. Other gamepad controls work. The previous fix addressed simultaneous mouse activity, but this report shows it did not resolve the trigger signal; do not describe the Scuf issue as fixed yet.

GameMaker LTS identifies the connected device as `XInput STANDARD GAMEPAD` in slot 0. The idle `gp_shoulderrb` value is 0. GameMaker's documented right-trigger constant is `gp_shoulderrb`, and `gamepad_button_value` reports its raw analog value without applying the configured button threshold. These facts do not show what happens when the Scuf RT is pressed.

Press F2 while running `Play.cmd` to open the input diagnostic. Capture one screenshot with RT released and one while holding RT. The panel shows the selected input device, gameplay fire command, mapped RT/RB/LT values, raw axes, and raw buttons. F2 closes it. Compare the two screenshots:

- If mapped RT rises but `GAME FIRE` stays 0, correct the input-source or threshold logic.
- If another raw button or axis changes while mapped RT stays 0, use the controller-specific mapping evidence to correct the binding.
- If no input changes, inspect iCUE's active profile and the physical RT mode before changing game bindings.

The diagnostic overlay compiled, rendered in a 1280×720 GameMaker capture, and the 108-check suite, input adapter, and runtime smoke test passed. [Idle diagnostic capture](../art/hypeman-v8-proof/review-v9/game-renders/input-diagnostic.png). A pressed-RT capture and physical confirmation remain pending.

Reference: [GameMaker gamepad input constants](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Game_Input/GamePad_Input/Gamepad_Input.htm), [raw button values](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Game_Input/GamePad_Input/gamepad_button_value.htm). The user's iCUE mapping report is direct playtest feedback.
