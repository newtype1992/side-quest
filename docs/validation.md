# Prototype validation

## Action animation pass — 29 September 2026

The v9 action pass compiled in GameMaker LTS 2026.0.0.23 and passed 108 gameplay/animation/input-arbitration checks, the input-adapter check, and runtime smoke test. Native 1280×720 captures cover reload, hit, active ability, moving reload/ability, and death in the Last Stop room, plus four-view galleries. See [hypeman-v9-action-pass.md](hypeman-v9-action-pass.md) for sources, review links, and remaining human acceptance checks. This is technical verification, not a completed physical-device playtest or creator visual approval.

The 29 September Scuf playtest exposed a device-switching defect: mouse movement could override controller trigger activity in the same frame, leaving fire mapped to the mouse. Explicit controller buttons now take priority over pointer movement; explicit keyboard/mouse actions can still switch back. Regression checks cover both directions and idle stability. Latest log: `work/test-92e7ccc488bc4b83944550ba3882e035.log`. A repeat test on the actual Scuf controller is still required to confirm the reported symptom is resolved.

The repeat Scuf test still failed to fire with RT. A live F2 input diagnostic was added so the pressed trigger's mapped and raw values can be observed; see [controller-rt-diagnostic.md](controller-rt-diagnostic.md). The arbitration fix remains valid for its tested case, but it did not resolve this controller's reported RT behavior.

## Current baseline — 13 September 2026

The approved room and compact Hype Man proof compiled on GameMaker LTS 2026.0.0.23. The latest pre-publication run passed **94 checks, zero failures**, plus the input-adapter check and runtime smoke test. Its log is `work/test-f253f53a99014cfda91ba41eb88d505e.log`. Actual game captures use 1280 × 720 rendering with 640 × 360 gameplay coordinates. The user approved the room and compact idle/run/fire/dodge visuals.

Native character asset checks verified 100 frames, 24 clips, 16 colors, binary alpha and clear canvas margins. Five animation finishing groups and a recorded physical-controller/keyboard playtest remain; see [PROJECT_CHECKPOINT.md](PROJECT_CHECKPOINT.md). The tests do not establish feel, enjoyment or finished character production.

## Historical initial baseline — 12 September 2026

The sections below record the initial prototype and its then-current limitations. Their 34-test count and temporary-art descriptions are historical, not the current build status.

Validation date: September 12, 2026. Runtime: GameMaker LTS 2026.0.0.23, Windows x64 VM.

## Verified

- The native GameMaker resource graph loads and links, and the project compiles successfully.
- **34 gameplay assertions pass with zero failures**, running against the actual GML functions in GameMaker. Coverage includes normalized movement, analog deadzone scaling, movement at 30 and 60 updates, walls and shelves, dodge commitment and invulnerability, damage grace, gun cadence, manual/automatic reload, projectile tunneling, enemy death, passive refresh, breakable cover, active range/cooldown, navigation around shelves, ranged attack tells, death, and restart reset.
- A runtime smoke run steps and renders the game for 120 frames and exits normally. The final tested run reports no runtime errors or audio warnings.
- The real input adapter executes successfully and detects a connected controller in slot 0. Detection alone does not verify every physical button or analog response.
- Native 640 × 360 framebuffers were inspected for the combat, controller HUD, briefing, pause, death, and clear states. Text fits, bullets remain distinguishable, and the pixel presentation is crisp. These are deliberately staged render checks, not evidence of a human completing a run.
- The reusable `tools/Build.ps1 -Action Test` command was executed successfully, including its compile, log, timeout, and success-marker checks.

## Not yet established

Physical keyboard/mouse and controller playtesting, hot-unplug/replug behavior with a person playing, subjective audio quality, real combat feel, balance, and enjoyment still need the creator's testing. The automated checks do not establish parity with Enter the Gungeon. There is no final sprite-animation validation because the art remains temporary.

Windows standalone packaging was attempted but GameMaker rejected it with **Reason Code 0000002A, Permission Error Unable to obtain permission to execute**. Compile and local Runner execution succeeded with the existing profile. No standalone executable package is included; use GameMaker F5 or Play.cmd. Sign in with a GameMaker profile allowed to export and retry packaging when a shareable executable is needed. No account or licensing settings were changed.

## Repeat validation

From the project folder, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\Build.ps1 -Action Test
```

Generated logs and the `.win` file are kept under the ignored `work/` directory. Complete `docs/playtest.md` before moving beyond the combat feel milestone.
