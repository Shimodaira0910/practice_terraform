# -----------------------
# key pair
# -----------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.enviroment}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.enviroment}-keypair"
    project = var.project
    Env     = var.enviroment
  }
}

# -----------------------
# SSM Parameter Store
# -----------------------
resource "aws_ssm_parameter" "host" {
  name  = "/${var.project}/${var.enviroment}/app/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.mysql_standalone.address
}

resource "aws_ssm_parameter" "port" {
  name  = "/${var.project}/${var.enviroment}/app/MYSQL_PORT"
  type  = "String"
  value = aws_db_instance.mysql_standalone.port
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.project}/${var.enviroment}/app/MYSQL_DATABASE"
  type  = "String"
  value = aws_db_instance.mysql_standalone.db_name
}

resource "aws_ssm_parameter" "username" {
  name  = "/${var.project}/${var.enviroment}/app/MYSQL_USERNAME"
  type  = "SecureString"
  value = aws_db_instance.mysql_standalone.username
}

resource "aws_ssm_parameter" "password" {
  name  = "/${var.project}/${var.enviroment}/app/MYSQL_PASSWORD"
  type  = "SecureString"
  value = aws_db_instance.mysql_standalone.password
}

# -----------------------
# EC2 Instance
# -----------------------
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name

  vpc_security_group_ids = [
    aws_security_group.app-sg.id,
    aws_security_group.opmng_sg.id
  ]

  key_name = aws_key_pair.keypair.key_name
  tags = {
    Name    = "${var.project}-${var.enviroment}-app-ec2"
    project = var.project
    Env     = var.enviroment
    Type    = "app"
  }

}
