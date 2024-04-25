resource "aws_iam_role" "giantswarm-capa-controller-role" {
  name               = "giantswarm-${var.installation_name}-capa-controller"
  assume_role_policy = data.aws_iam_policy_document.giantswarm-capa-controller.json
}

data "aws_iam_policy_document" "giantswarm-capa-controller" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principal_arns_giantswarm_root_account
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "giantswarm-capa-controller-policy" {
  name   = "giantswarm-${var.installation_name}-capa-controller-policy"
  policy = file("${path.module}/capa-controller-policy.json")
}
resource "aws_iam_role_policy_attachment" "giantswarm-capa-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-capa-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-dns-controller-policy" {
  name   = "giantswarm-${var.installation_name}-dns-controller-policy"
  policy = file("${path.module}/dns-controller-policy.json")
}
resource "aws_iam_role_policy_attachment" "giantswarm-dns-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-dns-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-eks-controller-policy" {
  name   = "giantswarm-${var.installation_name}-eks-controller-policy"
  policy = file("${path.module}/eks-controller-policy.json")
}
resource "aws_iam_role_policy_attachment" "giantswarm-eks-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-eks-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-iam-controller-policy" {
  name   = "giantswarm-${var.installation_name}-iam-controller-policy"
  policy = file("${path.module}/iam-controller-policy.json")
}
resource "aws_iam_role_policy_attachment" "giantswarm-iam-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-iam-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-irsa-controller-policy" {
  name   = "giantswarm-${var.installation_name}-irsa-controller-policy"
  policy = file("${path.module}/irsa-operator-policy.json")
}
resource "aws_iam_role_policy_attachment" "giantswarm-irsa-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-irsa-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-network-topology-controller-policy" {
  name   = "giantswarm-${var.installation_name}-network-topology-controller-policy"
  policy = file("${path.module}/network-topology-operator-policy.json")
}
resource "aws_iam_role_policy_attachment" "giantswarm-network-topology-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-network-topology-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-resolver-rules-operator-policy" {
  name   = "giantswarm-${var.installation_name}-resolver-rules-operator-policy"
  policy = file("${path.module}/resolver-rules-operator-policy.json")
}
resource "aws_iam_role_policy_attachment" "giantswarm-resolver-rules-operator-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-resolver-rules-operator-policy.arn
}

resource "aws_iam_policy" "giantswarm-mc-bootstrap-policy" {
  name   = "giantswarm-${var.installation_name}-mc-bootstrap-policy"
  policy = file("${path.module}/mc-bootstrap-policy.json")
}
resource "aws_iam_role_policy_attachment" "giantswarm-mc-bootstrap-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-mc-bootstrap-policy.arn
}
