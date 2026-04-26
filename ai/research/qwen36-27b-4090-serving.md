# Qwen3.6 27B on RTX 4090

Date: 2026-04-25

Goal: regular Qwen3.6 27B as the primary local coding-agent model on a single RTX 4090, prioritizing quality first, then max/high context, then speed.

## Current Ranking

1. `unsloth/Qwen3.6-27B-GGUF` `Qwen3.6-27B-Q5_K_M.gguf`
   - Best quality-first 262k candidate tested so far.
   - Fits full `262144` context with stock llama.cpp `b8934-b760272f1` using `q4_0/q4_0` KV, `-b 2048 -ub 512`.
   - `yo`, `max_tokens=64`: prompt `144.7 tok/s`, decode `41.97 tok/s`, wall `1.61s`.

2. `unsloth/Qwen3.6-27B-GGUF` `Qwen3.6-27B-UD-Q4_K_XL.gguf`
   - Safer speed/memory option at full 262k.
   - Stock llama.cpp with `q4_0/q4_0` KV: decode around `45 tok/s` on the `yo` request.

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
  - GPU memory while loaded: about `22110 MiB` used, `1971 MiB` free.
  - `yo`, `max_tokens=64`: prompt `145.92 tok/s`, decode `45.29 tok/s`, wall `1.51s`.
  - `llm-serve <command> --unc` selects it with alias `qwen3.6:27b-uncensored`, default port `8081`, and systemd unit `llm-serve-uncensored`.

## vLLM Findings

`Lorbus/Qwen3.6-27B-int4-AutoRound` is promising on paper because it preserves MTP, but mainline vLLM `0.19.1` cannot serve 262k on the 4090:

- MTP + fp8 KV: available KV memory `1.34 GiB`; required `8.83 GiB`.
- No MTP + fp8 KV: available `3.03 GiB`; required `8.18 GiB`.
- `--language-model-only`: available `3.78 GiB`, estimated max length `119168`.

The TurboQuant vLLM fork may change this with `tq-t4nc`, but it is not the quality-first default until it is tested locally.

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
