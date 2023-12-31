# -----------------------
# Route53
# -----------------------

# resource "aws_route53_zone" "route53_zone" {
#   name          = var.domain
#   force_destroy = false

#   tags = {
#     Name    = "${var.project}-${var.enviroment}-domain"
#     project = var.project
#     Env     = var.enviroment
#   }
# }

resource "aws_route53_record" "route53_record" {
  zone_id = var.hostZoneId
  name    = "dev-elb.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}