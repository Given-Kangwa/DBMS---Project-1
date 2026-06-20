import psycopg2
from config import DB_CONFIG

try:
    conn = psycopg2.connect(**DB_CONFIG)
    print("Database connection successful!")
    conn.close()

except Exception as e:
    print("Connection failed:")
    print(e)