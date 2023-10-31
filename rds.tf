data "aws_secretsmanager_secret" "password" {
  name = "test-db-password"

 depends_on = [aws_secretsmanager_secret.password]
}

data "aws_secretsmanager_secret_version" "password" {
  secret_id = data.aws_secretsmanager_secret.password.id
}

# output "sensitive_example_hash" {
#   value = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.password.secret_string))
# }


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = data.aws_secretsmanager_secret_version.password.secret_string
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

