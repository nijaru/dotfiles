function llm-serve --description "Serve Qwen3.6 27B via llama.cpp on Fedora"
    set -l model unsloth/Qwen3.6-27B-GGUF
    set -l file Qwen3.6-27B-UD-Q4_K_XL.gguf
    set -l alias qwen3.6:27b
    set -l ctx 262144
    set -l batch 2048
    set -l ubatch 512
    set -l host 0.0.0.0
    set -l port 8080
    set -l unit llm-serve
    set -l pattern 'llama-server .*models--unsloth--Qwen3\.6-27B-GGUF|llama-server .*--alias qwen3\.6:27b($| )'
    set -l uncensored 0
    set -l gemma 0
    set -l variant_selected 0

    set -l command help
    if test (count $argv) -gt 0
        switch $argv[1]
            case serve start stop restart status help -h --help
                set command $argv[1]
                set -e argv[1]
            case '--*' '-*'
                set command serve
        end
    end

    set -l download_only 0
    set -l verify_only 0
    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case --file -f
                set i (math $i + 1)
                set file $argv[$i]
            case --served-name
                set i (math $i + 1)
                set alias $argv[$i]
            case --ctx -c
                set i (math $i + 1)
                set ctx $argv[$i]
            case --batch -b
                set i (math $i + 1)
                set batch $argv[$i]
            case --ubatch -ub
                set i (math $i + 1)
                set ubatch $argv[$i]
            case --port -p
                set i (math $i + 1)
                set port $argv[$i]
            case --host -H
                set i (math $i + 1)
                set host $argv[$i]
            case --unc --uncensored
                set uncensored 1
                set variant_selected 1
            case --gemma
                set gemma 1
                set variant_selected 1
            case --download-only
                set download_only 1
            case --verify-only
                set verify_only 1
            case '*'
                echo "llm-serve: unknown argument $argv[$i]" >&2
                return 1
        end
        set i (math $i + 1)
    end

    if test $gemma -eq 1; and test $uncensored -eq 1
        set model TrevorJS/gemma-4-31B-it-uncensored-GGUF
        test "$file" = Qwen3.6-27B-UD-Q4_K_XL.gguf
        and set file gemma-4-31B-it-uncensored-Q4_K_M.gguf
        test "$alias" = qwen3.6:27b
        and set alias gemma4:31b-uncensored
        set unit llm-serve-gemma-uncensored
        set pattern 'llama-server .*models--TrevorJS--gemma-4-31B-it-uncensored-GGUF|llama-server .*--alias gemma4:31b-uncensored($| )'
    else if test $gemma -eq 1
        set model unsloth/gemma-4-31B-it-GGUF
        test "$file" = Qwen3.6-27B-UD-Q4_K_XL.gguf
        and set file gemma-4-31B-it-UD-Q4_K_XL.gguf
        test "$alias" = qwen3.6:27b
        and set alias gemma4:31b
        set unit llm-serve-gemma
        set pattern 'llama-server .*models--unsloth--gemma-4-31B-it-GGUF|llama-server .*--alias gemma4:31b($| )'
    else if test $uncensored -eq 1
        set model HauhauCS/Qwen3.6-27B-Uncensored-HauhauCS-Aggressive
        test "$file" = Qwen3.6-27B-UD-Q4_K_XL.gguf
        and set file Qwen3.6-27B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf
        test "$alias" = qwen3.6:27b
        and set alias qwen3.6:27b-uncensored
        set unit llm-serve-uncensored
        set pattern 'llama-server .*models--HauhauCS--Qwen3\.6-27B-Uncensored-HauhauCS-Aggressive|llama-server .*--alias qwen3\.6:27b-uncensored($| )'
    end

    switch $command
        case help -h --help
            __llm_serve_help
            return 0
        case stop
            if test $variant_selected -eq 0
                __llm_serve_stop_all
                return 0
            end
            __llm_serve_stop $unit $pattern
            return 0
        case status
            __llm_serve_status $unit $pattern
            return $status
        case restart
            __llm_serve_stop $unit $pattern
            set command start
    end

    if test $download_only -eq 0; and test $verify_only -eq 0
        __llm_serve_refuse_if_any_other_running $unit; or return 1
    end

    if not type -q llama-server
        echo "llm-serve: llama-server not found; build llama.cpp with CUDA and put it on PATH" >&2
        return 1
    end
    if not type -q hf
        echo "llm-serve: hf not found; install Hugging Face CLI" >&2
        return 1
    end
    if not hf auth whoami --format json >/dev/null 2>&1
        echo "llm-serve: Hugging Face auth missing; run: hf auth login" >&2
        return 1
    end

    echo "Preparing $model"
    echo "  alias        $alias"
    echo "  endpoint     http://$host:$port/v1"
    echo "  ctx          $ctx"
    echo "  batch        $batch"
    echo "  ubatch       $ubatch"
    echo "  file         $file"
    echo "  cache        ~/.cache/huggingface/hub/"

    set -l local_model (__llm_serve_download $model $file); or return 1
    echo "Verified GGUF: $local_model"
    if test $download_only -eq 1; or test $verify_only -eq 1
        return 0
    end

    set -l llama_cmd llama-server -m $local_model --alias $alias \
        --host $host --port $port -ngl 99 -c $ctx -np 1 -fa on \
        --cache-type-k q4_0 --cache-type-v q4_0 \
        -b $batch -ub $ubatch --split-mode none

    switch $command
        case serve
            exec $llama_cmd
        case start
            if not type -q systemd-run
                echo "llm-serve: systemd-run not found; use 'llm-serve serve' instead" >&2
                return 1
            end
            if not set -q XDG_RUNTIME_DIR
                set -gx XDG_RUNTIME_DIR /run/user/(id -u)
            end
            if not test -S $XDG_RUNTIME_DIR/bus
                echo "llm-serve: systemd user bus not reachable at $XDG_RUNTIME_DIR/bus" >&2
                echo "  fix: sudo loginctl enable-linger "(id -un)"; then re-login" >&2
                return 1
            end
            if systemctl --user is-active --quiet $unit.service
                echo "$unit.service is already running"
                systemctl --user status $unit.service --no-pager
                return 0
            end
            systemd-run --user --unit $unit --collect $llama_cmd; or return 1
            __llm_serve_wait_ready $unit $host $port $alias; or return 1
            systemctl --user status $unit.service --no-pager
    end
