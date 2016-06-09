# Detailed Setup

Make sure you have set up the prerequisites [as described in README.md](../README.md#prerequisites).

## Make All

Running `make all`, will run the above commands in order:

```
  make plan
  make apply
  make provision-base
  make provision-bosh
  make provision-cf-cli
  make provision-cf
```

Let's look at those steps individually:

### Create Virtual Private Cloud

Using Terraform now we'll create the AWS Virtual Private Cloud and ancillary gateways, routes and subnets.  For more read about the [network topology](docs/network-topology.md).

```sh
make plan
make apply
```

When an apply is complete the output will look something like this:

```
Apply complete! Resources: 27 added, 0 changed, 0 destroyed.
```

### Install Requirements Onto Bastion Host

A bastion host is a server that sits on a public Internet address and provides a special service.  This server is a jump-box that bridges the connection between public and private subnets.

`make apply` created a bastion host. Now we need to install some additional tools on the bastion.

```sh
make provision-base
```

### Create BOSH Director

Using `bosh-init` we'll be creating the BOSH Director instance next.

```sh
make provision-bosh
```
### Install CF CLI

Installing the Cloud Foundry CLI tool on the Bastion Host can be performed by running this command.

```sh
make provision-cf-cli
```

### Deploy Cloud Foundry

Once the base bastion server and BOSH Director are setup Cloud Foundry can be deployed.

```sh
make provision-cf
```
