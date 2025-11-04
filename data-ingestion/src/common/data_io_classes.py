import requests
import json
from google.cloud import storage
from datetime import datetime

"""
Utility classes for data ingestion: APIExtractor (extracts data) and GCSUploader (uploads data).
"""
class APIExtractor:

    def __init__(self, url, params=None):
        self.url = url
        self.params = params

    def extract(self):
        """extract data from a specified API endpoint."""
        try:
            response = requests.get(self.url, params=self.params)
            response.raise_for_status()
            print(f"Successfully extracted data from {self.url}")
            return response.json()
        except requests.RequestException as e:
            print(f"Failed to extract data. Error Code: {e}")
            return None

class GCSUploader:
    def __init__(self, bucket_name, project_id):
        self.bucket_name = bucket_name
        self.project_id = project_id
        self.client = storage.Client(project=self.project_id)
        self.bucket = self.client.bucket(self.bucket_name)

    def upload(self, data, endpoint_name):
        """Upload JSON to GCS bucket."""
        try:
            timestamp = datetime.now()
            prefix = f"raw_data/{endpoint_name}/{timestamp.strftime('%Y/%m/%d')}/"
            blob_name = f"{prefix}{endpoint_name}_{timestamp.strftime('%Y%m%d_%H%M%S')}.json"
            blob = self.bucket.blob(blob_name)
            blob.upload_from_string(json.dumps(data, indent=2), content_type='application/json')
            print(f"Successfully uploaded to GCS://{self.bucket_name}/{blob_name}")
            return blob_name
        except Exception as e:
            print(f"Failed to upload data to GCS. Error: {e}")
            return None
