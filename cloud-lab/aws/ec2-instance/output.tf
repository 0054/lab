
# output "region" {
#   value = data.aws_region.current_region.name
# }

# # output "ami" {
# #   value = data.aws_ami.ubuntu.id
# # }

# output "vpc" {
#   value = data.aws_vpc.default.id
# }

# output "subnets" {
#   value = data.aws_subnet_ids.all.ids
# }
#
output "instance" {
  value = aws_instance.docker.*.public_ip
}
