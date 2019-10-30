output "aws-operator-role" {
  value = aws_iam_role.giantswarm-aws-operator.arn
}

output "giatswarm-admin-role" {
  value = aws_iam_role.giantswarm-staff.arn
}