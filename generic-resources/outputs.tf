output "iam-policy-arn" {
  value = "${aws_iam_policy.giantswarm-aws-operator.arn}"
}

output "iam-staff-policy-arn" {
  value = "${aws_iam_policy.giantswarm-staff.arn}"
}
