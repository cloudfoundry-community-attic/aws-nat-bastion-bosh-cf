# Network Topology

## Subnets

The various subnets that are created by the repo [terraform-aws-vpc](https://github.com/cloudfoundry-community/terraform-aws-vpc), as well as by [terraform-aws-cf-net](https://github.com/cloudfoundry-community/terraform-aws-cf-net).

|    Name     |     CIDR   | Created By          |
--------------|------------|----------------------
|Bastion      | X.X.0.0/24 | terraform-aws-vpc   |
|Microbosh    | X.X.1.0/24 | terraform-aws-vpc   |
|Loadbalancer | X.X.x2.0/24| terraform-aws-cf-net|
|Runtime 2a   | X.X.x3.0/24| terraform-aws-cf-net|
|Runtime 2b   | X.X.x4.0/24| terraform-aws-cf-net|