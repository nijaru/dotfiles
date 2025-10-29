function klogs --description 'View Kubernetes pod logs'
    set -l POD (kubectl get pods | grep "$argv[1]" | awk '{print $1}')
    kubectl logs -f "$POD" $argv[2..-1]
end