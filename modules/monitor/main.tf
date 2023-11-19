locals {
  rds_metric_alarm_name = "${var.project_tag}-serverless-rds-no-database-traffic"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.project_tag}-serverless-rds-traffic"
  retention_in_days = 1

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Log group to log traffic in network"
  }
}

data "aws_iam_policy_document" "traffic_log" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["${aws_cloudwatch_log_group.main.arn}:*"]
  }
}

resource "aws_iam_role" "main" {
  name               = "${var.project_tag}-serverless-rds-traffic-log"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name   = "cloudwatch-log-group-access"
    policy = data.aws_iam_policy_document.traffic_log.json
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "IAM role to allow flow log to alter CloudWatch log group"
  }
}

resource "aws_flow_log" "main" {
  eni_id                   = var.network_interface_id
  traffic_type             = "ACCEPT"
  iam_role_arn             = aws_iam_role.main.arn
  log_destination          = aws_cloudwatch_log_group.main.arn
  max_aggregation_interval = 60
}

resource "aws_cloudwatch_log_metric_filter" "database" {
  name           = "RDSTraffic"
  pattern        = var.db_port
  log_group_name = aws_cloudwatch_log_group.main.name

  metric_transformation {
    name          = "RDSTraffic"
    namespace     = "ServerlessRDSMetric"
    value         = "1"
    default_value = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "database" {
  alarm_name          = local.rds_metric_alarm_name
  alarm_description   = "This metric monitors if there is traffic to RDS instance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 1500
  metric_name         = aws_cloudwatch_log_metric_filter.database.name
  namespace           = "ServerlessRDSMetric"
  statistic           = "Sum"
  threshold           = 1

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Alarm for RDSTraffic metric filter"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ssh" {
  name           = "SSHTraffic"
  pattern        = 22
  log_group_name = aws_cloudwatch_log_group.main.name

  metric_transformation {
    name          = "SSHTraffic"
    namespace     = "ServerlessRDSMetric"
    value         = "1"
    default_value = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "ssh" {
  alarm_name          = "${var.project_tag}-serverless-rds-ssh-traffic"
  alarm_description   = "This metric monitors if there is SSH traffic to bastion host"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 60
  metric_name         = aws_cloudwatch_log_metric_filter.ssh.name
  namespace           = "ServerlessRDSMetric"
  statistic           = "Sum"
  threshold           = 0

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Alarm for SSHTraffic metric filter"
  }
}
