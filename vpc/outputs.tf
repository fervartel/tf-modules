output "vpc_id" {
    value = "${aws_vpc.tf-vpc.id}"
}
output "subnets_pri" {
    value = "${aws_subnet.tf-subnet-pri.*.id}"
}
output "subnets_pub" {
    value = "${aws_subnet.tf-subnet-pub.*.id}"
}
