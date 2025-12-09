# Dockerfile
FROM python:3.9-slim

RUN pip install mlflow boto3 scikit-learn

# Set MLflow tracking URI
ENV MLFLOW_TRACKING_URI=http://k8s-mlflow-mlflowin-4da4410a5a-161181029.ap-northeast-1.elb.amazonaws.com

# Expose the serving
EXPOSE 8080

# Command to serve the model
ENTRYPOINT ["mlflow", "models", "serve"]