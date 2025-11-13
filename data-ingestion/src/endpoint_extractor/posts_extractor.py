import os
import sys
import logging

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from common.ingest_pipeline import extract_load

"""
Extracts data from the posts API endpoint and uploads it to GCS to then be loaded to BigQuery.
"""

def extract_posts():
    try:
        url = 'https://jsonplaceholder.typicode.com/posts'
        params = {'format': 'json'}
        extract_load(url, params, 'posts', )
    except Exception as e:
        logging.exception(f"Undefined error occurred: {e}")
