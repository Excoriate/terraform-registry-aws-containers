resource "aws_ecs_cluster" "this" {
  for_each = local.ecs_cluster_to_create
  name     = each.value["name"]

  setting {
    name  = "containerInsights"
    value = each.value["container_insights"]
  }

  tags = var.tags
}


resource "aws_ecs_cluster_capacity_providers" "example" {
  for_each     = local.ecs_capacity_providers_to_create
  cluster_name = each.value["cluster_name"]

  capacity_providers = each.value["capacity_providers"]

  dynamic "default_capacity_provider_strategy" {
    for_each = local.ecs_capacity_providers_to_create[each.key]["default_capacity_provider_strategy"]
    iterator = cp
    content {
      capacity_provider = cp.value["capacity_provider"]
      weight            = cp.value["weight"]
      base              = cp.value["base"]
    }
  }

  depends_on = [aws_ecs_cluster.this]
}
