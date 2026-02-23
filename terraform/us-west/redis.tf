resource "aws_elasticache_subnet_group" "west" {

  provider = aws.west

  subnet_ids = var.private_subnets_west
}


resource "aws_elasticache_replication_group" "west" {

  provider = aws.west

  replication_group_id = "redis-west"

  node_type = "cache.t3.micro"

  engine = "redis"

  num_cache_clusters = 2

  subnet_group_name =
    aws_elasticache_subnet_group.west.name
}