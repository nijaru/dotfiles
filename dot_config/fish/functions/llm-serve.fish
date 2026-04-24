function llm-serve --description "Serve an HF model via mlx-lm, llama.cpp, vLLM, or SGLang"
    set -l os (uname)

    set -l model ""
    set -l served_model_name ""
    set -l backend ""
    set -l ctx 0
    set -l port 8081
    set -l host 127.0.0.1
    set -l download_only 0
    set -l verify_only 0
    set -l gguf_file ""
    set -l command serve

    switch $os
        case Darwin
            set model mlx-community/Qwen3.6-35B-A3B-6bit
            set served_model_name qwen3.6:latest
            set backend mlx
            set ctx 262144
        case Linux
            set model unsloth/Qwen3.6-27B-GGUF
            set gguf_file Qwen3.6-27B-UD-Q4_K_XL.gguf
            set served_model_name qwen3.6:27b
            set backend llama
            set ctx 131072
            set port 8080
            set host 0.0.0.0
        case '*'
            set_color red
            echo "llm-serve: unsupported OS $os"
            set_color normal
            return 1
    end

    if test (count $argv) -gt 0
        switch $argv[1]
            case serve start stop restart status
                set command $argv[1]
                set -e argv[1]
        end
    end

    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case qwen36-llama
                set model unsloth/Qwen3.6-27B-GGUF
                set gguf_file Qwen3.6-27B-UD-Q4_K_XL.gguf
                set served_model_name qwen3.6:27b
                set backend llama
                set ctx 131072
            case qwen36-llama-q4km
                set model unsloth/Qwen3.6-27B-GGUF
                set gguf_file Qwen3.6-27B-Q4_K_M.gguf
                set served_model_name qwen3.6:27b
                set backend llama
                set ctx 131072
            case qwen36-4090
                set model LibertAIDAI/Qwen3.6-27B-W4A16-G128
                set served_model_name qwen3.6:27b-4090
                set backend vllm
                set ctx 40960
            case qwen36-fp8
                set model Qwen/Qwen3.6-27B-FP8
                set served_model_name qwen3.6:27b-fp8
                set backend vllm
                set ctx 32768
            case --served-name
                set i (math $i + 1)
                set served_model_name $argv[$i]
            case --port -p
                set i (math $i + 1)
                set port $argv[$i]
            case --host -H
                set i (math $i + 1)
                set host $argv[$i]
            case --backend -b
                set i (math $i + 1)
                set backend $argv[$i]
            case --gguf-file
                set i (math $i + 1)
                set gguf_file $argv[$i]
            case --ctx -c
                set i (math $i + 1)
                set ctx $argv[$i]
            case --download-only
                set download_only 1
            case --verify-only
                set verify_only 1
            case --help -h
                echo "Usage: llm-serve [serve|start|stop|restart|status] [MODEL|PROFILE] [options]"
                echo ""
                echo "Commands:"
                echo "  serve           run in the foreground (default)"
                echo "  start           run as a systemd user service on Linux"
                echo "  stop            stop the systemd user service and matching llama-server"
                echo "  restart         stop, then start"
                echo "  status          show systemd status or matching server processes"
                echo ""
                echo "Profiles:"
                echo "  qwen36-llama      Linux default: Unsloth Qwen3.6 27B UD-Q4_K_XL GGUF"
                echo "  qwen36-llama-q4km Baseline Unsloth Qwen3.6 27B Q4_K_M GGUF"
                echo "  qwen36-4090       vLLM: 4090-targeted Qwen3.6 27B W4A16"
                echo "  qwen36-fp8        Official FP8 Qwen3.6 27B"
                echo ""
                echo "Options:"
                echo "  --backend, -b     macOS: mlx (default)"
                echo "                    Linux: llama (default) | vllm | sglang"
                echo "  --gguf-file       GGUF filename when backend=llama and MODEL is an HF repo"
                echo "  --served-name     OpenAI model id exposed by the server"
                echo "  --port, -p        listen port"
                echo "  --host, -H        bind address"
                echo "  --ctx, -c         max context length"
                echo "  --download-only   verify/install tooling and prefetch model, then exit"
                echo "  --verify-only     verify tooling/auth/model snapshot, then exit"
                echo ""
                echo "Defaults:"
                echo "  macOS  mlx-community/Qwen3.6-35B-A3B-6bit"
                echo "         backend=mlx host=127.0.0.1 port=8081 ctx=262144"
                echo "  Linux  unsloth/Qwen3.6-27B-GGUF"
                echo "         file=Qwen3.6-27B-UD-Q4_K_XL.gguf backend=llama host=0.0.0.0 port=8080 ctx=131072"
                return 0
            case '-*'
                set_color red
                echo "llm-serve: unknown flag $argv[$i]"
                set_color normal
                return 1
            case '*'
                set model $argv[$i]
                if test -z "$served_model_name"
                    set served_model_name (path basename $model)
                end
        end
        set i (math $i + 1)
    end

    if test -z "$served_model_name"
        set served_model_name (path basename $model)
    end

    set -l unit llm-serve
    set -l llama_pattern "llama-server .*Qwen3.6-27B|llama-server .*--alias qwen3.6:27b"

    switch $command
        case status
            if test $os = Linux; and command -q systemctl; and systemctl --user is-active --quiet $unit.service
                systemctl --user status $unit.service --no-pager
                return $status
            end
            if command -q pgrep
                pgrep -af "$llama_pattern"
                return $status
            end
            echo "No supported status checker found"
            return 1

        case stop restart
            if test $os = Linux; and command -q systemctl
                systemctl --user stop $unit.service >/dev/null 2>&1
            end
            if command -q pkill
                pkill -f "$llama_pattern" >/dev/null 2>&1
            end
            if test $command = stop
                return 0
            end
            set command start

        case start
            if test $os != Linux
                set_color red
                echo "llm-serve start uses systemd user services and is intended for Linux"
                set_color normal
                return 1
            end
            if not command -q systemd-run
                set_color red
                echo "systemd-run not found — run llm-serve in the foreground instead"
                set_color normal
                return 1
            end
            if systemctl --user is-active --quiet $unit.service
                echo "$unit.service is already running"
                systemctl --user status $unit.service --no-pager
                return 0
            end
            set -l command_line "llm-serve serve"
            if test (count $argv) -gt 0
                set command_line "$command_line "(string join " " (string escape -- $argv))
            end
            systemd-run --user --unit $unit --collect --same-dir fish -lc $command_line
            systemctl --user status $unit.service --no-pager
            return $status
    end

    set_color --bold cyan
    echo "Preparing $model"
    set_color normal brblack
    echo "  backend      $backend"
    echo "  served_name  $served_model_name"
    echo "  endpoint     http://$host:$port/v1"
    echo "  ctx          $ctx"
    if test -n "$gguf_file"
        echo "  gguf_file    $gguf_file"
    end
    echo "  cache        ~/.cache/huggingface/hub/"
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
            if test $download_only -eq 1 -o $verify_only -eq 1
                echo "mlx backend does not prefetch Hugging Face snapshots separately"
                return 0
            end
            uvx --from mlx-lm mlx_lm.server --model $model --host $host --port $port

        case llama
            if test $os != Linux
                set_color red
                echo "llama backend is intended for Linux"
                set_color normal
                return 1
            end
            if not command -q llama-server
                set_color red
                echo "llama-server not found — build llama.cpp with CUDA and put llama-server on PATH"
                set_color normal
                echo "  git clone https://github.com/ggml-org/llama.cpp ~/github/ggml-org/llama.cpp"
                echo "  cmake -S ~/github/ggml-org/llama.cpp -B ~/github/ggml-org/llama.cpp/build -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release"
                echo "  cmake --build ~/github/ggml-org/llama.cpp/build --config Release -j"
                return 1
            end
            if not command -q hf
                set_color red
                echo "hf not found — install Hugging Face CLI"
                set_color normal
                return 1
            end
            if hf auth whoami --format json >/dev/null 2>&1
                true
            else
                set_color red
                echo "Hugging Face auth missing — run: hf auth login"
                set_color normal
                return 1
            end
            if test -z "$gguf_file"
                set gguf_file (path basename $model)
            end

            echo "Prefetching GGUF..."
            set -l download_output (HF_HUB_DISABLE_PROGRESS_BARS=1 hf download $model --include $gguf_file)
            set -l clean_output (string replace -ra '\x1B\[[0-9;]*m' '' -- $download_output)
            set -l local_model (string trim -- (string replace -r '.*path: ' '' -- $clean_output[-1]))
            if test -d "$local_model"
                set local_model $local_model/$gguf_file
            end
            if not test -f "$local_model"
                set local_model ~/.cache/huggingface/hub/models--(string replace -a "/" "--" -- $model)/snapshots/*/$gguf_file
            end
            if not test -f "$local_model"
                set_color red
                echo "hf download did not return a valid GGUF path"
                set_color normal
                return 1
            end

            set_color green
            echo "Verified GGUF: $local_model"
            set_color normal

            if test $download_only -eq 1 -o $verify_only -eq 1
                return 0
            end

            llama-server \
                -m $local_model \
                --alias $served_model_name \
                --host $host --port $port \
                -ngl 99 \
                -c $ctx \
                -np 1 \
                -fa on \
                --cache-type-k q4_0 \
                --cache-type-v q4_0

        case vllm sglang
            if test $os != Linux
                set_color red
                echo "$backend backend is intended for Linux"
                set_color normal
                return 1
            end
            if not command -q uv
                set_color red
                echo "uv not found"
                set_color normal
                return 1
            end

            set -l tool_python ""
            for candidate in python3.12 python3.13
                if command -q $candidate
                    set tool_python $candidate
                    break
                end
            end
            if test -z "$tool_python"
                set_color red
                echo "Need Python 3.12 or 3.13 for Linux model tooling"
                set_color normal
                return 1
            end

            if not hf --version >/dev/null 2>&1
                echo "Repairing huggingface-hub tool environment..."
                uv tool install --python $tool_python --reinstall huggingface-hub >/dev/null
            end
            if not hf auth whoami --format json >/dev/null 2>&1
                set_color red
                echo "Hugging Face auth missing — run: hf auth login"
                set_color normal
                return 1
            end

            if test $backend = vllm
                if not vllm --version >/dev/null 2>&1
                    echo "Repairing vllm tool environment..."
                    uv tool install --python $tool_python --reinstall vllm==0.19.1 >/dev/null
                end
            else
                if not python -c 'import sglang' >/dev/null 2>&1
                    set_color red
                    echo "sglang not installed in the active Python environment"
                    set_color normal
                    return 1
                end
            end

            echo "Prefetching model snapshot..."
            set -l download_output (HF_HUB_DISABLE_PROGRESS_BARS=1 hf download $model)
            set -l clean_output (string replace -ra '\x1B\[[0-9;]*m' '' -- $download_output)
            set -l local_model (string trim -- (string replace -r '.*path: ' '' -- $clean_output[-1]))
            if not test -d "$local_model"
                set_color red
                echo "hf download did not return a valid local path"
                set_color normal
                return 1
            end

            set_color green
            echo "Verified snapshot: $local_model"
            set_color normal

            if test $download_only -eq 1 -o $verify_only -eq 1
                return 0
            end

            if test $backend = vllm
                vllm serve $local_model \
                    --served-model-name $served_model_name \
                    --host $host --port $port \
                    --max-model-len $ctx \
                    --gpu-memory-utilization 0.95 \
                    --kv-cache-dtype fp8 \
                    --max-num-seqs 8 \
                    --enable-prefix-caching \
                    --language-model-only \
                    --reasoning-parser qwen3 \
                    --enable-auto-tool-choice \
                    --tool-call-parser qwen3_coder \
                    --speculative-config '{"method":"qwen3_next_mtp","num_speculative_tokens":2}'
            else
                python -m sglang.launch_server \
                    --model-path $local_model \
                    --served-model-name $served_model_name \
                    --host $host --port $port \
                    --context-length $ctx \
                    --mem-fraction-static 0.95 \
                    --reasoning-parser qwen3 \
                    --tool-call-parser qwen3_coder
            end

        case '*'
            set_color red
            echo "llm-serve: unknown backend $backend"
            set_color normal
            return 1
    end
end
