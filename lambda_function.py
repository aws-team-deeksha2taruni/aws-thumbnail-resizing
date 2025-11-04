import boto3
from PIL import Image
import io

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Download image from source bucket
    image_object = s3_client.get_object(Bucket=source_bucket, Key=key)
    image_content = image_object['Body'].read()

    image = Image.open(io.BytesIO(image_content))

    # Resize image (100x100)
    image = image.resize((100, 100))

    buffer = io.BytesIO()
    image.save(buffer, "JPEG")
    buffer.seek(0)

    # Upload resized image to processed bucket
    target_bucket = "image-resize-processed"
    new_key = f"resized-{key}"

    s3_client.put_object(
        Bucket=target_bucket,
        Key=new_key,
        Body=buffer,
        ContentType='image/jpeg'
    )

    return {"status": "Image resized", "bucket": target_bucket, "key": new_key}
