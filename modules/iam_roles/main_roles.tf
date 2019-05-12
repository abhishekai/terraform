data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${aws_iam_role.this.name}"
  role = "${aws_iam_role.this.name}"
}
resource "aws_iam_role" "this" {
  count                = "${var.create_role ? 1 : 0}"
  name                 = "${var.role_name}" ## Will be loaded from /dev/main.tf
  path                 = "${var.role_path}" ## pick up from default variable
  description          = "${var.description}" ## pick up from default variable
  #max_session_duration = "${var.max_session_duration}"
  #permissions_boundary = "${var.role_permissions_boundary_arn}"
  #assume_role_policy    = "${data.aws_iam_policy_document.assume_role.json}" ## Incase of Trustes Entity as Account:xxxxxxxxxxxx
  assume_role_policy    = "${data.aws_iam_policy_document.policy.json}" ## Trusted Entity is ec2 service
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = "${var.create_role && length(var.custom_role_policy_arns) > 0 ? length(var.custom_role_policy_arns) : 0}"
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${element(var.custom_role_policy_arns, count.index)}"
}