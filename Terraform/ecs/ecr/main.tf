module "ecr" {
  source                          = "terraform-aws-modules/ecr/aws"
  version                         = "1.6.0"
  repository_name                 = local.ecr_config.repository_name
  repository_image_tag_mutability = try(local.ecr_config.repository_image_tag_mutability, "MUTABLE")
  repository_image_scan_on_push   = true
  attach_repository_policy        = false
  create_repository_policy        = false
  create_lifecycle_policy         = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 backend images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = try(local.ecr_config.tags, {})
}
