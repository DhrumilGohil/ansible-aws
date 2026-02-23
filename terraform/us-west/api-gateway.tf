resource "aws_apigatewayv2_api" "west" {
  provider      = aws.west
  name          = "api-west"
  protocol_type = "HTTP"
}