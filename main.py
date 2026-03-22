import snowflake.connector
import time
import random
from datetime import datetime

# Connect to Snowflake
conn = snowflake.connector.connect(
    user='ADARSH44',
    password='Ads@adarsh1234',
    account='QOYSXYV-IF06636',
    warehouse='COMPUTE_WH',
    database='MAIN_VEHICLE',
    schema='VEHICLE'
)

cursor = conn.cursor()

vehicle_id = 1  # Only one vehicle

while True:
    time_stamp = datetime.now()

    speed = random.randint(40, 100)
    engine_temp = random.randint(60, 100)
    battery = round(random.uniform(8.0, 12.0), 2)
    gps = "12.9716"

    query = f"""
    INSERT INTO vehicle_data 
    (vehicle_id, time_stamp, speed, engine_temp, battery, gps)
    VALUES 
    ({vehicle_id}, '{time_stamp}', {speed}, {engine_temp}, {battery}, '{gps}')
    """

    cursor.execute(query)

    print(f"[LIVE] {time_stamp} | Speed={speed} | Temp={engine_temp} | Battery={battery}")

    time.sleep(5)