# Prototype validation

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
