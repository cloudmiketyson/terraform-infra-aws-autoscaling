# KMS key to allow for the encryption of the state bucket

resource "aws_kms_key" "terraform-state-bucket-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "key-alias" {
  name          = "alias/terraform-state-bucket-key"
  target_key_id = aws_kms_key.terraform-state-bucket-key.key_id
}

# S3 bucket to hold terraform state file

resource "aws_s3_bucket" "terraform-state-bucket01" {
  bucket = "autoscaling-tfstate"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state-encrypt" {
  bucket = aws_s3_bucket.terraform-state-bucket01.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform-state-bucket-key.arn
    }
  }
}

resource "aws_dynamodb_table" "terraform-state-lock" {
  name           = "terraform-state"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
