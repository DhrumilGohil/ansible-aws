resource "aws_msk_replicator" "global" {

  provider = aws.east

  replicator_name = "global-kafka"

  source_kafka_cluster_arn =
    aws_msk_cluster.east.arn

  target_kafka_cluster_arn =
    aws_msk_cluster.west.arn

  replication_info_list {

    source_kafka_cluster_arn =
      aws_msk_cluster.east.arn

    target_kafka_cluster_arn =
      aws_msk_cluster.west.arn

    topic_replication {

      topics_to_replicate = [".*"]
    }
  }
}