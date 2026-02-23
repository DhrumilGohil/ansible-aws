resource "aws_apigatewayv2_api" "east" {

  provider = aws.east

  name = "api-east"

  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_vpc_link" "east" {

  provider = aws.east

  name = "east-link"

  subnet_ids = var.private_subnets_east
}


resource "aws_apigatewayv2_integration" "east" {

  provider = aws.east

  api_id = aws_apigatewayv2_api.east.id

  integration_type = "HTTP_PROXY"

  integration_uri = aws_lb.east.arn

  integration_method = "ANY"

  connection_type = "VPC_LINK"

  connection_id =
    aws_apigatewayv2_vpc_link.east.id
}


resource "aws_apigatewayv2_route" "post_east" {

  provider = aws.east

  api_id = aws_apigatewayv2_api.east.id

  route_key = "POST /{proxy+}"

  target =
    "integrations/${aws_apigatewayv2_integration.east.id}"
}


resource "aws_apigatewayv2_route" "put_east" {

  provider = aws.east

  api_id = aws_apigatewayv2_api.east.id

  route_key = "PUT /{proxy+}"

  target =
    "integrations/${aws_apigatewayv2_integration.east.id}"
}


resource "aws_apigatewayv2_stage" "east" {

  provider = aws.east

  api_id = aws_apigatewayv2_api.east.id

  name = "prod"

  auto_deploy = true
}