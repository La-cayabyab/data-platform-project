import os
import sys
import logging

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from common.ingest_pipeline import extract_load

"""
Extracts data from the comments API endpoint and uploads it to GCS to then be loaded to BigQuery.
"""

def extract_comments():
    try:
        url = 'https://jsonplaceholder.typicode.com/comments'
        params = {'format': 'json'}
        extract_load(url, params, 'comments', )
    except Exception as e:
        logging.exception(f"Undefined error occurred: {e}")

# if __name__ == "__main__":
#     extract_comments()