import redis
import os

REDIS_HOST = os.getenv("REDIS_HOST", "localhost")

r = redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)

def get_balance_cache(user_id):
    value = r.get(user_id)
    return float(value) if value else None

def set_balance_cache(user_id, balance):
    r.set(user_id, balance)