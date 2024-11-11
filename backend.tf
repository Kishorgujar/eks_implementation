terraform {
  backend "s3" {
    bucket = "mybuck281024"
    key    = "terraform.tfstate" # Specifies the path within the bucket
    region = "ap-south-1"        # Specifies the AWS region of your S3 bucket
  }
}
