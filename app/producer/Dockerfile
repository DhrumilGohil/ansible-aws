FROM python:3.11-slim

WORKDIR /app

COPY . .

RUN pip install fastapi uvicorn kafka-python redis psycopg2-binary

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "3000"]