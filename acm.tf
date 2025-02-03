resource "aws_acm_certificate" "simple-webserver" {
  domain_name       = "torstens-domain.com"
  validation_method = "DNS"

  tags = {
    Name = "simple-webserver-torsten"
    owner = "torsten"

  }
}

resource "aws_route53_zone" "simple_webserver" {
  name = "torstens-domain.com"

  tags = {
    Name  = "torstens-domain.com"
    owner = "torsten"
  }
}

# data "aws_route53_zone" "simple-webserver" {
#   name = "torstens-domain.com"
# }

resource "aws_route53_record" "simple-webserver" {
  for_each = {
    for dvo in aws_acm_certificate.simple-webserver.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = aws_route53_zone.simple_webserver.zone_id
  records = [each.value.value]
  ttl     = 60
}