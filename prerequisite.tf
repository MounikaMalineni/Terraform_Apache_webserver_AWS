resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-tf-sf-bucket"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "tf-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# vpc setup
resource "aws_vpc" "main" {
  cidr_block       = "20.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

#public subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "20.0.1.0/24"

  tags = {
    Name = "public subnet"
  }
}

#private subnet 1
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "20.0.2.0/24"

  tags = {
    Name = "private subnet 1"
  }
}

#private subnet 2
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "20.0.3.0/24"

  tags = {
    Name = "private subnet 2"
  }
}

resource "aws_s3_bucket" "webserver_configuration" {
  bucket = "webserver-conf"
  # Enable versioning so we can see the full revision history of our
  # index.html files
  versioning {
    enabled = true
  }
}

resource "aws_s3_object" "webserver_index" {
  key    = "index"
  bucket = aws_s3_bucket.webserver_configuration.id
  source = "index.html"
  etag   = filemd5("index.html")
}

resource "aws_sns_topic" "user_updates" {
  name = "user-updates-topic"
}