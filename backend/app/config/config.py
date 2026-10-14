import os
from dotenv import load_dotenv

load_dotenv()

config = {
    "POSTGRES_USERNAME": os.getenv("POSTGRES_USERNAME"),
    "POSTGRES_PASSWORD": os.getenv("POSTGRES_PASSWORD"),
    "POSTGRES_DB": os.getenv("POSTGRES_DB"),
    "PORT": os.getenv("PORT"), 
    "POSTGRES_HOST": os.getenv("POSTGRES_HOST")
}