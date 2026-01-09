---
name: writer
description: Review text for AI-sounding language, awkward phrasing, and suggest improvements.
allowed-tools: Read, Edit, Bash, AskUserQuestion
---

# Writer

Review any text for AI-generated patterns, awkward grammar, and suggest improvements. Works for cover letters, blog posts, tweets, documentation, or any writing.

## Usage

```
/writer [text or file path]
/writer "Check this paragraph for AI language"
/writer path/to/draft.md
```

## Workflow

1. **Identify format** - tweet, blog, cover letter, docs, etc.
2. **Scan for anti-patterns** - check against lists below
3. **Flag issues** - specific phrases with why they're problematic
4. **Suggest fixes** - concrete before/after replacements
5. **Optional: External review** - offer to run through Grok/Gemini via orcx

## Anti-Patterns

### Phrases to Flag

| Phrase                           | Why Bad                       |
| -------------------------------- | ----------------------------- |
| "at the intersection of X and Y" | Classic GPT-ism               |
| "the right abstraction"          | Sycophantic, consultant-speak |
| "resonates"                      | Overused AI word              |
| "delve into"                     | AI tell                       |
| "leverage" (as verb)             | Corporate AI speak            |
| "it's worth noting that"         | Filler                        |
| "in terms of"                    | Weak connector                |
| "I'd like to" / "I'd love to"    | Passive, hedging              |
| "That's where I want to be"      | Filler closer                 |
| "this isn't theoretical"         | Trying too hard               |
| "is what I do"                   | AI phrase                     |
| "the problem clicked"            | AI phrase                     |
| "comprehensive"                  | Overused AI word              |
| "robust"                         | Overused AI word              |
| "seamlessly"                     | Overused AI word              |
| "cutting-edge"                   | Buzzword                      |
| "game-changer"                   | Buzzword                      |
| "deep dive"                      | Overused                      |
| "unpack"                         | Overused                      |
| "landscape"                      | AI word for "field"           |
| "ecosystem" (unless literal)     | Overused                      |
| "synergy"                        | Corporate cringe              |
| "holistic"                       | AI word                       |
| "utilize"                        | Just say "use"                |

### Structural Issues

| Pattern              | Problem                                 | Fix                           |
| -------------------- | --------------------------------------- | ----------------------------- |
| Em dashes everywhere | AI tell                                 | Use periods or commas         |
| Run-on sentences     | Cramming too much                       | Split into separate sentences |
| Abstract noun pairs  | "flexibility and robustness"            | Use concrete examples         |
| Colon + list         | Template-like                           | Integrate naturally           |
| Starting with "So,"  | Filler                                  | Cut                           |
| Starting with "But"  | Weak                                    | Restructure                   |
| Ending with "!"      | Try-hard (usually)                      | Use sparingly                 |
| Passive voice excess | Weak, indirect                          | Active voice                  |
| Weasel words         | "somewhat", "fairly", "quite"           | Be direct                     |
| Hedge phrases        | "I think", "I believe", "in my opinion" | State directly                |

### Format-Specific

**Tweets:**

- Cut filler ruthlessly
- No "Thread:" or "1/" unless actually threading
- Avoid "hot take:" or "unpopular opinion:"

**Blog posts:**

- Lead with the point, not the setup
- Avoid "In this post, I will..."
- Don't end with "In conclusion"

**Cover letters:**

- Lead with personal experience, not product praise
- Concrete metrics over vague claims
- Strong closers ("I'm eager to..." not "I'd like to...")

**Documentation:**

- Direct imperatives ("Run X" not "You should run X")
- No "simply" or "just" (implies it's easy when it might not be)

## What Works

- Short, punchy sentences
- Concrete specifics over abstractions
- Active voice
- Natural speech patterns
- Numbers and metrics
- Named things (projects, tools, people)
- Let statements stand alone without filler

## Output Format

```
## Issues Found

1. **[Phrase]** (line X)
   Problem: [Why]
   Suggestion: [Fix]

2. ...

## Summary

- X issues flagged
- Biggest problems: [list]
- Overall tone: [assessment]

Fix these issues?
```

## External Model Review

To get a second opinion from other models:

```bash
orcx run -m openrouter/x-ai/grok-4.1-fast --no-save "Review this text for AI-sounding language, awkward grammar, and anything that sounds off. Be specific: [text]"

orcx run -m openrouter/google/gemini-3-flash-preview --no-save "Review this text for AI-sounding language, awkward grammar, and anything that sounds off. Be specific: [text]"
```

Offer this as an optional step after initial review.
