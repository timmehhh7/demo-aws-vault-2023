data "aws_organizations_organization" "root" {}

data "aws_organizations_organizational_units" "vault_demo" {
  parent_id = data.aws_organizations_organization.root.roots[0].id
}

locals {
  parent_ou = flatten([
    for ou in data.aws_organizations_organizational_units.vault_demo.children: ou.id if ou.name == "demo-aws-vault-2023"
  ])
}

data "aws_organizations_organizational_unit_child_accounts" "accounts" {
  parent_id = local.parent_ou[0]
}

resource "aws_iam_user" "vault" {
  name = var.vault_account
}

resource "aws_iam_access_key" "vault" {
  user = aws_iam_user.vault.name
}

resource "vault_aws_secret_backend" "aws" {
  description = "Demo AWS Backend"
  path = "aws-demo"
  access_key = aws_iam_access_key.vault.id
  secret_key = aws_iam_access_key.vault.secret
  default_lease_ttl_seconds = "900"
  max_lease_ttl_seconds     = "900"
}

resource "vault_aws_secret_backend_role" "role" {
  for_each        = { for index, account in data.aws_organizations_organizational_unit_child_accounts.accounts.accounts: account.id => account }
  backend         = "aws-demo"
  name            = "aws-demo-${each.value.name}"
  credential_type = "assumed_role"
  default_sts_ttl = 900
  max_sts_ttl     = 900
  role_arns       = [
    "arn:aws:iam::${each.value.id}:role/vault_role",
  ]
}

resource "vault_policy" "demo" {
  name = "aws-demo"

  policy = <<EOT
path "aws-demo/sts/aws-demo-*" {
  capabilities = ["create", "read", "update", "list"]
}
EOT
}
