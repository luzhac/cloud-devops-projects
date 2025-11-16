

# ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# cert-manager

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

# Create a username/password file:

htpasswd -c auth mlflowuser


#  Create secret:

kubectl create secret generic mlflow-basic-auth --from-file=auth

# certificate
 kubectl get certificate

kubectl delete certificate mlflow-tls


kubectl run python-test --image=python:3.10-slim --restart=Never -it -- bash

 

 kubectl exec -it mlflow-6c9fd684c5-q8qh8      -c mlflow   -n mlflow -- bash
 
kubectl logs mlflow-6c9fd684c5-q8qh8               -n mlflow  -f


```dockerignore


```


 
