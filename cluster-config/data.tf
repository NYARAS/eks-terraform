data "aws_route53_zone" "eks" {
  name = var.dns_zone
}
