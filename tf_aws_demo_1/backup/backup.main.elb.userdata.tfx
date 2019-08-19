data "aws_availability_zones" "all" {}

provider "aws" {

  region = "us-east-2"
  shared_credentials_file = ".aws/credentials"
}

resource "aws_key_pair" "tf_aws_demo_1" {

  key_name   = "tf_aws_demo_1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2bmr+Y+fDbDJ5oV7hZDG3wUM0ftpbNSvz5BlBNJYUy8LF5wiUDdlG1Ht/zk5A0CoFHB6lXOsOUrlApsHA4/lseKq9Xs8z2Vv4XIYhfn2FUUxIXnXqmQBUqHo3PHaDFJ0GJnhHu4yPFVFRrGnnlzGdneChcHpuxky7AD8lFYc4zELQdmKYTToB+rbgrCgcZEZQ8/HcLD95G6Y5U59zQVzPuBXY4QMdO4KP3Pwtg9b1jS5RYxTvb1OfoYW/JDcnNnGpEn9+CnVeZHjCob2WNHGw/3XNZTrGhTN/8iABP6lJYWSJHx0U2pIiRp63lfQXT+ZSWlHu/+d7Rchp0NmyJRlb tf_aws_demo_1_ssh_key"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_configuration" "tf_aws_demo_1" {

  #ami = "ami-af122bca"
  image_id = "ami-af122bca"
  instance_type = "t2.micro"
  #vpc_security_group_ids = ["${aws_security_group.tf_aws_demo_1.id}"]
  security_groups = ["${aws_security_group.tf_aws_demo_1.id}"]
  key_name = "tf_aws_demo_1"
  #tags {
  #  Name = "tf_aws_demo_1"
  #}

  user_data = <<-EOF
              #!/bin/bash
              echo $(hostname) > /home/ubuntu/index.html
              nohup busybox httpd -f -h /home/ubuntu -p 8080 > /home/ubuntu/nohup.out 2> /home/ubuntu/nohup.err &
              netstat -an | grep 8080 >> /home/ubuntu/nohup.out 
              ps -ef | grep http >> /home/ubuntu/nohup.out
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "tf_aws_demo_1" {

  name = "tf_aws_demo_1"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "tf_aws_demo_1" {

  availability_zones = ["${data.aws_availability_zones.all.names}"]
  launch_configuration = "${aws_launch_configuration.tf_aws_demo_1.id}"

  min_size = 2
  max_size = 10

  load_balancers = ["${aws_elb.tf_aws_demo_1.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "tf_aws_demo_1"
    propagate_at_launch = true
  }
}

resource "aws_elb" "tf_aws_demo_1" {

  name = "tfawsdemo1"
  security_groups = ["${aws_security_group.tf_aws_demo_1.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  listener {
    lb_port = 8080
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
}

output "public_dns" {
  value = "${aws_elb.tf_aws_demo_1.dns_name}:8080"
}
