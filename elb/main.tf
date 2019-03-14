
# Creates a Load Balancer Target Group. It'll be attached into the Auto-scaling group. 
resource "aws_lb_target_group" "tf-elb-tg" {
  name     = "tf-elb-tg"
  port     = "${var.elb_port}"
  protocol = "${var.elb_protocol}"
  vpc_id   = "${var.elb_vpc_id}"
}
# Creates an Application Load Balancer 
resource "aws_lb" "tf-elb" {
  name               = "tf-elb"
  internal           = "${var.elb_scheme_internal}"
  load_balancer_type = "${var.elb_type}"
  security_groups    = ["${var.elb_sg}"]
  subnets            = ["${var.elb_sn}"]
}
# Creates the listener/s to use by the ELB
resource "aws_lb_listener" "tf-listener" {
  load_balancer_arn = "${aws_lb.tf-elb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tf-elb-tg.arn}"
  }
}