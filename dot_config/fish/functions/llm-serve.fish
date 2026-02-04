# Local LLM inference server - OpenAI-compatible API on port 8080
# Fedora: vLLM + GLM-4.7-Flash AWQ 4-bit (~17GB) on 4090
# Auto-installs vLLM on first run. Ctrl+C to stop.
#
# Endpoint: http://fedora:8080/v1
# Usage: llm-serve

function llm-serve
    function _llm_cleanup --on-signal INT --inherit-variable _llm_pid
        kill -INT $_llm_pid 2>/dev/null
        wait $_llm_pid 2>/dev/null
        functions -e _llm_cleanup
        echo ""
    end

    python -c "import vllm" 2>/dev/null
    or uv pip install --system vllm --pre --index-url https://pypi.org/simple --extra-index-url https://wheels.vllm.ai/nightly
    vllm serve cyankiwi/GLM-4.7-Flash-AWQ-4bit --host 0.0.0.0 --port 8080 --gpu-memory-utilization 0.90 --quantization awq --max-model-len 4096 &
    set _llm_pid $last_pid

    wait $_llm_pid 2>/dev/null
    functions -e _llm_cleanup
end
