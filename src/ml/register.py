from mlflow.tracking import MlflowClient

mlflow_uri = "http://13.230.231.137:30080/"
client = MlflowClient(tracking_uri=mlflow_uri)

model_name = "xgboost_price_predictor"


latest = client.get_latest_versions(model_name, stages=["None", "Staging"])[0]
latest_version = latest.version

print("Latest version:", latest_version)

# Promote → Production
client.transition_model_version_stage(
    name=model_name,
    version=latest_version,
    stage="Production",
    archive_existing_versions=True
)

print(f"Model v{latest_version} promoted to PRODUCTION")
