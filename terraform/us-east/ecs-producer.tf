resource "aws_ecs_cluster" "west" {

  provider = aws.west

  name = "producer-west"
}


resource "aws_ecs_task_definition" "west" {

  provider = aws.west

  family = "producer-west"

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu = 512

  memory = 1024

  container_definitions = jsonencode([{

    name = "producer"

    image = "${aws_ecr_repository.accumulator-ecr-west.repository_url}:latest"

    portMappings = [{

      containerPort = 3000
    }]
  }])
}


resource "aws_ecs_service" "west" {

  provider = aws.west

  cluster =
    aws_ecs_cluster.west.id

  task_definition =
    aws_ecs_task_definition.west.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.private_subnets_west
  }
}