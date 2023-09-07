resource "aws_lambda_function" "lambda" {
  depends_on    = [aws_iam_role.lambda_role]
  function_name = "http-crud-tutorial-function"
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  s3_bucket     = aws_s3_bucket.bucket.bucket
  s3_key        = "apps/http-crud-tutorial-function/http-crud-tutorial-function.zip"
  tracing_config {
    mode = "Active"
  }
  tags = var.my_tags
}

resource "aws_lambda_permission" "allow_api_invoke_items" {
  depends_on    = [aws_apigatewayv2_stage.api_stage]
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.api.id}/*/*/items"
}

resource "aws_lambda_permission" "allow_api_invoke_items_id" {
  depends_on    = [aws_apigatewayv2_stage.api_stage]
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.api.id}/*/*/items/{id}"
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/lambda/http-crud-tutorial-function"
  retention_in_days = 3
}

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}
