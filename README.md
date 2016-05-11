# aws-nat-bastion-bosh-cf

Setup the prerequisites, clone this repo, run the commands, and you'll have a fully functional Cloud Foundry to deploy applications on AWS.

How does it work? [Terraform](https://www.terraform.io/) configures the networking infrastructure on AWS, next `bosh-init` sets up the BOSH Director, then BOSH installs Cloud Foundry.

## Goals

  * Re-sizable - Start small, but can grow as big as you need.  See `config/aws/cf-<size>.yml` for examples.
  * Accessible - Give users the ability to try Cloud Foundry on AWS as quickly and easily as possible.
  * Configurable - Manage the deploy manifests with [Spruce](https://github.com/geofffranks/spruce).

## Prerequisites

The documentation is built around running the commands from a Mac OS X laptop as your workstation.

  * Amazon Web Services account
  * Mac OS X with [Homebrew](http://brew.sh/)

## 

, first run the following:

```sh
make prepare
```

## Deploying a BOSH VPC

First you will need to add your credentials to the appropriate location.

Copy the example file to the `terraform.tfvars` file:
```sh
cp terraform/aws/terraform.tfvars.example terraform/aws/terraform.tfvars
```
Next edit the file and replace the values with your AWS account credentials.

## Create the VPC, NAT and Bastion (Jump Box)

In order to *deploy* a VPC, NAT and Bastion Box:

```sh
make plan
make apply
make provision-base
```

## Create BOSH Director (via bosh-init)

```sh
make provision-bosh
```

## Destroying Everything

In order to *destroy* a previously deployed VPC,

```sh
make destroy
```

## Related Repositories

  * [bosh-init](https://github.com/cloudfoundry/bosh-init)
  * [spruce](https://github.com/geofffranks/spruce)
  * [terraform-aws-cf-install](https://github.com/cloudfoundry-community/terraform-aws-cf-install)
  * [terraform-aws-vpc](https://github.com/cloudfoundry-community/terraform-aws-vpc)
  * [terraform-aws-cf-net](https://github.com/cloudfoundry-community/terraform-aws-cf-net)
