resource "aws_security_group" "kafka_west" {

  provider = aws.west

  vpc_id = var.vpc_id_west

  ingress {

    from_port = 9092

    to_port = 9092

    protocol = "tcp"

    cidr_blocks = ["10.0.0.0/8"]
  }
}


resource "aws_msk_cluster" "west" {

  provider = aws.west

  cluster_name = "kafka-west"

  kafka_version = "3.5.1"

  number_of_broker_nodes = 3

  broker_node_group_info {

    instance_type = "kafka.m5.large"

    client_subnets = var.private_subnets_west

    security_groups = [
      aws_security_group.kafka_west.id
    ]
  }
}