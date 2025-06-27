function kns --description 'Kubernetes namespace operations'
    if test (count $argv) -eq 0
        kubectl get ns
    else
        kubectl config set-context --current --namespace="$argv[1]"
    end
end