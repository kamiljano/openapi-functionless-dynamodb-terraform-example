output "api_gateway_role_id" {
  value = aws_iam_role.api_gateway_role.id
}

output "dynamodb_arn" {
  value = aws_dynamodb_table.main.arn
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.v1.invoke_url
}