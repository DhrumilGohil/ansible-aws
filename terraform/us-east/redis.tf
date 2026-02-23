resource "aws_elasticache_subnet_group" "east" {

  provider = aws.east

  subnet_ids = var.private_subnets_east
}


resource "aws_elasticache_replication_group" "east" {

  provider = aws.east

  replication_group_id = "redis-east"

  node_type = "cache.t3.micro"

  engine = "redis"

  num_cache_clusters = 2

  subnet_group_name =
    aws_elasticache_subnet_group.east.name
}