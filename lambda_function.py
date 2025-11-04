import logging
import boto3
from io import BytesIO
from PIL import Image
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f"Event received: {event}")

    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]

    thumbnail_bucket = os.environ.get("THUMBNAIL_BUCKET", "cp-thumbnail-image-bucket")
    thumbnail_name, thumbnail_ext = os.path.splitext(key)
    thumbnail_key = f"{thumbnail_name}_thumbnail{thumbnail_ext}"

    s3_client = boto3.client("s3")

    response = s3_client.get_object(Bucket=bucket, Key=key)
    file_byte_string = response["Body"].read()
    img = Image.open(BytesIO(file_byte_string))

    img.thumbnail((500, 500))
    buffer = BytesIO()
    img.save(buffer, "JPEG")
    buffer.seek(0)

    result = s3_client.put_object(
        Bucket=thumbnail_bucket,
        Key=thumbnail_key,
        Body=buffer
    )

    status_code = result["ResponseMetadata"]["HTTPStatusCode"]
    if status_code != 200:
        raise Exception(f"Failed to upload image {key} to bucket {thumbnail_bucket}")

    return {"statusCode": 200, "body": f"Thumbnail {thumbnail_key} created successfully."}
