resource "aws_iam_policy" "lambda_policy" {
  name   = "http-crud-tutorial-function-policy"
  policy = file("${path.module}/iam/policies/http-crud-tutorial-function-policy.json")
  tags = var.my_tags
}

resource "aws_iam_role" "lambda_role" {
  depends_on = [aws_iam_policy.lambda_policy]
  name = "http-crud-tutorial-role"
  assume_role_policy = file("${path.module}/iam/roles/trust-lambda.json")
  managed_policy_arns = [
    aws_iam_policy.lambda_policy.arn
  ]
  tags = var.my_tags
}