end

function __llm_serve_help
    echo "Usage: llm-serve [serve|start|stop|restart|status] [options]

Commands:
  serve           run llama-server in the foreground (default 8080)
  start           run as a systemd user service
  stop            stop the systemd user service and matching llama-server
  restart         stop, then start
  status          show systemd status or matching server processes

Options:
  --unc            use HauhauCS Aggressive uncensored defaults
  --gemma          use Gemma 4 31B dense defaults; combine with --unc for uncensored Gemma
  --file, -f        GGUF filename within the HF repo (default Qwen3.6-27B-UD-Q4_K_XL.gguf)
  --served-name     OpenAI model id exposed by llama-server (default qwen3.6:27b)
  --port, -p        listen port (default 8080 for both variants)
  --host, -H        bind address (default 0.0.0.0)
  --ctx, -c         max context length (default 262144)
  --batch, -b       llama.cpp logical batch size (default 2048)
  --ubatch, -ub     llama.cpp physical microbatch size (default 512)
  --download-only   prefetch model and exit
  --verify-only     verify tooling/auth/model snapshot, then exit"
end

function __llm_serve_stop --argument-names unit pattern
    if type -q systemctl
        systemctl --user stop $unit.service >/dev/null 2>&1
    end
    if type -q pkill
        pkill -f $pattern >/dev/null 2>&1
    end
end

function __llm_serve_status --argument-names unit pattern
    if type -q systemctl; and systemctl --user is-active --quiet $unit.service
        systemctl --user status $unit.service --no-pager
        return $status
    end
    if type -q pgrep
        pgrep -af $pattern
        return $status
    end
    echo "llm-serve: no supported status checker found" >&2
    return 1
end

