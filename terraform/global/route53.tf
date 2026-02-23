resource "aws_route53_record" "east" {

  provider = aws.east

  zone_id = var.zone_id

  name = var.domain_name

  type = "A"

  set_identifier = "us-east"

  latency_routing_policy {

    region = "us-east-1"
  }

  alias {

    name = aws_lb.east.dns_name

    zone_id = aws_lb.east.zone_id

    evaluate_target_health = true
  }
}


resource "aws_route53_record" "west" {

  provider = aws.east

  zone_id = var.zone_id

  name = var.domain_name

  type = "A"

  set_identifier = "us-west"

  latency_routing_policy {

    region = "us-west-2"
  }

  alias {

    name = aws_lb.west.dns_name

    zone_id = aws_lb.west.zone_id

    evaluate_target_health = true
  }
}