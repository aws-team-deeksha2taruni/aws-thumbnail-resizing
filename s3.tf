resource "aws_s3_bucket" "original_images" {
  bucket = "thumbnail-generator-source-bucket1"      #source bucket
  acl    = "private"
}

resource "aws_s3_bucket" "resized_images" {
  bucket = "thumbnail-generator-destination-bucket"  #destination bucket
  acl    = "private"
}
