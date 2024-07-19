# Create a restful api to publish the lambda function.
resource "aws_api_gateway_rest_api" "WildRydes" {
  name = "WildRydes"
}

# Create an Authorizer for the API, so we can use of the cognito user pool.
resource "aws_api_gateway_authorizer" "WildRydes" {
  name          = "WildRydes"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.WildRydes.id
  provider_arns = [aws_cognito_user_pool.WildRydes.arn]
}

# Create a new resource within the api.
resource "aws_api_gateway_resource" "ride" {
  rest_api_id = aws_api_gateway_rest_api.WildRydes.id
  parent_id   = aws_api_gateway_rest_api.WildRydes.root_resource_id
  path_part   = "ride"
}

# Create a method for the ride resource within the api
# We specifically need a post method to post our requests from the customers.
resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.WildRydes.id
  resource_id   = aws_api_gateway_resource.ride.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.WildRydes.id
}

# The response for our post method
resource "aws_api_gateway_method_response" "post" {
  rest_api_id = aws_api_gateway_rest_api.WildRydes.id
  resource_id = aws_api_gateway_resource.ride.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"

  # Handling CORS
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Creating an integration between the rest api and the lambda function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.WildRydes.id
  resource_id             = aws_api_gateway_resource.ride.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.RequestUnicorn.invoke_arn
}

# The response for the integration
resource "aws_api_gateway_integration_response" "post" {
  rest_api_id = aws_api_gateway_rest_api.WildRydes.id
  resource_id = aws_api_gateway_resource.ride.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.post.status_code

  # cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.post,
    aws_api_gateway_integration.lambda_integration
  ]
}

# Created an option method to handle CORS, inorder for our api to be used from any website.
resource "aws_api_gateway_method" "options" {
  rest_api_id      = aws_api_gateway_rest_api.WildRydes.id
  resource_id      = aws_api_gateway_resource.ride.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.WildRydes.id
  resource_id = aws_api_gateway_resource.ride.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.WildRydes.id
  resource_id          = aws_api_gateway_resource.ride.id
  http_method          = "OPTIONS"
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.WildRydes.id
  resource_id = aws_api_gateway_resource.ride.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  # cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options_integration,
  ]
}

# Deploying the rest api gateway
resource "aws_api_gateway_deployment" "deploymet" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.options_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.WildRydes.id
  stage_name  = "prod"
}











