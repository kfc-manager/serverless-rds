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

data "aws_iam_policy_document" "ssh_log" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "${lower(var.project)}-serverless-rds-traffic"
  retention_in_days = 1

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "CloudWatch Log Group to log Traffic of the Bastion Host"
  }
}

resource "aws_iam_role" "main" {
  name               = "${lower(var.project)}-serverless-rds-log"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name   = "cloudwatch-access"
    policy = data.aws_iam_policy_document.ssh_log.json
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "IAM Role to allow Flow Log to push logs to CloudWatch"
  }
}

resource "aws_flow_log" "main" {
  eni_id                   = var.bastion_host_network_interface_id
  traffic_type             = "ACCEPT"
  iam_role_arn             = aws_iam_role.main.arn
  log_destination          = aws_cloudwatch_log_group.main.arn
  max_aggregation_interval = 60
}

resource "aws_cloudwatch_log_metric_filter" "main" {
  name           = "RDSTraffic"
  pattern        = var.port
  log_group_name = aws_cloudwatch_log_group.main.name

  metric_transformation {
    name          = "RDSTraffic"
    namespace     = "RDSMetric"
    value         = "1"
    default_value = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "main" {
  alarm_name          = "no-rds-traffic"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = var.trigger_period * 60
  metric_name         = aws_cloudwatch_log_metric_filter.main.name
  namespace           = "RDSMetric"
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This metric monitors if there is traffic to the RDS instance"

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Alarm for RDSTraffic metric filter"
  }
}

resource "aws_cloudwatch_event_rule" "main" {
  name        = "no-rds-traffic"
  description = "Event gets triggered when there is no traffic to the RDS instance"

  event_pattern = jsonencode({
    detail-type = ["CloudWatch Alarm State Change"]
    source      = ["aws.cloudwatch"]
    resources   = [aws_cloudwatch_metric_alarm.main.arn]
    detail = {
      state = {
        value = ["ALARM"]
      }
    }
  })

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Event that triggers the Lambda Stop Function when the Alarm state changes"
  }
}

resource "aws_cloudwatch_event_target" "main" {
  rule      = aws_cloudwatch_event_rule.main.name
  target_id = "${lower(var.project)}-serverless-rds-stop"
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "main" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.main.arn
}
