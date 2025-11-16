import mlflow
import mlflow.xgboost
import numpy as np
from xgboost import XGBRegressor
from sklearn.metrics import mean_squared_error
from mlflow.tracking import MlflowClient

# -----------------------------------

# -----------------------------------
mlflow.set_tracking_uri("http://13.230.231.137:30080/")
mlflow.set_experiment("xgboost-demo1")

client = MlflowClient()

# -----------------------------------

# -----------------------------------
X = np.array([[i] for i in range(1, 101)])
y = np.array([3 * i + np.random.randn() * 2 for i in range(1, 101)])

# -----------------------------------

# -----------------------------------
with mlflow.start_run(run_name="xgboost_model_run") as run:
    run_id = run.info.run_id
    print("Run ID:", run_id)


    model = XGBRegressor(
        n_estimators=100,
        max_depth=4,
        learning_rate=0.01,
        subsample=0.8,
        objective="reg:squarederror"
    )


    model.fit(X, y)


    preds = model.predict(X)
    mse = mean_squared_error(y, preds)

    # MLflow logging
    mlflow.log_params({
        "n_estimators": 100,
        "max_depth": 4,
        "learning_rate": 0.1
    })

    mlflow.log_metric("mse", mse)
    mlflow.log_metric("rmse", mse ** 0.5)


    model_uri = mlflow.xgboost.log_model(
        model,
        artifact_path="model",
        registered_model_name="xgboost_price_predictor"
    )

    print("Model logged & registered:", model_uri)
