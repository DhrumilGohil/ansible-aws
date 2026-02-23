import uuid
from fastapi import FastAPI, HTTPException
from kafka_client import produce_event
from redis_client import get_balance_cache, set_balance_cache
from db_client import get_balance_db, add_pending_update

app = FastAPI()

@app.post("/update/{user_id}")
async def update_balance(user_id: str, amount: float):
    transaction_id = str(uuid.uuid4())

    # Produce event to Kafka
    produce_event(transaction_id, user_id, amount)

    # Update Redis cache
    try:
        current = get_balance_cache(user_id) or 0
        new_balance = current + amount
        set_balance_cache(user_id, new_balance)
    except Exception:
        # Redis down fallback
        add_pending_update(transaction_id, user_id, amount)

    return {"status": "accepted", "transaction_id": transaction_id}


@app.get("/balance/{user_id}")
async def get_balance(user_id: str):
    # Try Redis first
    try:
        balance = get_balance_cache(user_id)
        if balance is not None:
            return {"user_id": user_id, "balance": balance}
    except Exception:
        pass

    # fallback to DB
    balance = get_balance_db(user_id)
    return {"user_id": user_id, "balance": balance}