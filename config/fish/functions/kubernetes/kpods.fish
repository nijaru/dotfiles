function kpods --description 'List Kubernetes pods with details'
    kubectl get pods $argv -o wide
end