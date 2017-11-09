resource "aws_instance" "master" {
  ami           = "${var.AMI_ID}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.public-01.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.example-instance.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"

  provisioner "remote-exec" {
     inline = [
     "sudo yum update -y",
     "sudo yum install -y docker",
     "sudo service docker start",
     "sudo docker swarm init",
     "sudo docker swarm join-token --quiet worker > /home/ec2-user/token",
     "sudo docker info",
     "cat /home/ec2-user/token"
   ]
 }
 provisioner "file" {
      source = "mykey.pem"
      destination = "/home/ec2-user/"
    }
    tags = {
      Name = "swarm-master"
    }
  provisioner "file" {
      source = "${var.PATH_TO_PRIVATE_KEY_FILE}"
      destination = "/home/ec2-user/"
    }
  connection {
    user = "ec2-user"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

}
# SLAVE Provisioning

resource "aws_instance" "slave" {
  ami           = "${var.AMI_ID}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.public-01.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.example-instance.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"

  provisioner "file" {
    source = "mykey"
    destination = "/home/ec2-user/"
  }
    tags = {
      Name = "swarm-worker"
    }

    provisioner "remote-exec" {
      inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo mv /home/ec2-user/ec2-user /home/ec2-user/ec2-user.pem",
      "sudo chmod 400 /home/ec2-user/ec2-user.pem",
      "sudo docker info",
      "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i ec2-user.pem ec2-user@${aws_instance.master.private_ip}:/home/ec2-user/token .",
      "sudo docker swarm join --token $(cat /home/ec2-user/token) ${aws_instance.master.private_ip}:2377"

    ]
  }
  provisioner "file" {
      source = "${var.PATH_TO_PRIVATE_KEY_FILE}"
      destination = "/home/ec2-user/"
    }
  connection {
    user = "ec2-user"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}
