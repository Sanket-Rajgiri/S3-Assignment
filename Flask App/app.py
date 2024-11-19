from flask import Flask, jsonify, make_response
from flask_cors import CORS
import boto3
from botocore.exceptions import BotoCoreError, ClientError
import os

app = Flask(__name__)
CORS(app) 


@app.route('/list-bucket-content/<path:bucket_path>', methods=['GET'])
@app.route('/list-bucket-content', defaults={'bucket_path': ''}, methods=['GET'])
def list_bucket_content(bucket_path):
    try:
        if bucket_path and not bucket_path.endswith('/'):
            bucket_path += '/'
            
        s3_client = boto3.client('s3')
        bucket_name = os.getenv('BUCKET_NAME')

        response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=bucket_path, Delimiter='/')
        print(response)
        content = []
        if 'CommonPrefixes' in response:
            content.extend([prefix['Prefix'].rstrip('/') for prefix in response['CommonPrefixes']])
        if 'Contents' in response:
            content.extend(
                obj["Key"].split("/")[-1]
                for obj in response["Contents"]
                if obj["Key"] != bucket_path  # Exclude the folder itself
            )
            
        if 'Contents' not in response and 'CommonPrefixes' not in response:
            return make_response(jsonify({"error": "Path not found"}), 404)

        return jsonify({"content": content})

    except ClientError as e:

        error_message = e.response.get('Error', {}).get('Message', 'An error occurred')
        return make_response(jsonify({"error": error_message}), 500)

    except BotoCoreError as e:

        return make_response(jsonify({"error": str(e)}), 500)

    except Exception as e:

        return make_response(jsonify({"error": "An unexpected error occurred", "details": str(e)}), 500)


@app.route("/health", methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({"error": "Resource not found"}), 404)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)