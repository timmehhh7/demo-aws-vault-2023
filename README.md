# demo-aws-vault-2023
Sample code for Dynamic Secrets with Hashicorp Vault and AWS

Verify roles are in place:
```shell
tfairweath001@CA_ML4LG34TW3 Stage3-AssumeRole % vault list aws-demo/roles
Keys
----
aws-demo-moon-of-vega
aws-demo-planet-druidia
aws-demo-planet-spaceball
```

Retrieve credentials from Vault:
```shell
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
vault token create -ttl=30m -policy=aws-demo
export VAULT_TOKEN=<>
source set_creds_moon_of_vega
```

Verify identity and run command in CLI:
```shell
aws sts get-caller-identity
aws ec2 describe-vpcs --region=us-east-1
```