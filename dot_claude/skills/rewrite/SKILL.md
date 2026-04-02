---
name: rewrite
description: Use when the user wants to explore what a ground-up redesign of a project, feature, or component would look like — to investigate feasibility and value before committing; when they suspect incremental fixes are the wrong approach
allowed-tools: Bash, Read, Grep, Glob, Write, WebSearch, Agent
---

# Rewrite (Ground-Up Investigation)

## Overview

This skill investigates what a rewrite _would look like_ and whether it's worth doing — it does **not** decide to rewrite or begin implementation. The output is a research report and design sketch the user reviews to make that call.

**Core principle:** Before committing to a rewrite, understand what the ideal version looks like and what it would cost to get there. A large architectural change can beat many micro-optimizations — but only if the design is actually better.

## Core Mandates

- **No anchoring:** Explore the design space unconstrained by what exists. Start from the problem.
- **SOTA-first:** Research how the best implementations solve this today before sketching a design.
- **Honest audit:** Distinguish what is _fundamentally broken_ (wrong abstraction, wrong model) from _incidentally broken_ (fixable without redesign). Check stale constraints first — the whole rewrite case may collapse if the original forcing function is gone.
- **Investigate, don't decide:** Produce a clear picture of what a rewrite would look like and what it would take. The user decides whether to proceed.

## Execution

Run these steps in order. Do not skip ahead to design before completing the audit and constraint check.

1. Audit current state
2. Check whether original constraints still hold (may short-circuit the investigation)
3. Research SOTA
4. Sketch the ideal design
5. Assess tradeoffs
6. Write the report

### 1. Current State Audit

Read the existing code with fresh eyes. Classify:

| Category                 | Examples                                                                              |
| :----------------------- | :------------------------------------------------------------------------------------ |
| **Fundamentally broken** | Wrong data model, wrong abstraction, design decisions that compound into every caller |
| **Incidentally broken**  | Bugs, inconsistent naming, missing edge cases — fixable without redesign              |
| **Worth keeping**        | Correct algorithms, good test coverage, stable interfaces                             |

### 2. Constraint Check (do this before SOTA research)

Identify the constraints that forced the current design, then verify each still holds:

- Are the original performance/scale requirements still the same?
- Are the original compatibility or integration requirements still in place?
- Has the language, runtime, or ecosystem changed enough to unlock better approaches?

If the constraints have changed significantly, the existing design may be more wrong than it looks — or less wrong. Establish this before investing in research.

### 3. SOTA Research

Research the best current approaches before sketching a design. Skip this step if the problem is narrowly domain-specific with no external reference implementations.

- How do the best implementations solve this today?
- What patterns have emerged since this was written?
- What primitives, libraries, or language features now make this easier?
- Use `context7` for library docs. Use the `Agent` tool with `subagent_type=researcher` for synthesis across multiple sources.

### 4. Ideal Design Sketch

Design the best version unconstrained by the current implementation:

| Axis                | Key Questions                                                                  |
| :------------------ | :----------------------------------------------------------------------------- |
| **Performance**     | Algorithmic complexity, allocation patterns, concurrency model, cache behavior |
| **API design**      | Minimal surface, composability, predictability, error semantics                |
| **DX**              | Discoverability, defaults, error messages, type ergonomics                     |
| **UX**              | End-user behavior, responsiveness, latency, feedback                           |
| **Correctness**     | Edge cases the current design gets wrong _by construction_                     |
| **Maintainability** | Testability, extensibility, conceptual simplicity                              |

Produce: a data model sketch, an API surface sketch, and the key architectural decisions that differ from today.

### 5. Tradeoff Assessment

| Signal                                             | Implication               |
| :------------------------------------------------- | :------------------------ |
| Core data model is wrong for the problem           | Strong case for rewrite   |
| API must break to fix correctness or DX            | Strong case for rewrite   |
| Performance requires a different algorithm         | Strong case for rewrite   |
| Abstractions compound complexity into every caller | Strong case for rewrite   |
| Design is sound; code is just messy                | Refactor is likely enough |
| One module is broken; rest is fine                 | Targeted fix may suffice  |
| Breaking changes not acceptable                    | Refactor + migration path |

Be explicit about what incremental improvement _cannot_ fix vs. what it can. That gap is the rewrite argument.

## Output

Present the report inline, then optionally save to `ai/design/<feature>.md` (or `ai/DESIGN.md` if no subdirectory exists):

1. **Current state verdict** — what's fundamentally vs. incidentally broken
2. **Constraint check** — which original constraints still hold; which have changed
3. **Ideal design sketch** — data model, API surface, key decisions, SOTA influences
4. **Gap analysis** — what incremental improvement can and cannot close
5. **Rewrite case** — a clear articulation of the argument for rewriting, or why it's not warranted

Do not recommend proceeding with implementation. Present findings and let the user decide. If they choose to move forward, use the `sprint` skill to generate a plan from the design sketch.

## Anti-Rationalization

| Excuse                           | Reality                                                                                                                      |
| :------------------------------- | :--------------------------------------------------------------------------------------------------------------------------- |
| "Skip straight to the design"    | Audit and constraint check first — they may invalidate your assumptions about what needs fixing.                             |
| "SOTA research is overkill here" | If it's domain-specific with no reference implementations, skip it. Otherwise, do it — unknown unknowns are the whole point. |
| "I should recommend a decision"  | Not your call. Present the clearest possible picture; the user decides.                                                      |
