# aws-nat-bastion-bosh-cf

With aws-nat-bastion-bosh-cf you can set up a best practices Cloud Foundry with just a few commands.

Today you get Cloud Foundry on Amazon Web Services. Work is underway to simplify maintenance and support other IaaS and to include additional supporting services you are likely to need when you use Cloud Foundry.

Setup the prerequisites, clone this repo, run the commands, and you'll have a fully functional Cloud Foundry to deploy applications on AWS.

How does it work? [Terraform](https://www.terraform.io/) configures the networking infrastructure on AWS, next `bosh-init` sets up the BOSH Director, then BOSH installs Cloud Foundry.

## Goals

  * Re-sizable - Start small, but can grow as big as you need.  See `config/aws/cf-<size>.yml` for examples.
  * Accessible - Give users the ability to try Cloud Foundry on AWS as quickly and easily as possible.
  * Configurable - Manage the deploy manifests with [Spruce](https://github.com/geofffranks/spruce).
  * Maintainable: Upgrade and adjust your Cloud Foundry deployment as your production needs change.

## Prerequisites

Examples assume you are running Mac OS X. Ensure the following are setup before continuing.

  * [Amazon Web Services Setup](docs/aws-setup.md)
  * Mac OS X with [Homebrew](http://brew.sh/)

Homebrew will be used to install other third party software such as terraform or make

## Quick start

**Make sure you have set up the prerequisites listed above.**

For more detailed instructions, see [Detailed Setup](docs/detailed-setup.md). If you run into trouble, check [troubleshooting.md](docs/troubleshooting.md) for suggestions.

### Clone Repo

In your local code folder clone the repo, then change to that folder.

```sh
git clone https://github.com/cloudfoundry-community/aws-nat-bastion-bosh-cf.git
cd aws-nat-bastion-bosh-cf
```

### Prepare

The `make prepare` command will install Terraform to your `/usr/local/bin` folder.

```sh
make prepare
```

### SSH Key

Both BOSH and Cloud Foundry expect to find the key named `sshkeys/bosh.pem`.  Rename your private key to match this and copy it to the `sshkeys` folder.

### Configure Terraform

Terraform creates a `plan`.  Then users `apply` the `plan` and the infrastructure is allocated for the given provider.

Configure the `terraform/aws/terraform.tfvars` file and Terraform will know who you are on AWS and where to create it's resources.

TODO Find location somewhere to state the region names us-west-1 since the EC2 displays (North California)
Cpy the example file to the `terraform.tfvars` file:

```sh
cp terraform/aws/terraform.tfvars.example terraform/aws/terraform.tfvars
```

Follow the instructions in the example file about any changes that need to be made.


### Make It Go

```sh
make all
```

## Additional Commands

### Connect to Bastion Server

Connecting to the Bastion host to control the BOSH Director run BOSH cli or Cloud Foundry cli commands run:

```sh
make ssh
```

When running longer running tasks like `make provision-cf` or `make provision-bosh` it can be useful to see progress by running `tail -f /home/centos/provision.log` on the bastion server.

### Destroy Environment

To tear down the BOSH Director, Bastion server, NAT server and remove the Amazon Virtual Private Cloud definitions defined by Terraform you can run `make destroy`.

```sh
make destroy
```

### Clean Terraform Cache

To reset the Terraform cached files and start over, you can also run:

```sh
make clean
```

Check out [terraform debugging](docs/terraform.md#debugging) for more about troubleshooting Terraform errors.

## Related Repositories

  * [bosh-init](https://github.com/cloudfoundry/bosh-init)
  * [spruce](https://github.com/geofffranks/spruce)
  * [terraform-aws-cf-install](https://github.com/cloudfoundry-community/terraform-aws-cf-install)
  * [terraform-aws-vpc](https://github.com/cloudfoundry-community/terraform-aws-vpc)
  * [terraform-aws-cf-net](https://github.com/cloudfoundry-community/terraform-aws-cf-net)

## Apps to Validate Your Deployment / Pipeline(s)

Check out [docs/apps.md](docs/apps.md) for some suggested applications you can use to validate your deployment and keeping your diagnostic scope narrow so that a real production app with dozens of moving parts doesn't overcomplicate the process of validation. (These are also useful for potentially debugging integration(s) between "real" apps and integrations with services, etc.)
