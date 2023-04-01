locals {
  root_user_email_trim_length = 64-(length(var.root_user_email)+3+6+length(var.mailbox_domain))
}

variable "accounts" {}
variable "users" {}
variable "root_user_email" {}
variable "mailbox_domain" {}
