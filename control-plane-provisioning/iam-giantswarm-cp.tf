### Control Plane Automation User ###
resource "aws_iam_user" "giantswarm-provisioner" {
  name = "GiantSwarmProvisioner"
}

resource "aws_iam_policy" "giantswarm-policy" {
  name   = "GiantSwarmProvisionerPolicy"
  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_user_policy_attachment" "giantswarm-provisioner-user" {
  user       = aws_iam_user.giantswarm-provisioner.name
  policy_arn = aws_iam_policy.giantswarm-policy.arn
}

resource "aws_iam_access_key" "giantswarm-provisioner-user" {
  user    = aws_iam_user.giantswarm-provisioner.name
}
### END Control Plane Automation User ###
