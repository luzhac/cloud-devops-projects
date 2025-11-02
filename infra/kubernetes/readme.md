

export KUBECONFIG=/etc/kubernetes/admin.conf


helm install trading ./infra/kubernetes/helm/trading --namespace trading --create-namespace
helm uninstall trading -n trading
kubectl delete ns trading


helm upgrade trading ./infra/kubernetes/helm/trading -n trading


