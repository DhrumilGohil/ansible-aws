import os
import psycopg2
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

DB_HOST = os.environ.get("DB_HOST")
DB_NAME = os.environ.get("DB_NAME")
DB_USER = os.environ.get("DB_USER")
DB_PASS = os.environ.get("DB_PASS")

def get_connection():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        port=5432
    )

class User(BaseModel):
    name: str
    email: str

# INSERT
@app.post("/users")
def create_user(user: User):
    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute(
            "INSERT INTO users (name, email) VALUES (%s, %s) RETURNING id",
            (user.name, user.email)
        )

        user_id = cur.fetchone()[0]

        conn.commit()
        cur.close()
        conn.close()

        return {
            "status": "success",
            "id": user_id
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# GET
@app.get("/users")
def get_users():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT id, name, email FROM users")

    rows = cur.fetchall()

    result = []
    for row in rows:
        result.append({
            "id": row[0],
            "name": row[1],
            "email": row[2]
        })

    cur.close()
    conn.close()

    return result


# DELETE
@app.delete("/users/{user_id}")
def delete_user(user_id: int):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("DELETE FROM users WHERE id = %s", (user_id,))
    conn.commit()

    cur.close()
    conn.close()

    return {"status": "deleted"}
