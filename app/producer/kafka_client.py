from kafka import KafkaProducer
import json
import os

KAFKA_BROKER = os.getenv("KAFKA_BROKER", "localhost:9092")
TOPIC = os.getenv("KAFKA_TOPIC", "transactions")

producer = KafkaProducer(
    bootstrap_servers=KAFKA_BROKER,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

def produce_event(transaction_id, user_id, amount):
    event = {
        "transaction_id": transaction_id,
        "user_id": user_id,
        "amount": amount
    }
    producer.send(TOPIC, event)
    producer.flush()