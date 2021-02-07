output "repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}

output "ci_access_key_id" {
  value = aws_iam_access_key.ecr_ci_iam_user_credentials.id
}

output "ci_secret_access_key" {
  value = aws_iam_access_key.ecr_ci_iam_user_credentials.secret
}
