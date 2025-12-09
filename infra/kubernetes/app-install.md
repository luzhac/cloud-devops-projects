-----eks-----1.33--
(1.34 issue: may be with sa account not sucessful create)
aws eks update-kubeconfig --name k8s --region ap-northeast-1

# to support: kubectl top
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# efs
modiy the efs id in helm

eksctl utils associate-iam-oidc-provider --region=ap-northeast-1 --cluster=k8s --approve

### 
export cluster_name=k8s
export role_name=AmazonEKS_EFS_CSI_DriverRole
eksctl create iamserviceaccount \
    --name efs-csi-controller-sa \
    --namespace kube-system \
    --cluster $cluster_name \
    --role-name $role_name \
    --region=ap-northeast-1 \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy \
    --approve
TRUST_POLICY=$(aws iam get-role --output json --role-name $role_name --query 'Role.AssumeRolePolicyDocument' | \
    sed -e 's/efs-csi-controller-sa/efs-csi-controller-sa/' -e 's/StringEquals/StringLike/')
aws iam update-assume-role-policy --role-name $role_name --policy-document "$TRUST_POLICY"

aws iam get-role --role-name AmazonEKS_EFS_CSI_DriverRole


eksctl create addon \
  --name aws-efs-csi-driver \
  --cluster k8s \
  --region ap-northeast-1 \
  --service-account-role-arn arn:aws:iam::173381466759:role/AmazonEKS_EFS_CSI_DriverRole \
  --force

kubectl get pods -n kube-system | Select-String "efs"


# ebs 
https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html
1. install eksctl
2.
eksctl utils associate-iam-oidc-provider --region=ap-northeast-1 --cluster=k8s --approve
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster k8s \
  --override-existing-serviceaccounts \
  --region ap-northeast-1 \
  --role-name AmazonEKS_EBS_CSI_DriverRole \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve



aws eks create-addon \
  --cluster-name k8s \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn arn:aws:iam::173381466759:role/AmazonEKS_EBS_CSI_DriverRole \
  --region ap-northeast-1 \
  --resolve-conflicts OVERWRITE

## alb 

eksctl utils associate-iam-oidc-provider --cluster k8s --approve --region ap-northeast-1

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.13.3/docs/install/iam_policy.json
 
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
    --cluster=k8s \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::173381466759:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region ap-northeast-1 \
    --approve


helm repo add eks https://aws.github.io/eks-charts
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=k8s \
  --set serviceAccount.create=false \
  --set region=ap-northeast-1 \
  --set vpcId=vpc-0699454d45faef465 \
  --set serviceAccount.name=aws-load-balancer-controller






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


kubectl delete ns trading

helm upgrade trading ./infra/kubernetes/helm/trading -n trading

# 3
kubectl apply -f ./infra/kubernetes/helm/trading/templates/deployment-fetch-data.yaml  -n trading
kubectl apply -f ./infra/kubernetes/helm/trading/templates/mlflow.yaml  -n mlflow
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

sudo mount -t nfs4 -o nfsvers=4.1 fs-0aa65fb3dd434ad33.efs.ap-northeast-1.amazonaws.com:/ /mnt/efs

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


 