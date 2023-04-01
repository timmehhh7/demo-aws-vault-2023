# Initial Setup for the demo

```ssh
aws s3api create-bucket --bucket demo-aws-vault-2023-state --region ca-central-1 --create-bucket-configuration LocationConstraint=ca-central-1
```

```ssh
{
    "Location": "http://demo-aws-vault-2023-state.s3.amazonaws.com/"
}
```