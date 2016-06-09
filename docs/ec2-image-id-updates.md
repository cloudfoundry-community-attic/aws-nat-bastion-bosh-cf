## EC2 Image ID Updates

Run `aws configure` to setup your AWS credentials for your current region.

```sh
make provider-centos-ami-ids
```

When you run `make provider-centos-ami-ids` replaces the block in `terraform/aws/variables.tf`.

```
variable "aws_centos_ami" {
  type = "map"
  default = {
  us-east-1 = "ami-6d1c2007"
  us-west-1 = "ami-af4333cf"
  us-west-2 = "ami-d2c924b2"
  ap-northeast-1 = "ami-eec1c380"
  ap-northeast-2 = "ami-c74789a9"
  ap-southeast-1 = "ami-f068a193"
  ap-southeast-2 = "ami-fedafc9d"
  eu-west-1 = "ami-7abd0209"
  sa-east-1 = "ami-26b93b4a"
  }
}
```
