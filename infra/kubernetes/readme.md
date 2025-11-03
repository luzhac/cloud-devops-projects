

export KUBECONFIG=/etc/kubernetes/admin.conf


helm install trading ./infra/kubernetes/helm/trading --namespace trading --create-namespace
helm uninstall trading -n trading
kubectl delete ns trading


helm upgrade trading ./infra/kubernetes/helm/trading -n trading

kubectl exec -it -n trading generate-signal-8459977486-6t72j  -- bash
cd /mnt/efs
touch test.txt
ls -l test.txt



## config  ecr login

```
aws ecr get-login-password --region ap-northeast-1 \
| sudo ctr --namespace k8s.io images pull \
--user AWS:$(aws ecr get-login-password --region ap-northeast-1) \
--platform linux/arm64 \
173381466759.dkr.ecr.ap-northeast-1.amazonaws.com/quant:latest




```
 