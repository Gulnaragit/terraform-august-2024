provider aws {
    region = "us-east-2"
}

resource "aws_key_pair" "keypair" {
  key_name   = "class3-key"
  public_key = file("~/.ssh/id_rsa.pub") 

  tags = local.common_tags
}

# Get AMI ID from aws console(basically pulling some data)
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create Instance 
resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  #availability_zone = "us-east-2b"
  subnet_id = "subnet-0ef7da68450baa779"
  key_name = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data = file("apache.sh") # relative path, if you are on a different folder that provide absolute/full path
  count = 3

tags = local.common_tags # Its local because in locals you can have many tags. 
}

# Tags can be used on each resource separately or use variable file local
#   tags = {
#     Name = "HelloWorld"
#     env = "dev"
#     team = "devops"
#     }

# Output publci IP of the intance in the terminal
output ec2 {
    value = aws_instance.web[0].public_ip # It will print publci IP of 1 instance
}

