# Define an S3 bucket resource to store the original images.
# This bucket is named "image-resize-originals" and will hold
# the unprocessed images that are uploaded for resizing.

resource "aws_s3_bucket" "original_images" {
  bucket = "image-resize-originals"
}


# Define another S3 bucket resource to store resized/processed images.
# This bucket is named "image-resize-processed" and will hold the output
# images produced by the Lambda function after resizing.

resource "aws_s3_bucket" "resized_images" {
  bucket = "image-resize-processed"

}
