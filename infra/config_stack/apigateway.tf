resource "aws_apigatewayv2_api" "api" {
  depends_on    = [aws_lambda_function.lambda]
  name          = "http-crud-tutorial-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "api_route_get_items_id" {
  depends_on = [aws_apigatewayv2_api.api]
  api_id     = aws_apigatewayv2_api.api.id
  route_key  = "GET /items/{id}"
  target     = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_route" "api_route_get_items" {
  depends_on = [aws_apigatewayv2_api.api]
  api_id     = aws_apigatewayv2_api.api.id
  route_key  = "GET /items"
  target     = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_route" "api_route_put_items" {
  depends_on = [aws_apigatewayv2_api.api]
  api_id     = aws_apigatewayv2_api.api.id
  route_key  = "PUT /items"
  target     = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_route" "api_route_delete_items_id" {
  depends_on = [aws_apigatewayv2_api.api]
  api_id     = aws_apigatewayv2_api.api.id
  route_key  = "DELETE /items/{id}"
  target     = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_integration" "integration" {
  depends_on             = [aws_apigatewayv2_api.api]
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.lambda.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

output "api" {
  value = aws_apigatewayv2_api.api.api_endpoint
}
