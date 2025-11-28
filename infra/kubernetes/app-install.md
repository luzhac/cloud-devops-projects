-----eks-------
#
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

#
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update

helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver `
  -n kube-system

#







------ no eks ------------
export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl create ns trading
kubectl create ns monitoring

# 1
cd infra/kubernetes/helm
helm dependency update
helm install monitoring . -n monitoring -f values-monitoring.yaml
helm upgrade monitoring . -n monitoring -f values-monitoring.yaml


** updata efs id found in terraform **
# 2
helm install trading ./infra/kubernetes/helm/trading --namespace trading --create-namespace
helm uninstall trading -n trading

kubectl delete ns trading

helm upgrade trading ./infra/kubernetes/helm/trading -n trading

# 3
kubectl apply -f ./infra/kubernetes/helm/trading/templates/deployment-fetch-data.yaml  -n trading

helm upgrade trading . -n trading

kubectl exec -it -n trading generate-signal-8459977486-6t72j  -- bash
cd /mnt/efs
touch test.txt
ls -l test.txt

# 4 efs
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.5"

* use efs in ec2 *
sudo apt update
sudo apt install -y nfs-common

sudo mkdir -p /mnt/efs

sudo mount -t nfs4 -o nfsvers=4.1 fs-05aa06c00158d0795.efs.ap-northeast-1.amazonaws.com:/ /mnt/efs

sudo chmod 777 /mnt/efs
sudo chown -R 1000:1000 /mnt/efs


kubectl exec -it generate-signal-599cf7b6cd-bhpgn -n trading -c generate-signal -- bash




# 5 config  ecr login in working node

```
sudo apt install awscli

sudo ctr --namespace k8s.io images pull \
--user AWS:$(aws ecr get-login-password --region ap-northeast-1) \
--platform linux/arm64 \
173381466759.dkr.ecr.ap-northeast-1.amazonaws.com/quant:latest

```
-----------
# 3 ebs 
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update 
helm upgrade --install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver \
  --namespace kube-system \


 