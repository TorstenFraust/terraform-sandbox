# resource "aws_apigatewayv2_api" "simple_webserver_api" {
#   name          = "simple_webserver_api"
#   protocol_type = "HTTP"
# }

# resource "aws_apigatewayv2_stage" "default" {
#   api_id      = aws_apigatewayv2_api.simple_webserver_api.id
#   name        = "$default"
#   auto_deploy = true
# }

# resource "aws_apigatewayv2_authorizer" "auth0" {
#   api_id = aws_apigatewayv2_api.simple_webserver_api.id
#   authorizer_type = "JWT"
#   identity_sources = ["$request.header.Authorization"]
#   jwt_configuration {
#     audience = ["https://simple-webserver-torsten/"]
#     issuer   = "https://tourlane-staging.eu.auth0.com/"
#   }
#   name = "auth0"
# }

# resource "aws_apigatewayv2_domain_name" "custom_domain" {
#   domain_name = "torstens-domain.com"
#   domain_name_configuration {
#     certificate_arn = aws_acm_certificate.simple-webserver.arn
#     endpoint_type   = "REGIONAL"
#     security_policy = "TLS_1_2" 
#   }
# }

# resource "aws_apigatewayv2_api_mapping" "custom_mapping" {
#   api_id      = aws_apigatewayv2_api.simple_webserver_api.id
#   domain_name = aws_apigatewayv2_domain_name.custom_domain.domain_name
#   stage       = aws_apigatewayv2_stage.default.id
# }

# resource "aws_apigatewayv2_vpc_link" "simple_webserver_vpc_link" {
#   name = "simple_webserver_vpc_link"
#   subnet_ids = module.simple_webserver_vpc.public_subnets
#   security_group_ids = [aws_security_group.simple_webserver_lb_security_group.id]
# }

# resource "aws_apigatewayv2_integration" "alb_integration" {
#   api_id = aws_apigatewayv2_api.simple_webserver_api.id
#   integration_type = "HTTP_PROXY"
#   integration_uri = aws_lb_listener.simple_webserver_aws_lb_listener.arn
#   connection_type = "VPC_LINK"
#   connection_id = aws_apigatewayv2_vpc_link.simple_webserver_vpc_link.id
# integration_method = "ANY"

# }

# resource "aws_apigatewayv2_route" "simple_webserver_api_route" {
#   api_id = aws_apigatewayv2_api.simple_webserver_api.id
#   route_key = "ANY /{proxy+}"
#   target = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
#   authorizer_id = aws_apigatewayv2_authorizer.auth0.id
# }