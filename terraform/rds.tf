resource "aws_rds_cluster" "east" {
  provider = aws.east
  engine = "aurora-postgresql"
  global_cluster_identifier = aws_rds_global_cluster.global_db.id
  master_username = "postgres"
  master_password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.east.name
}

resource "aws_rds_cluster_instance" "east_instance" {
  provider = aws.east
  identifier = "aurora-east-instance"
  cluster_identifier = aws_rds_cluster.east.id
  instance_class = "db.r6g.large"
  engine = "aurora-postgresql"
}

resource "aws_rds_cluster" "west" {
  provider = aws.west
  engine = "aurora-postgresql"
  global_cluster_identifier = aws_rds_global_cluster.global_db.id
  db_subnet_group_name = aws_db_subnet_group.west.name
}

resource "aws_rds_cluster_instance" "west_instance" {
  provider = aws.west
  identifier = "aurora-west-instance"
  cluster_identifier = aws_rds_cluster.west.id
  instance_class = "db.r6g.large"
  engine = "aurora-postgresql"
}