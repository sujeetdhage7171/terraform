terraform {
  backend "s3" {
    bucket         = "s3bucket-for-statefile"   # your bucket name
    key            = "networking/vpc.tfstate"   # unique path for this project
    region         = "us-east-1"                # must match your bucket region
    dynamodb_table = "dynamo-table-s3"          # your lock table
    encrypt        = true
  }
}
