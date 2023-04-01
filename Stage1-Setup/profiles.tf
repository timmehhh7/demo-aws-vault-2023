resource "local_file" "terraform" {
  filename = "${path.module}/../Stage3-AssumeRole/aws_assume_profiles.tf"
  content  = <<-EOT
%{for account in var.accounts}
################### Provider for ${account} ###################
provider "aws" {
  alias = "${account}"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.demo[account].id}:role/Administrator"
  }
}
##################################################################

################### Config for ${account} ###################
resource "aws_iam_role" "${account}" {
  provider = aws.${account}
  name     = "vault_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_organizations_organization.root.master_account_id}:user/${var.vault_account}"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "${account}" {
  provider   = aws.${account}
  role       = aws_iam_role.${account}.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
##################################################################

%{endfor}

################### Allow Assume Role for Main Account ###################
resource "aws_iam_policy" "main" {
  name        = "vault-allow-demo"
  description = "Allow Assume Role to Sub Accounts"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = [
%{for account in var.accounts ~}
          "arn:aws:iam::${aws_organizations_account.demo[account].id}:role/vault_role",
%{endfor ~}
        ]
      },
    ]
  })
}
resource "aws_iam_user_policy_attachment" "main" {
  user       = "${var.vault_account}"
  policy_arn = aws_iam_policy.main.arn
}
##################################################################

EOT
}
