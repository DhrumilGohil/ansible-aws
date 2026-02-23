resource "aws_elasticache_replication_group" "east" {
  provider = aws.east
  replication_group_id = "redis-east"
  engine = "redis"
  node_type = "cache.r6g.large"
  num_cache_clusters = 2
  automatic_failover_enabled = true
}

resource "aws_elasticache_global_replication_group" "west" {
  provider = aws.west
  global_replication_group_id_suffix = "failover-redis"
  primary_replication_group_id = aws_elasticache_replication_group.east.id
}