resource "aws_cloudwatch_event_rule" "start" {
  name        = "${var.project_tag}-serverless-rds-ssh-traffic"
  description = "Event gets triggered when SSH traffic metric changes into alarm state"

  event_pattern = jsonencode({
    detail-type = ["CloudWatch Alarm State Change"]
    source      = ["aws.cloudwatch"]
    resources   = [var.ssh_metric_alarm_arn]
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
    Description = "Event for state change of SSH traffic metric alarm"
  }
}

resource "aws_cloudwatch_event_target" "start" {
  rule      = aws_cloudwatch_event_rule.start.name
  target_id = "${var.project_tag}-serverless-rds-start-database"
  arn       = var.start_lambda_arn
}

resource "aws_lambda_permission" "start" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.start_lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start.arn
}

resource "aws_cloudwatch_event_rule" "stop" {
  name                = "${var.project_tag}-serverless-rds-scheduled-stop"
  description         = "Scheduled event triggers every 30 minutes"
  schedule_expression = "rate(30 minutes)"

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Scheduled event for Lambda to check RDS traffic state and possibly stop RDS instance"
  }
}

resource "aws_cloudwatch_event_target" "stop" {
  rule      = aws_cloudwatch_event_rule.stop.name
  target_id = "${var.project_tag}-serverless-rds-stop-database"
  arn       = var.stop_lambda_arn
}

resource "aws_lambda_permission" "stop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.stop_lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop.arn
}
