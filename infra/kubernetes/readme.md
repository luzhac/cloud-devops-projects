kubectl create namespace monitoring

helm install grafana grafana/grafana -n monitoring \
  --set service.type=NodePort \
  --set service.nodePort=30300 \
  --set adminUser=admin \
  --set adminPassword=admin \
  --set persistence.enabled=false



helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm uninstall prometheus -n monitoring

helm install prometheus prometheus-community/prometheus -n monitoring \
  --set server.service.type=NodePort \
  --set server.service.nodePort=30900 \
  --set server.persistentVolume.enabled=false






helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm uninstall loki -n monitoring

helm install loki grafana/loki -n monitoring \
  --set deploymentMode=SingleBinary \
  --set singleBinary.replicas=1 \
  --set simpleScalable.replicas=0 \
  --set backend.replicas=0 \
  --set read.replicas=0 \
  --set write.replicas=0 \
  --set loki.auth_enabled=false \
  --set loki.commonConfig.replication_factor=1 \
  --set loki.storage.type=filesystem \
  --set loki.storage.filesystem.rulesDirectory=/var/loki/rules \
  --set loki.storage.bucketNames.chunks=chunks \
  --set loki.storage.bucketNames.ruler=ruler \
  --set loki.storage.bucketNames.admin=admin \
  --set loki.useTestSchema=true \
  --set persistence.enabled=false




helm install promtail grafana/promtail -n monitoring \
  --set "config.clients[0].url=http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push"









------------



export KUBECONFIG=/etc/kubernetes/admin.conf














kubectl create ns trading
kubectl create ns monitoring



cd infra/kubernetes/helm/platform
helm dependency update
helm install monitoring . -n monitoring -f values-monitoring.yaml

helm upgrade monitoring . -n monitoring -f values-monitoring.yaml



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
 