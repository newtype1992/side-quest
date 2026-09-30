# Side Quest game concept

Stage 1 concept definition, 29 September 2026. This document reconciles the original `Side_Quest_Project_Brief.docx` with the approved GameMaker prototype and the creator's decisions. The core experience, audience, platform and full-run goal are defined here. Individual levels, systems and content still need design and playtesting. The Newtype game development lifecycle treats those as later work rather than a reason to leave the concept undefined.

## Core concept

Side Quest is a single-player, top-down pixel-art action roguelite for PC action roguelite players. Fast, readable combat leads; a funny night-out story gives the fights their context. Adult friends try to reach a house party and hope to hook up while ordinary errands become absurdly dangerous detours. The player chooses one friend for a run, fights through compact rooms with independent aiming, gunfire and a committed dodge, and uses that friend's passive and active abilities. Group messages and encounters keep the other friends present. The full-run goal is to complete each level and reach the party.

The **confirmed identity** is the collision of responsive room combat with adult night-out comedy and recognizable errands. Enter the Gungeon is the reference for combat readability, movement and feel; Side Quest uses original characters, locations, weapons, enemies and art. The current Last Stop room proves the visual direction and basic combat controls, but it does not yet prove the intended full-night run.

## Intended player experience

1. **Immediate control:** moving, aiming, firing, reloading and dodging respond predictably on keyboard/mouse and controller. Damage has an understandable cause.
2. **A ridiculous errand with a real objective:** a mundane request such as bringing ice escalates into danger, but the player still knows what to collect and where to escape.
3. **Friends with different tactics:** each playable friend uses the shared gunplay and dodge foundation, plus one passive and one active ability. Their personalities come through in actions and group communication.
4. **Progress toward the party:** completing each level advances the run toward the party. Choices about detours, items and errands may change resources or the party outcome, but those consequences remain design candidates.

Combat clarity takes priority during fights; jokes, messages, effects and lighting must leave bullets, tells and damage readable. The cast and proposed romantic encounters are adults aged 21 or older. The creator chose more explicit language with fade-to-black romantic outcomes. The brief treats romantic success as a motivation, not a guaranteed reward.

## Audience and platform

| Area | Stage 1 decision | Later work |
| --- | --- | --- |
| Primary audience | PC action roguelite players. | Test whether the encounter satisfies those players before expanding story content. |
| First store and platform | Steam on Windows PC first, with keyboard/mouse and controller support. | Packaging, Steam integration, store requirements and any later macOS/Linux support belong to later stages. |
| Tone | More explicit language and fade-to-black romantic outcomes; adult friends and nightlife comedy. | Exact dialogue, content rating and individual outcomes belong to writing and launch planning. |

## What the game is and what it is not yet

**Established in the project:** Hype Man; one original convenience-store room; pistol, dodge, health, enemies and cover; Hype Man's abilities; approved pixel-art room and player animations; local Windows play; automated gameplay checks. The controller incident is closed. A repeated-attempt combat-feel playtest is still due.

**Defined for the first complete playable slice in Stage 2:** Bring Ice uses Hype Man, 4–6 seeded store rooms assembled from authored pieces, a fixed manager boss, ice pickup and escape/result. The original brief's three-handmade-room proposal has been superseded by the [Bring Ice level design](bring-ice-level-design.md). Exact dialogue and balance still need playtesting.

**Broader-game candidates, not current promises:** more than two selectable friends, optional detours beyond the three fixed errands, shops, a large gun pool, permanent combat upgrades, fully generated room geometry and co-op. Stage 2 has since committed to two friends, a small item/gun set, procedural assembly of authored rooms and friend-specific party results; none is implemented merely because it is designed.

## Stage 1 decisions recorded

1. **Primary promise — answered:** Fast combat with a funny night-out story. Combat responsiveness and readable encounters lead; story gives the action purpose and personality without stopping a fight.
2. **Target player — answered:** PC action roguelite players. The first slice should earn their interest through controls, enemy patterns and repeatable combat before relying on a larger narrative or progression system.
3. **Successful run — answered:** Complete each level and reach the party. Stage 2 now fixes three errands in order, death restarting the night, and character-specific party results. Finishing Bring Ice and seeing an ice-secured result remains the first proof.
4. **First release platform — answered:** Steam on Windows PC first. Keyboard/mouse and controller are required input methods. Other operating systems are later candidates, not launch commitments.
5. **Tone boundary — answered:** More explicit language; romantic outcomes fade to black. Keep the adult cast and mutual choice from the brief. This supports suggestive humor without requiring explicit sexual scenes.

These five decisions define the Stage 1 concept. Use them to judge Stage 2 rules and the first playable slice. They do not by themselves approve the unbuilt level flow, items, progression, party endings or a Steam release.

## Evidence and source of truth

- Original source: `C:/Users/Kareem/Desktop/Side_Quest_Project_Brief.docx` (read on 29 September 2026). Its four archetypes, item examples, run loop and endings are explicitly described as candidates or proposals, except where it says a direction is confirmed.
- Current implementation and scope: [production-plan.md](production-plan.md), [PROJECT_CHECKPOINT.md](PROJECT_CHECKPOINT.md), [hypeman-v9-action-pass.md](hypeman-v9-action-pass.md), and the GameMaker source in this repository.
- Lifecycle stage definition: `C:/Users/Kareem/Newtype/02-workflows/game-lifecycle/WORKFLOW.md`, Stage 1 Concept. Returning to concept now is an intentional design loop, not a reset of approved art or code.
