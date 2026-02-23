resource "aws_rds_global_cluster" "global_db" {
  global_cluster_identifier = "global-postgres"
  engine = "aurora-postgresql"
  engine_version = "15.4"
}