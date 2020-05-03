data "template_file" "template" {
  template = file(var.open_api.template_file_path)

  vars = merge(var.open_api.vars, {
    dynamo_management_iam_role_arn : aws_iam_role.api_gateway_role.arn
  })
}

resource "aws_api_gateway_rest_api" "main" {
  name = var.application_name

  body = data.template_file.template.rendered
  tags = var.tags
}

resource "aws_api_gateway_deployment" "v1" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "v1"
}

resource "aws_iam_role" "api_gateway_role" {
  name               = "${var.application_name}-api-gateway-role"
  tags               = var.tags
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_dynamodb_table" "main" {
  name         = var.application_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = var.tags
}