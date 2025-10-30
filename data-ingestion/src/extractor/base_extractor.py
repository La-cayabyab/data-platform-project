import requests
import json
import os
from google.cloud import storage
from datetime import datetime

# Set up authentication using your Terraform service account
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/Users/la.cayabyab/Downloads/dataplatform-lab-internal-v1-tf-service-account.json'

def upload_to_gcs(data, endpoint_name, bucket_name):
    """ Uploads data to GCS bucket."""

    # time vars for naming blobs
    timestamp = datetime.now()
    year = timestamp.strftime("%Y")
    month = timestamp.strftime("%m")
    day = timestamp.strftime("%d")

    # Naming convention for GCS blob
    prefix = f"raw_data/{endpoint_name}/{year}/{month}/{day}"
    blob_name = f"{prefix}/{endpoint_name}_{timestamp.strftime('%Y%m%d_%H%M%S')}.json"

    # Initialize GCS client
    client = storage.Client(project='dataplatform-lab-internal-v1')
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(blob_name)

    blob.upload_from_string(  # Upload JSON data
        json.dumps(data, indent=2),
        content_type='application/json'
    )
    
    print(f"Successfully uploaded to gs://{bucket_name}/{blob_name}")
    return blob_name

# Fetch data
url = 'https://jsonplaceholder.typicode.com/posts'
params = {'format': 'json'}

try:
    response = requests.get(url, params=params)
    response.raise_for_status()
    json_data = response.json()
    
    print(f"Successfully fetched {len(json_data)} posts from API")
    
    # Google Cloud Storage setup (using bucket name from Terraform)
    bucket_name = 'dataplatform-lab-internal-v1-test-gcp-bucket'
    blob_path = upload_to_gcs(json_data, 'posts', bucket_name)

    print(f"File size: {len(json.dumps(json_data))} bytes")
    
except requests.RequestException as e:
    print(f"Failed to fetch data from API: {e}")
except Exception as e:
    print(f"Failed to upload to GCS: {e}")