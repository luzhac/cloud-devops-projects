from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import numpy as np
import mlflow.pyfunc
import time

# Prometheus metrics
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import Response


MLFLOW_TRACKING_URI = os.getenv("MLFLOW_TRACKING_URI", "http://13.230.231.137:30080/")
MODEL_NAME = os.getenv("MODEL_NAME", "xgboost_price_predictor")
MODEL_STAGE = os.getenv("MODEL_STAGE", "Production")

app = FastAPI(title="Crypto Price Predictor API")


REQUEST_COUNT = Counter(
    "prediction_requests_total",
    "Total prediction requests",
    ["endpoint", "status"]
)

PREDICTION_LATENCY = Histogram(
    "prediction_latency_seconds",
    "Prediction latency in seconds",
    ["endpoint"]
)


mlflow.set_tracking_uri(MLFLOW_TRACKING_URI)
MODEL_URI = f"models:/{MODEL_NAME}/{MODEL_STAGE}"
model = mlflow.pyfunc.load_model(MODEL_URI)



class PredictRequest(BaseModel):
    values: list  # e.g. [120, 121, 122]


class PredictResponse(BaseModel):
    predictions: list
    model_name: str
    model_stage: str



@app.get("/healthz")
def healthz():
    return {"status": "ok", "model_uri": MODEL_URI}


@app.get("/metrics")
def metrics():
    # 用于 Prometheus 抓取
    data = generate_latest()
    return Response(content=data, media_type=CONTENT_TYPE_LATEST)


@app.post("/predict", response_model=PredictResponse)
def predict(req: PredictRequest):
    start = time.time()
    try:
        X = np.array([[v] for v in req.values], dtype=float)
        preds = model.predict(X)
        duration = time.time() - start

        REQUEST_COUNT.labels(endpoint="/predict", status="success").inc()
        PREDICTION_LATENCY.labels(endpoint="/predict").observe(duration)

        return PredictResponse(
            predictions=[float(p) for p in preds],
            model_name=MODEL_NAME,
            model_stage=MODEL_STAGE,
        )
    except Exception as e:
        REQUEST_COUNT.labels(endpoint="/predict", status="error").inc()
        raise HTTPException(status_code=500, detail=str(e))
