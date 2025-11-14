



kubectl run python-test --image=python:3.10-slim --restart=Never -it -- bash




 kubectl exec -it mlflow-64676d95c5-7nbbc     -c mlflow   -n mlflow -- bash
 
kubectl logs mlflow-5f5b487d74-8n7hw                -n mlflow  -f


[notice] A new release of pip is available: 23.0.1 -> 25.3
[notice] To update, run: pip install --upgrade pip
bash: line 1:  mlflow: command not found
