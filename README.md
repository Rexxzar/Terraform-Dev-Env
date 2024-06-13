# Terraform-Dev-Env
Simple Dev-Env using Terraform, with a dynamic code.
the ENV includes A a VPC with the CIDR block 10.0.0.0/24 and inside it a subnet with with the CIDR block 10.0.0.0/25.
inside the subnet there is an EC2 instance, the user can set the EC2 type and the AMI to be used for the creation of the EC2 Instance.
There is also a key pair set for SSH access to the instance, along with a security group set that  limits access to the user's public IP only.
It also includes an Internet Gateway along with a route table associated with it.
the EC2 instance will launch with a user data template that installs Docker on an Ubuntu machine, you can change that to whatever you like.
