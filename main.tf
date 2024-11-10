# Terraformのバージョン指定
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

# AWSプロバイダーの設定
provider "aws" {
  region = "ap-northeast-1" # 東京リージョン
}

# セキュリティグループの作成
resource "aws_security_group" "example_sg" {
  name_prefix = "example-sg-"

  # SSHの許可（ポート22）
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 全てのアウトバウンドトラフィックを許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2インスタンスの作成
resource "aws_instance" "example" {
  ami           = "ami-0b6fe957a0eb4c1b9" # Amazon Linux 2のAMI ID（東京リージョン用）
  instance_type = "t2.micro"

  # セキュリティグループをアタッチ
  security_groups = [aws_security_group.example_sg.name]

  tags = {
    Name = "ExampleInstance"
  }
}

