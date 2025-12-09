------------ eks ------------
# 1 
kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm uninstall monitoring -n monitoring || true

helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --create-namespace \
  --set grafana.adminPassword="admin" \
  --set grafana.service.type=LoadBalancer \
  --set prometheus.service.type=LoadBalancer \
  --set alertmanager.service.type=LoadBalancer

output:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=monitoring"

Get Grafana 'admin' user password by running:

  kubectl --namespace monitoring get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

Access Grafana local instance:

  export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=monitoring" -oname)
  kubectl --namespace monitoring port-forward $POD_NAME 3000

kubectl -n monitoring port-forward svc/monitoring-kube-prometheus-prometheus 9090:9090


Get your grafana admin user password by running:

  kubectl get secret --namespace monitoring -l app.kubernetes.io/component=admin-secret -o jsonpath="{.items[0].data.admin-password}" | base64 --decode ; echo


Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.

# 2 alert

 

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

run query in explore




```dockerignore
from prometheus_client import start_http_server, Gauge
import time

 
freshness_gauge = Gauge('pipeline_last_success_timestamp', 'Last success timestamp of pipeline')

 
start_http_server(8000)   

while True:
    
    process_data()   

  
    freshness_gauge.set(time.time())

    time.sleep(60)

```

```dockerignore
scrape_configs:
  - job_name: "pipeline"
    static_configs:
      - targets: ["your-pipeline-service.monitoring.svc.cluster.local:8000"]

```
# 3 loki
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install loki grafana/loki-stack \
  -n monitoring \
  --set grafana.enabled=false \
  --set prometheus.enabled=false \
  --set loki.persistence.enabled=true \
  --set loki.persistence.size=20Gi \
  --set promtail.enabled=true
```
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
        url: http://loki.monitoring.svc.cluster.local:3100
        access: proxy
        editable: true
```

kubectl apply -f grafana-datasource-loki.yaml



```dockerignore
grafana:
  service:
    type: ClusterIP

alertmanager:
  service:
    type: ClusterIP

prometheus:
  service:
    type: ClusterIP

```
```helm upgrade monitoring \
  prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --reuse-values \
  --values lb-fix.yaml
```
 












-----no eks---------
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


