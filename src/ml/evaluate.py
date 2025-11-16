import numpy as np
import mlflow.pyfunc
from sklearn.metrics import mean_squared_error

mlflow.set_tracking_uri("http://13.230.231.137:30080/")

model_name = "xgboost_price_predictor"
stage = "Production"

model = mlflow.pyfunc.load_model(f"models:/{model_name}/{stage}")

X = np.array([[i] for i in range(1, 101)])
y = np.array([3 * i for i in range(1, 101)])

preds = model.predict(X)
mse = mean_squared_error(y, preds)

print("Production Model MSE:", mse)
