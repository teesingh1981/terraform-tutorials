# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "myapi"
  description = "rest api gw"
    endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "ping"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  # CHANGE ACCOUNT ID
  source_arn = "arn:aws:execute-api:eu-west-2:<ACCOUNT_ID>:aws_api_gateway_rest_api.api.id/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_lambda_function" "lambda" {
  #filename      = "hello-python.zip"
  function_name = "mylambda"
  s3_bucket = "mybucket98745a"
  s3_key = "lambda_function.zip"
  role          = aws_iam_role.role.arn
  handler       = "lambda.lambda_handler"
  runtime       = "nodejs16.x"
  memory_size = 512

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda.zip"))}"
  source_code_hash = filebase64sha256("hello-python.zip")
}

resource "aws_api_gateway_deployment" "hello_world_v1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
#   depends_on = [
#     aws_api_gateway_method.hello_world_v1_get,
#     aws_api_gateway_method.hello_world_v1_post
#  ]
}

resource "aws_api_gateway_stage" "hello_world_v1" {
  deployment_id = aws_api_gateway_deployment.hello_world_v1.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
}

# IAM
resource "aws_iam_role" "role" {
  name = "myrole"

  assume_role_policy = <<POLICY
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
POLICY
}