## EC2 Image ID Updates

[Install the AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html).

Run `aws configure` to setup your AWS credentials for your current region.

```sh
make centos-ami-ids
```

When you run `make centos-ami-ids` replaces the block in the `terraform/aws/variables.tf` file.

TODO: Check to see if it replaces all of them or only the region you are signed into.

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