# Local LLM inference server - OpenAI-compatible API on port 8080
# macOS: mlx-lm + Qwen3.5-27B Claude Opus 4.6 Distilled 4-bit (MLX, ~14GB)
# Linux: llama-server + Qwen3.5-27B Claude Opus 4.6 Distilled v2 Q4_K_M (GGUF, ~16.5GB)
#   Hybrid DeltaNet arch (48 linear + 16 attention layers); vLLM not yet stable.
#   llama-server install: CMAKE_ARGS="-DGGML_CUDA=on" uv tool install llama-cpp-python
# Checks known locations; downloads to HF cache if not found. Ctrl+C to stop.
#
# Endpoints:
#   Mac:    http://localhost:8080/v1
#   Fedora: http://fedora:8080/v1

function llm-serve
    function _llm_cleanup --on-signal INT --on-signal TERM --inherit-variable _llm_pid
        kill -INT $_llm_pid 2>/dev/null
        wait $_llm_pid 2>/dev/null
        functions -e _llm_cleanup
        echo ""
    end

    if test (uname) = "Darwin"
        set _mlx_id mlx-community/Qwen3.5-27B-Claude-4.6-Opus-Distilled-MLX-4bit
        set _hf_mlx ~/.cache/huggingface/hub/models--mlx-community--Qwen3.5-27B-Claude-4.6-Opus-Distilled-MLX-4bit
        if test -d $_hf_mlx
            # mlx-lm resolves from HF cache via model ID
            set _model $_mlx_id
        else if test -d ~/.lmstudio/models/$_mlx_id
            set _model ~/.lmstudio/models/$_mlx_id
        else
            # not found locally; mlx-lm will download to HF cache
            set _model $_mlx_id
        end
        uvx --python 3.14t --from mlx-lm mlx_lm server \
            --model $_model \
            --host 0.0.0.0 --port 8080 &
        set _llm_pid $last_pid
    else
        set _gguf_repo Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF
        set _hf_cache ~/.cache/huggingface/hub/models--Jackrong--Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF
        set _model (ls $_hf_cache/snapshots/*/*.gguf 2>/dev/null | string match "*Q4_K_M*" | head -1)
        if test -z "$_model"
            hf download $_gguf_repo --include "*Q4_K_M*"
            set _model (ls $_hf_cache/snapshots/*/*.gguf 2>/dev/null | string match "*Q4_K_M*" | head -1)
        end
        llama-server \
            --model $_model \
            --n-gpu-layers 999 \
            --ctx-size 131072 \
            --host 0.0.0.0 \
            --port 8080 &
        set _llm_pid $last_pid
    end

    wait $_llm_pid 2>/dev/null
    functions -e _llm_cleanup
end
