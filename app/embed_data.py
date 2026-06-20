import psycopg2
from sentence_transformers import SentenceTransformer
from pinecone import Pinecone
from config import DB_CONFIG, PINECONE_API_KEY

# Connect to Pinecone
pc = Pinecone(api_key=PINECONE_API_KEY)
index = pc.Index("product-safety-rag")

# Load embedding model
model = SentenceTransformer("all-MiniLM-L6-v2")

# Connect to PostgreSQL
conn = psycopg2.connect(**DB_CONFIG)
cursor = conn.cursor()

# Retrieve products
cursor.execute("""
SELECT product_id,
       product_name,
       description
FROM products
WHERE description IS NOT NULL;
""")

products = cursor.fetchall()

print(f"Found {len(products)} products.")

vectors = []

for product_id, product_name, description in products:

    embedding = model.encode(description).tolist()

    vectors.append({
        "id": str(product_id),
        "values": embedding,
        "metadata": {
            "product_name": product_name,
            "description": description
        }
    })

# Upload to Pinecone
index.upsert(vectors=vectors)

print(f"Uploaded {len(vectors)} vectors to Pinecone.")

cursor.close()
conn.close()