output "user-access-key-id" {
  value = "${aws_iam_access_key.giantswarm-aws-operator-user.id}"
}

output "user-access-key-secret" {
  value     = "${aws_iam_access_key.giantswarm-aws-operator-user.secret}"
  sensitive = true
}
