output "user-access-key-id" {
  value = aws_iam_access_key.giantswarm-aws-capa-controller-user.id
}

output "user-access-key-secret" {
  value     = aws_iam_access_key.giantswarm-aws-capa-controller-user.secret
  sensitive = true
}
