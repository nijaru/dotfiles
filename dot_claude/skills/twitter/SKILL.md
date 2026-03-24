---
name: twitter
description: Use when fetching X/Twitter post content by URL, or searching for recent X posts.
allowed-tools: Bash
---

# X / Twitter

Fetch post content using `xpost` (yt-dlp wrapper) or search via Exa.

## Fetch a post by URL

```bash
xpost https://x.com/user/status/123456789
```

Returns JSON: `text`, `author`, `handle`, `date`, `likes`, `reposts`, `url`.

## Search for recent posts

Use Exa web search scoped to x.com:

```bash
# Via MCP
mcp__exa__web_search_exa query="site:x.com <topic>" num_results=10
```

## 🚫 Anti-Rationalization

| Excuse                          | Reality                                          |
| :------------------------------ | :----------------------------------------------- |
| "I'll use orcx/Grok instead"    | `xpost` is free and works for all agents.        |
| "I can guess the tweet content" | Fetch it — content changes and deletions happen. |
