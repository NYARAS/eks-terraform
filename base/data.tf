# get all available AZs in our region
data "aws_availability_zones" "available_azs" {
  state = "available"
}
