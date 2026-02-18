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

## Why AI Writing Sounds AI

> "LLMs use statistical algorithms to guess what comes next. The result tends toward the most statistically likely result applicable to the widest variety of cases."

AI sands down specific, unusual, nuanced facts (statistically rare) and replaces them with generic, positive descriptions (statistically common). The fix isn't removing AI patterns—it's adding what AI can't: opinions, varied rhythm, acknowledged complexity, specific details.

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

### Content Patterns

| Pattern                  | Example                                                    | Fix                              |
| ------------------------ | ---------------------------------------------------------- | -------------------------------- |
| Significance inflation   | "pivotal moment," "broader trends," "profound impact"      | Cut or be specific               |
| Vague attributions       | "experts argue," "industry reports suggest"                | Name source or cut               |
| Superficial -ing clauses | "emphasizing the significance," "reflecting the relevance" | Delete entirely                  |
| Formulaic sections       | "Challenges and Future Prospects"                          | Write what you actually know     |
| Promotional language     | "breathtaking," "vibrant," "nestled," "state-of-the-art"   | Cut or replace with fact         |
| Name-dropping notability | Excessive claims about coverage/awards                     | Only include if directly sourced |

### Language Patterns

| Pattern           | Example                                     | Fix                                    |
| ----------------- | ------------------------------------------- | -------------------------------------- |
| Copula avoidance  | "serves as a" → "is", "features" → "has"    | Use "is"/"are"/"has"                   |
| Negative parallel | "not just X but Y," "not only X but also Y" | Pick one: X or Y                       |
| Rule of three     | "innovative, dynamic, and transformative"   | One good adjective beats three generic |
| Synonym cycling   | protagonist → key player → eponymous figure | Repeat the noun                        |
| False ranges      | "from X to Y" when range is meaningless     | Be specific or cut                     |
| Hedging stacks    | "may potentially be able to possibly"       | Commit or cut                          |

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

**Transitions:** Additionally, Furthermore, Moreover
**Adjectives:** nuanced, comprehensive, crucial, pivotal, vital, paramount, seamless, robust, cutting-edge, multifaceted, intricate, ever-evolving
**Verbs:** delve, showcase, leverage, harness, resonate, align, elevate, unlock, unleash, embark, foster, enhance, underscore, bolster, spearhead
**Nouns:** tapestry, landscape, realm, era, testament, cornerstone, myriad

### AI Sentence Patterns

- "It's not about X, it's about Y"
- "No X. No Y. Just Z."
- "And the X? Y."
- "That's exactly what X solves"
- "That's the kind of X I want to build"
- "Taught me what matters: X, Y, Z" (colon + list)
- "I'm eager to bring X to Y"
- "I want to build that infrastructure"
- Three dramatic adjectives in a row
- Every sentence starts with "However" or "That said"
- Choppy "I did X. I did Y. I did Z." cadence without flow

### Style Patterns (Formatting Tells)

| Pattern             | Example                                   | Fix                                |
| ------------------- | ----------------------------------------- | ---------------------------------- |
| Em dash overuse     | Multiple em dashes per paragraph          | Use commas, parentheses, or colons |
| Boldface abuse      | **Key point:** followed by explanation    | Remove bold or use sparingly       |
| Inline header lists | Bullet points with **bolded titles**      | Use prose or simple bullets        |
| Title Case Headings | "The Future Of Artificial Intelligence"   | Sentence case: "The future of AI"  |
| Decorative emoji    | Any emoji in professional writing         | Remove                             |
| Curly quotes        | "smart quotes" in code/technical contexts | Use straight quotes                |

### Communication Patterns (Left-in Prompts)

| Pattern               | Example                                  | Fix           |
| --------------------- | ---------------------------------------- | ------------- |
| Chatbot pleasantries  | "Great question!" "Happy to help!"       | Delete        |
| Cutoff disclaimers    | "As of my knowledge cutoff..."           | Delete        |
| Sycophantic tone      | "Absolutely!" "That's a fantastic idea!" | State facts   |
| Meta-commentary       | "I'll break this down into sections"     | Just write it |
| Eager-to-please close | "Let me know if you need anything else!" | End when done |

### Structural Red Flags

- Every sentence same length
- No periods - all complex sentences
- Passive voice throughout
- Abstract nouns dominating (success, efficiency, quality)
- No named people, places, or numbers
- Length without substance
- Tech list dumps without story ("vLLM for X, Ollama for Y, ONNX for Z")
- Cramming unrelated achievements with "and" ("I built X and also did Y")
- Separate accomplishments connected as if one task

---

## Format-Specific

**Tweets:** Cut ruthlessly. No "Thread:" or "hot take:"

**Blog posts:** Lead with the point. No "In this post, I will..." No "In conclusion"

**Cover letters:**

- Lead with experience, not praise
- Metrics over claims (45 min → 5 min)
- One project with detail beats five projects listed
- Be vague on technical details, save for interview
- End with what you want, not template closer
- "I'd rather be building it" > "I'm eager to bring X to Y"

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

## Sources

Patterns drawn from:

- [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) (WikiProject AI Cleanup)
- [blader/humanizer](https://github.com/blader/humanizer)
