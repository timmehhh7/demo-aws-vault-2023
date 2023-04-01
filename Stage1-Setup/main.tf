resource "random_string" "per_user" {
  for_each         = toset(var.accounts)
  length           = 6
  special          = false
}

data "aws_organizations_organization" "root" {}

resource "aws_organizations_organizational_unit" "demo-aws-vault-2023" {
  name      = "demo-aws-vault-2023"
  parent_id = data.aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_account" "demo" {
    for_each          = toset(var.accounts)
    name              = each.key
    email             = "${var.root_user_email}+${substr(each.key,0,local.root_user_email_trim_length)}-${random_string.per_user[each.key].result}@${var.mailbox_domain}"
    role_name         = "Administrator"
    parent_id         = aws_organizations_organizational_unit.demo-aws-vault-2023.id
    close_on_deletion = true
    lifecycle {
        ignore_changes = [role_name,email]
    }
}
