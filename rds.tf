resource "aws_db_subnet_group" "GEMS_Tenant_DB_SG" {
    name       = "${var.gems_tag}_db_sg"
    subnet_ids = ["${aws_subnet.az1_pub.id}", "${aws_subnet.az2_pub.id}"]

    tags = {
        Name = "${var.gems_tag}_db"
    }
}

resource "aws_db_instance" "GEMS-Tenant-DB" {
    identifier             = "${var.gems_tag}-db"
    allocated_storage      = 20
    storage_type           = "gp2"
    engine                 = "postgres"
    engine_version         = "10.6"
    instance_class         = "db.${var.db_size}"
    db_subnet_group_name   = "${aws_db_subnet_group.GEMS_Tenant_DB_SG.id}"
    name                   = "kong"
    username               = "${var.database_admin_username}"
    password               = "${var.database_admin_password}"
    parameter_group_name   = "default.postgres10"
    publicly_accessible    = true
    vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_DB.id}"]
    port                   = 5432
    skip_final_snapshot    = true
}