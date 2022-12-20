
#
# ECS
#

resource "aws_ecs_task_definition" "task_def" {

  family                   = var.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_mem
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode(
    [
      {
        "name" : var.name,
        "image" : "${var.ecr_repository_url}:${var.image_tag}",
        "command" : var.ecs_task_command,
        "cpu" : var.ecs_task_cpu,
        "memory" : var.ecs_task_mem,
        "essential" : true,
        "environment" : var.task_def_env_vars,
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : var.cloudwatch_log_group_name,
            "awslogs-region" : data.aws_region.current.name,
            "awslogs-stream-prefix" : "ecs"
          }
        }
      }
    ]
  )
  /*
   lifecycle {
    ignore_changes = [
      container_definitions
    ]
    */
}
