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

# resource "vault_aws_secret_backend_role" "role" {
#   for_each        = { for k, v in var.enabled_users : k => v if v.job_title == "sandbox_user" }
#   backend         = "aws-demo"
#   name            = replace(lower(regex("[^@]*", each.value.email)), ".", "-")
#   credential_type = "assumed_role"
#   default_sts_ttl = 900
#   max_sts_ttl     = 900
#   role_arns       = [
#     "arn:aws:iam::${aws_organizations_account.team[each.key].id}:role/vault_role",
#   ]
# }

# resource "vault_policy" "demo" {
#   name = "aws-demo"

#   policy = <<EOT
# path "aws/sts/{{ identity.entity.metadata.${metadata_key} }}*" {
#   capabilities = ["create", "read", "update", "list"]
# }
# EOT
# }
