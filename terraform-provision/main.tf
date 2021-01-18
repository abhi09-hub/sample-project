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

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
   region = "us-east-1"
}

resource "aws_lambda_function" "example" {
   function_name = "ServerlessExample"

   # The bucket name as created earlier with "aws s3api create-bucket"
   s3_bucket = "terraform-serverless-example"
   s3_key    = "v1.0.0/example.zip"

   # "main" is the filename within the zip file (main.js) and "handler"
   # is the name of the property under which the handler function was
   # exported in that file.
   handler = "main.handler"
   runtime = "nodejs10.x"

   role = aws_iam_role.lambda_exec.arn
}

 # IAM role which dictates what other AWS services the Lambda function
 # may access.
resource "aws_iam_role" "lambda_exec" {
   name = "serverless_example_lambda"

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

