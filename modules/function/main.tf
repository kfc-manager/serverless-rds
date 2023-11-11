data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "modify_rds_state" {
  statement {
    actions = [var.stop ? "rds:StopDBInstance" : "rds:StartDBInstance", "rds:DescribeDBInstances"]

    resources = ["arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:${lower(var.rds_identifier)}"]
  }
}

resource "aws_iam_role" "main" {
  name               = "lambda-rds-${var.stop ? "stop" : "start"}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name   = "modify_rds_state_policy"
    policy = data.aws_iam_policy_document.modify_rds_state.json
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "IAM Role to allow Lambda Function to ${var.stop ? "stop" : "start"} the RDS Instance"
  }
}

# gets triggered on each apply
resource "null_resource" "always_run" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

resource "aws_lambda_function" "main" {
  function_name = var.function_name
  package_type  = "Image"
  role          = aws_iam_role.main.arn
  image_uri     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_image_tag}"

  environment {
    variables = {
      RDS_IDENTIFIER = var.rds_identifier
      REGION         = var.region
    }
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
    Description = "Lambda Function to ${var.stop ? "stop" : "start"} the RDS Instance"
  }
}
