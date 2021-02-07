output "ecr_repository_url" {
  value = module.ecr_repository.repository_url
}

output "ecr_ci_access_key_id" {
  value = module.ecr_repository.ci_access_key_id
}

output "ecr_ci_access_secret_access_key" {
  value = module.ecr_repository.ci_secret_access_key
}