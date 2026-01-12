---
description: Review text for AI-sounding language, awkward phrasing, and suggest improvements.
---

# Writer

Review any text for weak writing and AI patterns.

## Review Process

Run 4 passes, flag issues with specific fixes.

### Pass 1: Structure

- **Buried lead?** -> Put the point first, evidence second
- **Treadmill?** -> Motion without progress; each paragraph must advance
- **Too long?** -> Could this be half as long?
- **No thesis?** -> Know your destination

### Pass 2: Sentences

- **Same length?** -> Vary: long builds, short punches
- **Weak verb + adverb?** -> "walked slowly" -> "shuffled"
- **Passive voice?** -> "was completed by" -> "completed"
- **Filter words?** -> Cut "I think," "I feel," "I believe"
- **Weasel qualifiers?** -> Cut "sort of," "a bit," "rather," "quite"

### Pass 3: Words

- **Abstract?** -> Ground in specifics
- **Latinate bloat?** -> utilize->use, facilitate->help, implement->do
- **AI tells?** -> See Red Flags below
- **Redundant?** -> "tall skyscraper" -> cut modifier
- **Nominalizations?** -> "made a decision" -> "decided"

### Pass 4: Voice

- **Template or person?** -> Does this sound like someone wrote it?
- **All hedge, no stance?** -> Commit to something
- **Vague gestures?** -> Replace with named people, places, numbers
- **No personality?** -> Where's the humor, irony, or risk?

## AI Red Flags

### Phrases (flag immediately)

| Phrase                           | Issue            |
| -------------------------------- | ---------------- |
| "play a crucial role in shaping" | 182x more common |
| "in today's fast-paced world"    | 107x             |
| "at the intersection of X and Y" | GPT-ism          |
| "delve into"                     | AI tell          |
| "navigate the landscape"         | AI tell          |
| "seamless integration"           | AI tell          |
| "robust solution"                | AI tell          |

### Words (overused)

delve, tapestry, landscape, nuanced, comprehensive, crucial, pivotal, vital, paramount, seamless, robust, cutting-edge, showcasing, leveraging, harnessing, resonates, aligns, elevates, unlock, unleash, embark, foster, enhance

### Sentence Patterns

- "It's not about X, it's about Y"
- "No X. No Y. Just Z."
- "And the X? Y."
- Choppy "I did X. I did Y. I did Z." cadence without flow

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
