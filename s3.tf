resource "aws_s3_bucket" "original_images" {
  bucket = "thumbnail-generator-source-bucket1"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [bucket]
  }
}

resource "aws_s3_bucket" "resized_images" {
  bucket = "thumbnail-generator-destination-bucket"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [bucket]
  }
}
