import json
import boto3
from urllib.parse import unquote_plus
import os

# Initialize S3 client
s3_client = boto3.client('s3')

# Replace with your bucket name
BUCKET_NAME = os.getenv("BUCKET_NAME")

def lambda_handler(event, context):
    """
    AWS Lambda handler for listing S3 bucket contents.
    """
    try:
        # Extract path parameter from API Gateway event
        path = event.get("pathParameters", {}).get("path", "").strip("/")
        print(event)
        # Decode URL-encoded characters in path
        path = unquote_plus(path)
        print(path)
        # Prepare the S3 prefix based on the path
        prefix = f"{path}/" if path else ""
        
        # List objects in the S3 bucket with the given prefix
        response = s3_client.list_objects_v2(
            Bucket=BUCKET_NAME,
            Prefix=prefix,
            Delimiter="/"
        )
        
        # Collect directories and files
        content = []
        
        # Add common prefixes (subdirectories)
        if "CommonPrefixes" in response:
            content.extend(
                prefix.get("Prefix").rstrip("/").split("/")[-1]
                for prefix in response["CommonPrefixes"]
            )
        
        # Add files
        if "Contents" in response:
            content.extend(
                obj["Key"].split("/")[-1]
                for obj in response["Contents"]
                if obj["Key"] != prefix  # Exclude the folder itself
            )
        
        if "Contents" not in response and "CommonPrefixes" not in response:
                    return {
            "statusCode": 404,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({"error": "Path not found"})
        }
                    
        # Return the content as JSON
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({"content": content})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({"error": str(e)})
        }
