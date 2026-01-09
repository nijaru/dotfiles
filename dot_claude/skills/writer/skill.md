---
name: writer
description: Review text for AI-sounding language, awkward phrasing, and suggest improvements.
allowed-tools: Read, Edit, Bash, AskUserQuestion
---

# Writer

Review any text for weak writing and AI patterns. Works for cover letters, blog posts, tweets, documentation, or any prose.

## Usage

```
/writer [text or file path]
/writer "Check this paragraph"
/writer path/to/draft.md
```

## Review Process

Run 4 passes, flag issues with specific fixes.

### Pass 1: Structure

- **Buried lead?** → Put the point first, evidence second
- **Treadmill?** → Motion without progress; each paragraph must advance
- **Too long?** → Could this be half as long?
- **No thesis?** → Know your destination

### Pass 2: Sentences

- **Same length?** → Vary: long builds, short punches
- **Weak verb + adverb?** → "walked slowly" → "shuffled"
- **Passive voice?** → "was completed by" → "completed"
- **Filter words?** → Cut "I think," "I feel," "I believe"
- **Weasel qualifiers?** → Cut "sort of," "a bit," "rather," "quite"

### Pass 3: Words

- **Abstract?** → Ground in specifics (see Concrete section)
- **Latinate bloat?** → utilize→use, facilitate→help, implement→do
- **AI tells?** → See Red Flags below
- **Redundant?** → "tall skyscraper," "yellow daffodils" → cut modifier
- **Nominalizations?** → "made a decision" → "decided"

### Pass 4: Voice

- **Template or person?** → Does this sound like someone wrote it?
- **All hedge, no stance?** → Commit to something
- **Vague gestures?** → Replace with named people, places, numbers
- **No personality?** → Where's the humor, irony, or risk?
- **Explains everything?** → Trust the reader

---

## Core Principles

### Concrete vs Abstract

> "You don't write about the horrors of war. You write about a kid's burnt socks lying in the road." - Richard Price

| Abstract (weak)              | Concrete (strong)                                            |
| ---------------------------- | ------------------------------------------------------------ |
| "He was weird"               | "He wore his shirt inside-out and called everyone 'captain'" |
| "The city was beautiful"     | "Pink bougainvillea spilled over terracotta walls"           |
| "She felt sad"               | "She stared at the cold coffee, untouched for an hour"       |
| "It was a big success"       | "Revenue doubled in six months"                              |
| "The meeting was productive" | "We cut three features and shipped two weeks early"          |

**Test:** Can you picture it? If not, make it specific.

### What Gives Writing Voice

**Present in good writing:**

- Specific named details, not vague generalities
- Varied sentence length, not metronomic sameness
- Strong opinions willing to offend, not hedged safety
- Unusual word choices, not "business casual"
- Subtext (what's unsaid), not everything spelled out
- Humor, irony, self-awareness

**Voice killers:**

- Hedging every statement
- Removing personality for "professionalism"
- Using only safe, tested phrases
- Explaining jokes
- Smoothing all rough edges

### Strong Verbs

| Weak   | Strong                               |
| ------ | ------------------------------------ |
| walked | strode, shuffled, ambled, trudged    |
| said   | snapped, muttered, admitted, claimed |
| looked | glared, squinted, scanned, studied   |
| went   | bolted, wandered, crept, charged     |

---

## Red Flags

### AI Phrases (flag immediately)

| Phrase                           | Frequency vs Human |
| -------------------------------- | ------------------ |
| "play a crucial role in shaping" | 182x more common   |
| "notable works include"          | 120x               |
| "in today's fast-paced world"    | 107x               |
| "aims to explore"                | 50x                |
| "at the intersection of X and Y" | GPT-ism            |
| "delve into"                     | AI tell            |
| "navigate the landscape"         | AI tell            |
| "unlock the potential"           | AI tell            |
| "seamless integration"           | AI tell            |
| "robust solution"                | AI tell            |

### AI Words (overused)

delve, tapestry, landscape, nuanced, comprehensive, crucial, pivotal, vital, paramount, seamless, robust, cutting-edge, showcasing, leveraging, harnessing, resonates, aligns, elevates, unlock, unleash, embark, foster, enhance

### AI Sentence Patterns

- "It's not about X, it's about Y"
- "No X. No Y. Just Z."
- "And the X? Y."
- Three dramatic adjectives in a row
- Every sentence starts with "However" or "That said"

### Structural Red Flags

- Every sentence same length
- No periods - all complex sentences
- Passive voice throughout
- Abstract nouns dominating (success, efficiency, quality)
- No named people, places, or numbers
- Length without substance

---

## Format-Specific

**Tweets:** Cut ruthlessly. No "Thread:" or "hot take:"

**Blog posts:** Lead with the point. No "In this post, I will..." No "In conclusion"

**Cover letters:** Lead with experience, not praise. Metrics over claims. Strong closers.

**Docs:** Direct imperatives. No "simply" or "just"

---

## Quick Diagnostic

Ask these questions:

1. Can I picture this in my mind?
2. Would a normal person say this out loud?
3. What's being left unsaid? (Nothing = problem)
4. Where is this going? (Nowhere = treadmill)
5. Does the writer believe this or is it hedged?
6. Is there anything weird, personal, or risky?

---

## Output Format

```
## Review: [Format detected]

### Structure
[Issues or "Clean"]

### Sentences
[Issues with line refs]

### Words
[Flagged phrases]

### Voice
[Assessment]

## Summary
- X issues found
- Biggest problems: [list]
- Strength: [what works]

Fix these issues?
```

---

## External Review (Optional)

Second opinion via other models:

```bash
orcx run -m openrouter/x-ai/grok-4.1-fast --no-save "Review for AI language and weak writing. Be specific: [text]"

orcx run -m openrouter/google/gemini-3-flash-preview --no-save "Review for AI language and weak writing. Be specific: [text]"
```
