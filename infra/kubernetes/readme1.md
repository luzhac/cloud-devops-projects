
1.
kubectl -n monitoring create configmap custom-rules --from-file=alert-rules.yaml



2.
kubectl -n monitoring edit configmap prometheus-server


3.In rule_files: add：

rule_files:
  - /etc/config/alert-rules.yaml
  - /etc/config/custom-rules/alert-rules.yaml


kubectl -n monitoring create configmap prometheus-custom-rules --from-file=alert-rules.yaml



4.restart Prometheus：

kubectl -n monitoring rollout restart deploy prometheus-server

5.
``` alertmanager-config.yaml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'youremail@gmail.com'
  smtp_auth_username: 'youremail@gmail.com'
  smtp_auth_password: ''
  smtp_require_tls: true

route:
  receiver: 'email-alert'

receivers:
  - name: 'email-alert'
    email_configs:
      - to: 'your_alert_receiver@gmail.com'
        send_resolved: true

```
6.
kubectl -n monitoring create secret generic alertmanager-config --from-file=alertmanager.yaml=alertmanager-config.yaml --dry-run=client -o yaml | kubectl apply -f -
kubectl -n monitoring rollout restart statefulset prometheus-alertmanager
