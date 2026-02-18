---
name: codex
description: Use when needing a second AI perspective on complex debugging, code analysis, or technical questions - invokes OpenAI Codex CLI for deep analysis
---

# Using Codex from Claude Code

Codex is an AI-powered CLI tool for complex debugging, code analysis, and technical questions. Use it when you need a second perspective or are stuck.

## When to Use

- Debugging subtle bugs (bitstream alignment, off-by-one errors)
- Analyzing complex algorithms against specifications
- Getting detailed code review with specific bug identification
- Understanding obscure file formats or protocols
- When you've tried multiple approaches and are stuck

## The File-Based Pattern

### Step 1: Create Question File

Write to `/tmp/question.txt`:

````
I have a [component] that fails with [specific error].

Here is the full function:
```[lang]
[paste complete code]
````

Key observations:

1. [What works]
2. [What fails]
3. [When it fails]

Can you identify:

1. [Specific question 1]
2. [Specific question 2]

Please write a detailed analysis to /tmp/reply.txt

````

### Step 2: Invoke Codex

```bash
cat /tmp/question.txt | codex exec -o /tmp/reply.txt --full-auto
````

Flags:

- `exec`: Non-interactive execution mode (required for CLI use)
- `-o /tmp/reply.txt`: Write output to file
- `--full-auto`: Run autonomously without prompts

### Step 3: Read the Reply

```bash
cat /tmp/reply.txt
```

Evaluate suggestions critically - Codex may identify real bugs but can occasionally misinterpret specifications.

## Tips

1. **Provide complete code**: Don't truncate functions. Codex needs full context.

2. **Be specific**: "Why does Huffman decoding fail after processing 1477 blocks in AC refinement scan?" beats "Why does this fail?"

3. **Include the spec**: If debugging against a standard (JPEG, PNG, etc.), mention the relevant spec sections.

4. **Verify suggestions**: Codex is helpful but not infallible. Always verify against authoritative sources.

5. **Iterate if needed**: If the first response doesn't solve the problem, create a new question.txt with additional context.

## Quick Pattern

For shorter questions:

```bash
echo "Explain the JPEG progressive AC refinement algorithm" | codex exec --full-auto
```

For debugging, use the file-based pattern for refinement and record-keeping.

## Common Issues

| Issue                     | Fix                                                 |
| ------------------------- | --------------------------------------------------- |
| "stdin is not a terminal" | Use `codex exec` not bare `codex`                   |
| No output                 | Check `-o` flag has valid path                      |
| Timeout                   | `--full-auto` avoids interactive prompts that block |
