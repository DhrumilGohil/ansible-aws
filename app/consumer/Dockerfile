FROM python:3.11

WORKDIR /app

COPY . .

RUN pip install fastapi uvicorn kafka-python redis psycopg2

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "3000"]