resource "aws_cloudwatch_log_group" "httpd-app" {
  name = "httpd-app"
}

resource "aws_cloudwatch_log_stream" "httpd-app-stream" {
  log_group_name = aws_cloudwatch_log_group.httpd-app.name
  name = "stream/httpd"
}


#terraform import aws_cloudwatch_log_group.test_group test-logs