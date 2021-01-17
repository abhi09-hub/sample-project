provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
  shared_credentials_file = "G:/Test/terraform-provision/.aws/credentials"
}
resource "aws_instance" "Test" {
  ami           = var.ami_id
  instance_type = var.aws_instance_type


  tags = {
    Name = "Test-EC2"
  }
}

resource "aws_sqs_queue" "test_queue" {
  name                      = "terraform-test-queue"
  tags = {
    Environment = "production"
  }
}