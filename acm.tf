
data "aws_route53_zone" "tlservers" {
  name = "tlservers.net"
}

# Create the subdomain record pointing to the ALB
resource "aws_route53_record" "simple-webserver" {
  zone_id = data.aws_route53_zone.tlservers.zone_id
  name    = "simple-webserver.tlservers.net"
  type    = "A"

  alias {
    name                  = aws_lb.simple_webserver_lb.dns_name
    zone_id               = aws_lb.simple_webserver_lb.zone_id
    evaluate_target_health = true
  }
}

#  Certificate

# Create DNS validation record
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.simple-webserver.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.tlservers.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "simple-webserver" {
  certificate_arn         = aws_acm_certificate.simple-webserver.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_acm_certificate" "simple-webserver" {
  domain_name       = "simple-webserver.tlservers.net"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    name = "simple-webserver-certificate"
    owner = "torsten"
  }
}

resource "aws_lb_listener_rule" "simple-webserver-https" {
  listener_arn = aws_lb_listener.simple_webserver_https_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.simple_webserver_target_group.arn
  }

  condition {
    host_header {
      values = ["simple-webserver.tlservers.net"]
    }
  }
  
  tags = {
    owner = "torsten"
  }
}