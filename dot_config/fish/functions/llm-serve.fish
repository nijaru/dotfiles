# Local LLM inference server - OpenAI-compatible API on port 8080
# macOS: MLX + Qwen3-Coder-Next 4-bit (80B/3B active MoE) on M3 Max
# Linux: vLLM + GLM-4.7-Flash AWQ 4-bit (~17GB) on 4090
# Auto-installs dependencies on first run. Ctrl+C to stop.
#
# Endpoints:
#   Mac:    http://localhost:8080/v1
#   Fedora: http://fedora:8080/v1

function llm-serve
    function _llm_cleanup --on-signal INT --inherit-variable _llm_pid
        kill -INT $_llm_pid 2>/dev/null
        wait $_llm_pid 2>/dev/null
        functions -e _llm_cleanup
        echo ""
    end

    if test (uname) = "Darwin"
        python -c "import mlx_lm" 2>/dev/null
        or uv pip install --python (which python) mlx-lm
        python -m mlx_lm server --model mlx-community/Qwen3-Coder-Next-4bit --port 8080 &
        set _llm_pid $last_pid
    else
        python -c "import vllm" 2>/dev/null
        or uv pip install --system vllm --pre --index-url https://pypi.org/simple --extra-index-url https://wheels.vllm.ai/nightly
        vllm serve cyankiwi/GLM-4.7-Flash-AWQ-4bit --host 0.0.0.0 --port 8080 --gpu-memory-utilization 0.90 --quantization awq --max-model-len 4096 &
        set _llm_pid $last_pid
    end

    wait $_llm_pid 2>/dev/null
    functions -e _llm_cleanup
end
