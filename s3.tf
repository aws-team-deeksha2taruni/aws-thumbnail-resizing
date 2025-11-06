# Source S3 bucket — where original images are uploaded
resource "aws_s3_bucket" "original_images" {
  bucket = "thumbnail-generator-source-bucket123"
  
}

# Destination S3 bucket — where resized thumbnails will be stored
resource "aws_s3_bucket" "resized_images" {
  bucket = "thumbnail-generator-destination-bucket123"
  
}


