resource "aws_ecs_cluster" "east" {

  provider = aws.east

  name = "producer-east"
}


resource "aws_ecs_task_definition" "east" {

  provider = aws.east

  family = "producer-east"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu = 512

  memory = 1024

  container_definitions = jsonencode([{

    name = "producer"

    image = "${aws_ecr_repository.accumulator-ecr-east.repository_url}:latest"

    portMappings = [{

      containerPort = 3000
    }]
  }])
}


resource "aws_ecs_service" "east" {

  provider = aws.east

  cluster =
    aws_ecs_cluster.east.id

  task_definition =
    aws_ecs_task_definition.east.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.private_subnets_east
  }
}