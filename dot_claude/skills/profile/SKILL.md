---
name: code-profile
description: >
  Deep performance analysis using profiler subagent.
  Triggers on: "profile", "profile this", "performance", "why is this slow",
  "bottleneck", "optimize this", "benchmark", "hot path", "speed up",
  "too slow", "perf issue", "memory usage", "allocation", "latency".
  Use when performance matters or something feels slow.
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Performance Profiling

Launch profiler subagent for deep performance analysis.

## Workflow

1. **Identify target** - specific code, function, or general slowness
2. **Launch profiler subagent** using Task tool with `subagent_type: profiler`
3. **Report findings** with evidence and recommendations

## Profiler Subagent Prompt

```
Analyze performance for: [target]

Context: [what feels slow, user observations]

1. Measure baseline first (don't guess)
2. Identify hot paths from profiling data
3. Analyze: complexity, allocations, I/O, concurrency, caching
4. Recommend optimizations with expected impact
5. Persist findings to ai/review/ with before/after measurements

Evidence-based only. No assumptions.
```

## Output Format

```
## Performance Analysis

Target: [what was analyzed]
Baseline: [measured performance]

## Findings

1. [Bottleneck] - [measurement] - [impact]
2. ...

## Recommendations

| Fix | Expected Impact | Effort |
|-----|-----------------|--------|
| ... | ...             | ...    |

## Next Steps

1. [Specific action]
2. [Specific action]
```
