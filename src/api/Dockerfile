FROM python:3.10-slim

WORKDIR /app


COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY main.py .


ENV MLFLOW_TRACKING_URI=http://13.230.231.137:30080/
ENV MODEL_NAME=xgboost_price_predictor
ENV MODEL_STAGE=Production

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
