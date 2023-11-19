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

data "aws_iam_policy_document" "start_rds" {
  statement {
    actions = ["rds:StartDBInstance", "rds:DescribeDBInstances"]

    resources = [var.rds_arn]
  }
}

data "aws_iam_policy_document" "stop_rds" {
  statement {
    actions = ["rds:StopDBInstance", "rds:DescribeDBInstances"]

    resources = [var.rds_arn]
  }
}

data "aws_iam_policy_document" "check_alarm_state" {
  statement {
    actions = ["cloudwatch:DescribeAlarms"]

    resources = ["*"]
  }
}

resource "aws_iam_role" "stop" {
  name               = "${var.project_tag}-serverless-rds-stop-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name   = "stop-rds-instance"
    policy = data.aws_iam_policy_document.stop_rds.json
  }

  inline_policy {
    name   = "check-metric-alarm"
    policy = data.aws_iam_policy_document.check_alarm_state.json
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "IAM role to allow Lambda function to check metric alarm state and stop RDS instance"
  }
}

resource "aws_iam_role" "start" {
  name               = "${var.project_tag}-serverless-rds-start-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name   = "start-rds-instance"
    policy = data.aws_iam_policy_document.start_rds.json
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "IAM role to allow Lambda function to start RDS instance"
  }
}
