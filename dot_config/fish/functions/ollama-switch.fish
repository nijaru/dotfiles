function ollama-switch -d "Switch between local and remote Ollama"
    switch $argv[1]
        case local
            set -e OLLAMA_HOST
            echo "🏠 Using local Ollama"
        case remote fedora
            set -gx OLLAMA_HOST http://100.93.39.25:11434
            echo "🌐 Using remote Ollama: $OLLAMA_HOST"
        case '*'
            echo "Usage: ollama-switch {local|remote}"
            echo "Current: "(if set -q OLLAMA_HOST; echo $OLLAMA_HOST; else; echo "local"; end)
    end
end