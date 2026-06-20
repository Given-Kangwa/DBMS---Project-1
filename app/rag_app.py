from sentence_transformers import SentenceTransformer
from pinecone import Pinecone
from config import PINECONE_API_KEY

# Connect to Pinecone
pc = Pinecone(api_key=PINECONE_API_KEY)

index = pc.Index("product-safety-rag")

# Load embedding model
model = SentenceTransformer("all-MiniLM-L6-v2")

print("=== Product Safety RAG System ===")

while True:
    question = input("\nAsk a question (or type 'exit'): ")

    if question.lower() == "exit":
        print("Goodbye!")
        break

    # Generate embedding for the question
    query_embedding = model.encode(question).tolist()

    # Search Pinecone
    results = index.query(
        vector=query_embedding,
        top_k=3,
        include_metadata=True
    )

    print("\nRelevant Results:\n")

    matches = results.get("matches", [])

    if len(matches) == 0:
        print("No relevant products found.")
        continue

    for i, match in enumerate(matches, start=1):
        metadata = match["metadata"]

        print(f"Result {i}")
        print(f"Product Name: {metadata.get('product_name', 'N/A')}")
        print(f"Description: {metadata.get('description', 'N/A')}")
        print(f"Source Citation: Product ID = {match['id']}")
        print(f"Similarity Score: {match['score']:.4f}")
        print("-" * 50)