---
date: 2026-04-26
summary: Measured Qwen3.6 27B serving tradeoffs on Fedora RTX 4090, with llama.cpp default and vLLM experiments.
status: active
---

# Qwen3.6 27B on RTX 4090

Goal: regular Qwen3.6 27B as the primary local coding-agent model on a single RTX 4090, prioritizing quality first, then max/high context, then speed.

## Current Ranking

1. `unsloth/Qwen3.6-27B-GGUF` `Qwen3.6-27B-UD-Q4_K_XL.gguf`
   - Stable default for Pi/local coding-agent use at full `262144` context.
   - Stock llama.cpp with `q4_0/q4_0` KV: decode around `45 tok/s` on the `yo` request.
   - Restored as the default after Q5 crashed under a long Pi prompt.

2. `unsloth/Qwen3.6-27B-GGUF` `Qwen3.6-27B-Q5_K_M.gguf`
   - Higher-quality candidate but not the stable default for agent use.
   - Fits full `262144` context while idle with stock llama.cpp `b8934-b760272f1` using `q4_0/q4_0` KV, `-b 2048 -ub 512`.
   - `yo`, `max_tokens=64`: prompt `144.7 tok/s`, decode `41.97 tok/s`, wall `1.61s`.
   - Crashed on a large Pi request with CUDA OOM during long prefill/checkpoint handling.

3. `YTan2000/Qwen3.6-27B-TQ3_4S`
   - Built and tested with `turbo-tan/llama.cpp-tq3` fork `c87aeb58b`.
   - Fits full `262144` context with smaller 13 GB weights and `q4_0/tq3_0` KV.
   - `yo`, `max_tokens=64`: prompt `147.27 tok/s`, decode `50.20 tok/s`, wall `1.36s`.
   - Keep as an experiment or fallback; it is a 3-bit/TurboQuant path, so do not make it primary without quality evals.

## Additional Candidates

- `DavidAU/Qwen3.6-27B-NEO-CODE-Di-IMatrix-MAX-GGUF` `Q5_K_M`
  - Fits full `262144` context with the same Q5 serving flags.
  - `yo`, `max_tokens=64`: prompt `130.94 tok/s`, decode `41.62 tok/s`, wall `1.63s`.
  - No speed win over Unsloth Q5. Only replace the primary if a coding eval shows better quality.

- `HauhauCS/Qwen3.6-27B-Uncensored-HauhauCS-Aggressive` `Q4_K_P`
  - Secondary uncensored model. Fits full `262144` context with stock llama.cpp and the same KV/cache flags.
  - HF dry-run artifact size: `17.5G`.
  - Live Fedora check on 2026-04-26 while loaded at `-c 262144`: `22244 MiB` used, `1837 MiB` free on the 4090.
  - This proves idle/full-context reservation loads, not that it survives a filled 262k prompt. Long prompt stability is still untested.
  - `yo`, `max_tokens=64`: prompt `145.92 tok/s`, decode `45.29 tok/s`, wall `1.51s`.
  - `llm-serve <command> --unc` selects it with alias `qwen3.6:27b-uncensored`, default port `8080`, and systemd unit `llm-serve-uncensored`.

## Watch Items

- `antirez/deepseek-v4-gguf` + `antirez/llama.cpp-deepseek-v4-flash`
  - User-observed 2026-04-26 via X: antirez is running a DeepSeek v4 Flash GGUF path, with external chatter about a DeepSeek-v4-flash quant.
  - Quick source check: the fork describes experimental DeepSeek v4 Flash support in llama.cpp, targeting 128 GB MacBooks with 2-bit quantization of routed experts; it says the path was not extensively tested and currently emphasizes CPU/Metal rather than CUDA.
  - Hugging Face currently lists `antirez/deepseek-v4-gguf` as GGUF/conversational, MIT, `284B` params, `deepseek4` architecture, empty model-card content, and no detected quantization variants.
  - Do not switch Fedora defaults for this now. Current `qwen3.6:27b` on Fedora remains the practical baseline because it is already wired into agents, verified on the 4090, and fits the desired long-context serving shape.
  - Revisit only after upstream llama.cpp or a CUDA-capable fork lands clean support, the GGUF/quant details stabilize, and a coding-agent eval shows a quality gain large enough to justify lower maturity and likely lower speed.

## vLLM Findings

`Lorbus/Qwen3.6-27B-int4-AutoRound` is promising on paper because it preserves MTP, but mainline vLLM `0.19.1` cannot serve 262k on the 4090:

- MTP + fp8 KV: available KV memory `1.34 GiB`; required `8.83 GiB`.
- No MTP + fp8 KV: available `3.03 GiB`; required `8.18 GiB`.
- `--language-model-only`: available `3.78 GiB`, estimated max length `119168`.

External 3090 vLLM/TurboQuant reports from 2026-04-25 are useful but not a reason to switch defaults yet:

- The reported fast path uses vLLM nightly, `Lorbus/Qwen3.6-27B-int4-AutoRound`, TurboQuant KV, MTP speculative decoding, Genesis hybrid/TurboQuant patches, and a CUDA-graph workaround.
- Headline result was about `85 tok/s` at `125k` context on a single 24 GB RTX 3090 with vision enabled, but the same write-up's 2026-04-25 update says the original CUDA-graph bypass was mathematically wrong for spec-decode continuation prefill.
- Genesis `v7.14` P65 routes spec-decode continuation to eager execution instead; reported single-card 24 GB Ampere numbers drop to about `55 tok/s` narrative / `70 tok/s` code at `32k`, while dual-card TP=2 is the cleaner long-context path.
- Do not bypass vLLM's max-model-len/KV pre-checks. Hybrid DeltaNet/Mamba state, prefix-cache storage, spec-dec scratch blocks, and fragmentation consume capacity beyond the printed KV pool.
- If revisiting vLLM, test it as a separate service on another port with reproducible SHA verification, tool-call correctness tests, and long-context agent prompts before replacing the current llama.cpp default.
- The article's llama.cpp suggestion was tested with `Qwen/Qwen3-0.6B-GGUF` `Qwen3-0.6B-Q8_0.gguf` as draft, current `UD-Q4_K_XL` as target, target context `262144`, draft context `4096`, and draft KV `q4_0/q4_0`. It fit in VRAM but was slower: baseline held about `45.3 tok/s`, while draft decoding was about `38-40 tok/s` on short and code prompts. Do not add this draft path to `llm-serve`.
- Logs showed low effective draft utility despite per-call acceptance reporting: cumulative draft stats after six requests had `1465` generated draft tokens and only `141` accepted tokens, plus about `2.8s` spent in draft generation. A draft model needs much higher accepted-token yield or lower overhead to help on this setup.

## Recommended Q5 Command

```bash
llama-server \
  -m /home/nick/.cache/huggingface/hub/models--unsloth--Qwen3.6-27B-GGUF/snapshots/82d411acf4a06cfb8d9b073a5211bf410bfc29bf/Qwen3.6-27B-Q5_K_M.gguf \
  --alias qwen3.6:27b \
  --host 0.0.0.0 --port 8080 \
  -ngl 99 -c 262144 -np 1 -fa on \
  --cache-type-k q4_0 --cache-type-v q4_0 \
  -b 2048 -ub 512 \
  --split-mode none
```

For lower latency over maximum fidelity, switch the model to `Qwen3.6-27B-UD-Q4_K_XL.gguf` or benchmark the TQ3 fork after quality evals.
