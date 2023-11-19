# gets triggered on each apply
resource "null_resource" "always_run" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

resource "aws_lambda_function" "main" {
  function_name = var.function_name
  package_type  = "Image"
  role          = var.role_arn
  image_uri     = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_image_tag}"

  environment {
    variables = var.env_variables
  }

  # always recreates the function so it pulls the latest image
  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = var.description
  }
}
