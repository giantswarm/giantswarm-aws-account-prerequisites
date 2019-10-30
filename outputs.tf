output "aws-operator-role" {
  value = aws_iam_role.giantswarm-aws-operator.arn
}

output "giantswarm-admin-role" {
  value = aws_iam_role.giantswarm-staff.arn
}