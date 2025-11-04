1. prometheus and grafana
kubectl create namespace monitoring

helm uninstall prometheus -n monitoring
helm uninstall grafana -n monitoring
helm uninstall kube-state-metrics -n monitoring
helm uninstall node-exporter -n monitoring

helm uninstall monitoring -n monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --create-namespace \
  --set grafana.adminPassword=admin \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30300 \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePort=30900 \
  --set alertmanager.service.type=NodePort \
  --set alertmanager.service.nodePort=30903

2. alert

 

```dockerignore
cat > alertmanager-config.yaml <<EOF
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: '@gmail.com'
  smtp_auth_username: '@gmail.com'
  smtp_auth_password: ''
  smtp_require_tls: true

route:
  receiver: 'email-alert'

receivers:
  - name: 'email-alert'
    email_configs:
      - to: '@gmail.com'
        send_resolved: true
EOF
```

kubectl -n monitoring create secret generic alertmanager-monitoring-kube-prometheus-alertmanager \
  --from-file=alertmanager.yaml=alertmanager-config.yaml \
  --dry-run=client -o yaml | kubectl apply -f -




kubectl -n monitoring rollout restart statefulset alertmanager-monitoring-kube-prometheus-alertmanager 

kubectl -n monitoring get pods -l app.kubernetes.io/name=alertmanager

3.Loki + Promtail

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# 
helm install loki grafana/loki-stack \
  -n monitoring \
  --set grafana.enabled=false \
  --set prometheus.enabled=false \
  --set loki.persistence.enabled=false \
  --set promtail.enabled=true




``` 
#grafana-datasource-loki.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasource-loki
  namespace: monitoring
  labels:
    grafana_datasource: "1"
data:
  loki-datasource.yaml: |
    apiVersion: 1
    datasources:
      - name: Loki
        type: loki
        access: proxy
        url: http://loki.monitoring.svc.cluster.local:3100
        isDefault: false
        editable: true

```

---------------------


