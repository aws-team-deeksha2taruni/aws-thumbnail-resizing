import logging
import boto3
from io import BytesIO
from PIL import Image
import os

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f"Event received: {event}")
    logger.info(f"Context: {context}")

    # Extract bucket and object key from the event
    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]

    # Define destination bucket and thumbnail key
    thumbnail_bucket = "cp-thumbnail-image-bucket"
    thumbnail_name, thumbnail_ext = os.path.splitext(key)
    thumbnail_key = f"{thumbnail_name}_thumbnail{thumbnail_ext}"

    logger.info(
        f"Source Bucket: {bucket}, Source Key: {key}, "
        f"Destination Bucket: {thumbnail_bucket}, Thumbnail Key: {thumbnail_key}"
    )

    # Initialize S3 client
    s3_client = boto3.client("s3")

    # Load image from S3
    response = s3_client.get_object(Bucket=bucket, Key=key)
    file_byte_string = response["Body"].read()
    img = Image.open(BytesIO(file_byte_string))

    logger.info(f"Original image size: {img.size}")

    # Generate thumbnail
    img.thumbnail((500, 500), Image.ANTIALIAS)
    logger.info(f"Thumbnail size: {img.size}")

    # Save thumbnail to buffer
    buffer = BytesIO()
    img.save(buffer, "JPEG")
    buffer.seek(0)

    # Upload thumbnail to destination bucket
    result = s3_client.put_object(
        Bucket=thumbnail_bucket,
        Key=thumbnail_key,
        Body=buffer
    )

    # Check upload status
    status_code = result["ResponseMetadata"]["HTTPStatusCode"]
    if status_code != 200:
        raise Exception(f"Failed to upload image {key} to bucket {thumbnail_bucket}")

    return event