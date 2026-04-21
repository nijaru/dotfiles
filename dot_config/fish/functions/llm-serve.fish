function llm-serve --description "Serve an HF model via mlx-lm (macOS) or vllm/sglang (Linux)"
    set -l os (uname)

    # Platform-specific defaults
    set -l model ""
    set -l backend ""
    set -l ctx 0
    switch $os
        case Darwin
            set model mlx-community/Qwen3.6-35B-A3B-6bit
            set backend mlx
            set ctx 262144
        case Linux
            set model QuantTrio/Qwen3.5-27B-AWQ
            set backend vllm
            set ctx 163840
        case '*'
            set_color red
            echo "llm-serve: unsupported OS $os"
            set_color normal
            return 1
    end

    set -l port 8081
    set -l host 127.0.0.1

    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case --port -p
                set i (math $i + 1)
                set port $argv[$i]
            case --host -H
                set i (math $i + 1)
                set host $argv[$i]
            case --backend -b
                set i (math $i + 1)
                set backend $argv[$i]
            case --ctx -c
                set i (math $i + 1)
                set ctx $argv[$i]
            case --help -h
                echo "Usage: llm-serve [MODEL] [options]"
                echo ""
                echo "  MODEL             HF repo id"
                echo "  --backend, -b     macOS: mlx (default)"
                echo "                    Linux: vllm (default) | sglang"
                echo "  --port, -p        listen port (default: 8081)"
                echo "  --host, -H        bind address (default: 127.0.0.1)"
                echo "  --ctx, -c         max context length"
                echo ""
                echo "Defaults:"
                echo "  macOS  $model"
                echo "         backend=mlx ctx=$ctx"
                echo "  Linux  QuantTrio/Qwen3.5-27B-AWQ"
                echo "         backend=vllm ctx=163840"
                return 0
            case '-*'
                set_color red
                echo "llm-serve: unknown flag $argv[$i]"
                set_color normal
                return 1
            case '*'
                set model $argv[$i]
        end
        set i (math $i + 1)
    end

    set_color --bold cyan
    echo "Serving $model"
    set_color normal brblack
    echo "  backend    $backend"
    echo "  endpoint   http://$host:$port/v1"
    echo "  ctx        $ctx"
    echo "  cache      ~/.cache/huggingface/hub/"
    set_color normal

    switch $backend
        case mlx
            if test $os != Darwin
                set_color red
                echo "mlx backend requires macOS"
                set_color normal
                return 1
            end
            if not command -q uvx
                set_color red
                echo "uvx not found — brew install uv"
                set_color normal
                return 1
            end
            uvx --from mlx-lm mlx_lm.server --model $model --host $host --port $port

        case vllm
            if not command -q vllm
                set_color red
                echo "vllm not found — uv tool install vllm"
                set_color normal
                return 1
            end
            vllm serve $model \
                --host $host --port $port \
                --max-model-len $ctx \
                --gpu-memory-utilization 0.92 \
                --disable-log-requests

        case sglang
            if not command -q python
                set_color red
                echo "python not found"
                set_color normal
                return 1
            end
            python -m sglang.launch_server \
                --model-path $model \
                --host $host --port $port \
                --context-length $ctx \
                --mem-fraction-static 0.92

        case '*'
            set_color red
            echo "llm-serve: unknown backend $backend"
            set_color normal
            return 1
    end
end
