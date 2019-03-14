# Creates the Launch Template that will be used by the ASG to get the instance's details
resource "aws_launch_template" "tf-launch-template" {
  name_prefix     = "tf-lt-"
  image_id        = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${var.instance_type}"
  key_name 	      = "${var.ssh_key}"
  vpc_security_group_ids = ["${var.security_groups}"]

  tags = {
      Name = "tf-launch-template"
    }
}
# Creates the Auto-Scaling group
resource "aws_autoscaling_group" "tf-asg" {
  name                  = "tf-asg"
  desired_capacity      = 2
  min_size              = 2
  max_size              = 4
  vpc_zone_identifier   = ["${var.subnets[0]}", "${var.subnets[1]}"]
  target_group_arns     = ["${var.asg_lb_target_group}"]

  launch_template {
    id      = "${aws_launch_template.tf-launch-template.id}"
    version = "$$Latest"
  }
  lifecycle {
    create_before_destroy = true
  }
}
# Creates the policy to Scale-out / Scale-in. It looks for an average CPU of 40% across the board
resource "aws_autoscaling_policy" "tf-asg-policy" {
  name                    = "tf-asg-policy"
  autoscaling_group_name  = "${aws_autoscaling_group.tf-asg.name}"
  policy_type             = "TargetTrackingScaling"  
  
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}