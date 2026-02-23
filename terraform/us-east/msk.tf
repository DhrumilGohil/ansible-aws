resource "aws_security_group" "kafka_east" {

  provider = aws.east

  vpc_id = var.vpc_id_east

  ingress {

    from_port = 9092

    to_port = 9092

    protocol = "tcp"

    cidr_blocks = ["10.0.0.0/8"]
  }
}


resource "aws_msk_cluster" "east" {

  provider = aws.east

  cluster_name = "kafka-east"

  kafka_version = "3.5.1"

  number_of_broker_nodes = 3

  broker_node_group_info {

    instance_type = "kafka.m5.large"

    client_subnets = var.private_subnets_east

    security_groups = [
      aws_security_group.kafka_east.id
    ]
  }
}