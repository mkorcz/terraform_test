resource "aws_cloudwatch_log_group" "test-logs" {
  name = "test-logs"
}

resource "aws_cloudwatch_log_stream" "test-log-stream" {
  log_group_name = aws_cloudwatch_log_group.test-logs.name
  name = "test-log-stream"
}


#terraform import aws_cloudwatch_log_group.test_group test-logs - niby importuje cl