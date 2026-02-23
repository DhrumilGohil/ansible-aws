resource "aws_ecr_repository" "accumulator-ecr-east" {

  provider = aws.east
  name = "accumulator"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "accumulator-ecr-west" {

  provider = aws.west
  name = "accumulator"
  image_scanning_configuration {
    scan_on_push = true
  }
}