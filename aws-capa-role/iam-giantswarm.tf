locals {
  controller_role_name   = "GiantSwarmAWSCapaController"
  node_role_name         = "GiantSwarmAWSCapaNode"
  controlplane_role_name = "GiantSwarmAWSCapaControlPlane"
}

resource "aws_iam_policy" "giantswarm-aws-capa-controller" {
  name = local.controller_role_name
  policy = templatefile("${path.module}/iam-controller-policy.json", {
    account_id = "${var.target_account_id}"
    arn_prefix = "${var.arn_prefix}"
  })
}

resource "aws_iam_controller_role" "giantswarm-aws-capa-controller" {
  name               = local.controller_role_name
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-capa-controller.json
}

resource "aws_iam_role_policy_attachment" "giantswarm-aws-capa-controller" {
  role       = aws_iam_role.giantswarm-aws-operator.name
  policy_arn = aws_iam_policy.giantswarm-aws-operator.arn
}

data "aws_iam_policy_document" "giantswarm-aws-capa-controller" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${var.arn_prefix}:iam::${var.main_account_id}:user/${var.operator_user_name}"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "giantswarm-aws-capa-controlplane" {
  name = local.controlplane_role_name
  policy = templatefile("${path.module}/iam-controlplane-policy.json", {
    account_id = "${var.target_account_id}"
    arn_prefix = "${var.arn_prefix}"
  })
}

resource "aws_iam_role" "giantswarm-aws-capa-controlplane" {
  name               = local.controlplane_role_name
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-capa-controlplane.json
}

resource "aws_iam_policy" "giantswarm-aws-capa-node" {
  name = local.node_role_name
  policy = templatefile("${path.module}/iam-node-policy.json", {
    account_id = "${var.target_account_id}"
    arn_prefix = "${var.arn_prefix}"
  })
}

resource "aws_iam_role" "giantswarm-aws-capa-node" {
  name               = local.node_role_name
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-capa-node.json
}
