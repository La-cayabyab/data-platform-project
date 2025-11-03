import os
import sys
import logging
from common.ingest_pipeline import extract_load

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

"""
Extracts data from the posts API endpoint and uploads it to GCS to then be loaded to BigQuery.
"""
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')

if __name__ == "__main__":
    try:
        url = 'https://jsonplaceholder.typicode.com/posts'
        params = {'format': 'json'}
        extract_load(url, params, 'posts', )
    except Exception as e:
        logging.critical(f"Undefined error occurred: {e}")
