provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
  version = "~> 2.59"
}

module "functionless" {
  source = "./modules"

  application_name = var.application_name
  open_api = {
    template_file_path = "${path.module}/files/posts.yaml"
    vars = {
      aws_region = var.aws_region //TODO: do all the replacements inside the module
      new_post_request_mapping = replace(replace(file("${path.module}/files/new_post_request_mapping.json"), "<table-name>", var.application_name), "\"", "\\\"")
      new_post_response_mapping = replace(file("${path.module}/files/new_post_response_mapping.json"), "\"", "\\\"")
      list_posts_request_mapping = replace(replace(file("${path.module}/files/list_posts_request_mapping.json"), "<table-name>", var.application_name), "\"", "\\\"")
      list_posts_response_mapping = replace(file("${path.module}/files/list_posts_response_mapping.json"), "\"", "\\\"")
    }
  }
}

resource "aws_iam_role_policy" "api_gateway_policy" {
  name = "${var.application_name}-api-gateway-policy"
  role = module.functionless.api_gateway_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDbPermissionsForApiGateway"
        Effect = "Allow"
        Action = [
          "dynamodb:Scan",
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ]
        Resource = module.functionless.dynamodb_arn
      }
    ]
  })
}