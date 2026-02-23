from kafka import KafkaConsumer
import json
import psycopg2
import os

KAFKA_BROKER = os.getenv("KAFKA_BROKER", "localhost:9092")
TOPIC = os.getenv("KAFKA_TOPIC", "transactions")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "healthcare")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "postgres")

conn = psycopg2.connect(
    host=DB_HOST,
    database=DB_NAME,
    user=DB_USER,
    password=DB_PASS
)

consumer = KafkaConsumer(
    TOPIC,
    bootstrap_servers=KAFKA_BROKER,
    value_deserializer=lambda m: json.loads(m.decode('utf-8')),
    group_id="healthcare-consumer"
)

def process_event(event):
    transaction_id = event["transaction_id"]
    user_id = event["user_id"]
    amount = event["amount"]

    cur = conn.cursor()

    # idempotency check
    cur.execute(
        "SELECT 1 FROM processed_transactions WHERE transaction_id=%s",
        (transaction_id,)
    )
    if cur.fetchone():
        return

    cur.execute(
        "UPDATE accounts SET balance = balance + %s WHERE user_id=%s",
        (amount, user_id)
    )

    cur.execute(
        "INSERT INTO processed_transactions(transaction_id) VALUES(%s)",
        (transaction_id,)
    )

    conn.commit()

for message in consumer:
    process_event(message.value)