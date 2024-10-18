provider aws {
    region = var.region
}

variable region {
    type = string
    default = ""
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub") 
}

