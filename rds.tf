resource "aws_db_instance" "GEMS-Tenant-DB" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "10.6"
  instance_class         = "db.t2.micro"
  name                   = "kong"
  username               = "postgres"
  password               = "Pass1234"
  parameter_group_name   = "default.postgres10"
  publicly_accessible    = true
  vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_DB.id}"]
  port                   = 5432
}