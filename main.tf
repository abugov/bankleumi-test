####################
# please see General Comments in README.md
####################

terraform {
  required_version = ">= 1.5.7"
}

provider "aws" {
  region  = "us-east-1"
}

variable "function_name" {
  default     = "hello_world_6"
  type        = string
}

variable "lamda_role" {
  default     = "lamda_role_6"
  type        = string
}

variable "stage" {
  default     = "test_6"
  type        = string
}

variable "bucket" {
  default     = "abugov-test-bucket-6"
  type        = string
}

data "archive_file" "lambda_zip_file" {
  type        = "zip"
  source_file = "${path.module}/index.mjs"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_s3_bucket" "code_bucket" {
  bucket = var.bucket
}

resource "aws_s3_object" "initial_lambda_zip" {
  bucket = aws_s3_bucket.code_bucket.id
  key    = "lambda.zip"
  source = data.archive_file.lambda_zip_file.output_path
}

resource "aws_lambda_function" "lambda_function" {
  depends_on = [aws_s3_object.initial_lambda_zip]
  function_name = var.function_name

  s3_bucket        = aws_s3_bucket.code_bucket.bucket
  s3_key           = "lambda.zip"

  handler = "index.handler"
  runtime = "nodejs20.x"

  role = "${aws_iam_role.lambda_exec.arn}"
}

# IAM role which dictates what other AWS services the Lambda function may access
resource "aws_iam_role" "lambda_exec" {
  name = var.lamda_role

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

resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = var.function_name
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.api_gateway.root_resource_id}"
  path_part   = var.function_name
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.api_gateway.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda_function.invoke_arn}"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.lambda_root]

  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  stage_name  = var.stage
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

output "api_endpoint" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}