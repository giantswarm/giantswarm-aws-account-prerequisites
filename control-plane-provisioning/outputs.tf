output "user-access-key-id" {
  value = "${aws_iam_access_key.giantswarm-provisioner-user.id}"
}

output "user-access-key-secret" {
  value = "${aws_iam_access_key.giantswarm-provisioner-user.secret}"
}
