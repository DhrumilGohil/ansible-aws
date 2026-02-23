import psycopg2
import os

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

def get_balance_db(user_id):
    cur = conn.cursor()
    cur.execute("SELECT balance FROM accounts WHERE user_id=%s", (user_id,))
    result = cur.fetchone()
    return result[0] if result else 0

def add_pending_update(transaction_id, user_id, amount):
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO pending_updates(transaction_id, user_id, amount) VALUES(%s,%s,%s)",
        (transaction_id, user_id, amount)
    )
    conn.commit()