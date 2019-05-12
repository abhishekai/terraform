output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
output "public_subnet_ids" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "vpc_security_group_ids" {
  value = "${aws_default_security_group.AI_SGW.id}"
}