import mlflow.pyfunc
import numpy as np

mlflow.set_tracking_uri("http://13.230.231.137:30080/")

model_name = "xgboost_price_predictor"
stage = "Production"

model = mlflow.pyfunc.load_model(f"models:/{model_name}/{stage}")

X_pred = np.array([[120], [121], [122]])
preds = model.predict(X_pred)

print("Predictions:", preds)