function __llm_serve_stop_all
    set -l units llm-serve llm-serve-uncensored llm-serve-gemma llm-serve-gemma-uncensored
    set -l patterns \
        'llama-server .*models--unsloth--Qwen3\.6-27B-GGUF|llama-server .*--alias qwen3\.6:27b($| )' \
        'llama-server .*models--HauhauCS--Qwen3\.6-27B-Uncensored-HauhauCS-Aggressive|llama-server .*--alias qwen3\.6:27b-uncensored($| )' \
        'llama-server .*models--unsloth--gemma-4-31B-it-GGUF|llama-server .*--alias gemma4:31b($| )' \
        'llama-server .*models--TrevorJS--gemma-4-31B-it-uncensored-GGUF|llama-server .*--alias gemma4:31b-uncensored($| )'

    for unit in $units
        if type -q systemctl
            systemctl --user stop $unit.service >/dev/null 2>&1
        end
    end

    for pattern in $patterns
        if type -q pkill
            pkill -f $pattern >/dev/null 2>&1
        end
    end
end

function __llm_serve_refuse_if_any_other_running --argument-names selected_unit
    set -l units llm-serve llm-serve-uncensored llm-serve-gemma llm-serve-gemma-uncensored
    set -l names "regular Qwen3.6 27B" "uncensored Qwen3.6 27B" "Gemma 4 31B" "uncensored Gemma 4 31B"
    set -l stop_commands "llm-serve stop" "llm-serve stop --unc" "llm-serve stop --gemma" "llm-serve stop --gemma --unc"
    set -l patterns \
        'llama-server .*models--unsloth--Qwen3\.6-27B-GGUF|llama-server .*--alias qwen3\.6:27b($| )' \
        'llama-server .*models--HauhauCS--Qwen3\.6-27B-Uncensored-HauhauCS-Aggressive|llama-server .*--alias qwen3\.6:27b-uncensored($| )' \
        'llama-server .*models--unsloth--gemma-4-31B-it-GGUF|llama-server .*--alias gemma4:31b($| )' \
        'llama-server .*models--TrevorJS--gemma-4-31B-it-uncensored-GGUF|llama-server .*--alias gemma4:31b-uncensored($| )'

    for i in (seq 1 (count $units))
        test $units[$i] = $selected_unit
        and continue

        if type -q systemctl; and systemctl --user is-active --quiet $units[$i].service
            echo "llm-serve: $names[$i] is already running as $units[$i].service" >&2
            echo "  stop it first: $stop_commands[$i]" >&2
            return 1
        end
        if type -q pgrep; and pgrep -af $patterns[$i] >/dev/null 2>&1
            echo "llm-serve: $names[$i] is already running" >&2
            pgrep -af $patterns[$i] >&2
            return 1
        end
    end

    return 0
end

function __llm_serve_wait_ready --argument-names unit host port alias
    set -l probe_host $host
    test "$probe_host" = 0.0.0.0
    and set probe_host 127.0.0.1

    set -l url http://$probe_host:$port/v1/models
    echo "Waiting for $alias at $url ..."
    for attempt in (seq 1 120)
        if curl -fsS $url >/dev/null 2>&1
            echo "$alias is ready"
            return 0
        end
        sleep 1
    end

    echo "llm-serve: timed out waiting for $alias at $url" >&2
    systemctl --user status $unit.service --no-pager >&2 2>/dev/null
    return 1
end

function __llm_serve_download --argument-names model file
    echo "Prefetching GGUF..." >&2
    set -l output (HF_HUB_DISABLE_PROGRESS_BARS=1 hf download $model --include $file 2>&1); or begin
        printf '%s\n' $output >&2
        return 1
    end
    set -l clean (printf '%s\n' $output | sed 's/\x1b\[[0-9;]*m//g')
    for line in $clean
        set -l value (string split -m 1 -r 'path: ' -- $line)[-1]
        set -l value (string trim -- $value)
        test -z "$value"; and continue
        if test -d $value
            set value $value/$file
        end
        if test -f $value
            echo $value
            return 0
        end
    end
    for candidate in ~/.cache/huggingface/hub/models--(string replace -a '/' '--' $model)/snapshots/*/$file
        if test -f $candidate
            echo $candidate
            return 0
        end
    end
    echo "llm-serve: hf download did not return a valid GGUF path" >&2
    return 1
end
