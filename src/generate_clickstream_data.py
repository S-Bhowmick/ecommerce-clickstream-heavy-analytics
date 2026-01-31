import pandas as pd
import numpy as np
from faker import Faker
from tqdm import tqdm
import uuid
import random
from datetime import datetime, timedelta

fake = Faker()

OUTPUT_PATH = "data/raw/clickstream_raw.parquet"

TOTAL_ROWS = 500_000      # safe for 8GB RAM
CHUNK_SIZE = 50_000       # generate in chunks

EVENT_TYPES = ["page_view", "product_view", "add_to_cart", "checkout"]
DEVICES = ["mobile", "desktop", "tablet"]
TRAFFIC_SOURCES = ["organic", "paid", "email", "social", "referral"]


def generate_chunk(chunk_size):
    data = []

    for _ in range(chunk_size):
        event_time = fake.date_time_between(
            start_date="-30d",
            end_date="now"
        )

        data.append({
            "event_id": str(uuid.uuid4()),
            "user_id": fake.uuid4(),
            "session_id": fake.uuid4(),
            "event_time": event_time,
            "event_type": random.choice(EVENT_TYPES),
            "product_id": random.randint(1000, 1100),
            "device": random.choice(DEVICES),
            "traffic_source": random.choice(TRAFFIC_SOURCES),
            "price": round(random.uniform(10, 500), 2)
        })

    return pd.DataFrame(data)


def main():
    print("Generating clickstream data...")
    all_chunks = []

    for _ in tqdm(range(TOTAL_ROWS // CHUNK_SIZE)):
        chunk = generate_chunk(CHUNK_SIZE)
        all_chunks.append(chunk)

    df = pd.concat(all_chunks, ignore_index=True)
    df.to_parquet(OUTPUT_PATH, index=False)

    print(f"Saved {len(df):,} rows to {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
