function kctx --description 'Kubernetes context operations'
    if test (count $argv) -eq 0
        kubectl config get-contexts
    else
        kubectl config use-context "$argv[1]"
    end
end