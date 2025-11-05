import os
import logging
from common.data_io_classes import APIExtractor, GCSUploader
from common.config import BUCKET_NAME, PROJECT_ID, CREDENTIALS_PATH

"""
Workflow function to extract data from an API and load it into GCS.
"""
def extract_load(url, params, endpoint_name):
    extractor = APIExtractor(url, params)
    data = extractor.extract()
    if data:
        uploader = GCSUploader(BUCKET_NAME, PROJECT_ID)
        upload_results = uploader.upload(data, endpoint_name)
        if upload_results:
            logging.info("Data ingestion completed successfully.")
        else:
            logging.error("Data ingestion failed during upload.")
    else:
        logging.warning("No data extracted; skipping upload.")
