# Ant-man

A small Cloud Foundry with a big punch.

![Ant Man](http://i.annihil.us/u/prod/marvel/movies/antman-full/media/images/02_suit/antman_front_small.png?v=1.4.4)

Setup the pre-requisites, clone this repo, run the commands, and you'll have a fully functional Cloud Foundry to deploy applications on AWS.

How does it work? [Terraform](https://www.terraform.io/) is used to configure the required networking infrastructure on AWS, next `bosh-init` sets up the BOSH Director, then BOSH will install Cloud Foundry.

## Goals

  * Resizable - Start small, but can grow as big as you need.  See `config/aws/cf-<size>.yml` for examples.
  * Accessable - Give users the ability to try Cloud Foundry on AWS as quickly and easily as possible
  * Configurable - Manage the deploy manifests with [Spruce](https://github.com/geofffranks/spruce).

## Pre-requisites

  * Amazon Web Services account
  * Homebrew

## Amazon Web Services

Before you begin please ensure you have created an account or have logged in to Amazon Web Services (AWS).

[Create an account](https://aws.amazon.com/free) or [sign in](https://console.aws.amazon.com/console/home).

### Create an IAM User and Group

We're creating the [IAM User](http://docs.aws.amazon.com/IAM/latest/UserGuide/id.html) that will have it's abilities defined by the membership to the Group and Role you create.

* Create your user.  For example: `tbird`. This will likely match what is used as the SSH Key below.
* Add that user to a Group.  Give that user permissions on the system by attaching a policy.

NOTE: An interesting tool to discover more about IAM Polices is the [IAM Policy Simulator](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html).

### Access Key ID and Secret Access Key

At AWS, the **Access Key ID and Secret Access Key** are a global ID and token that can be used to authenticate to the services you use.

IF you've not already you can create an [Access Key ID and Secret Access Key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html).

Otherwise it's in the IAM Dashboard for your User, located under the **Security Credentials** tab.

### SSH Key

We use an SSH Key to perform authentication to AWS on your behalf.  You can either use an [existing key or generate a key for this purpose](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).

### Verify the key

At the top of the page click on Services, then EC2.  Look on the left hand side, under NETWORK & SECURITY and click on Key Pairs.

The fingerprint for your user should match the output as below.

```
openssl pkcs8 -in /Users/tylerbird/code/cloudfoundry-community/aws-nat-bastion-bosh-cf/sshkeys/bosh.pem -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c
```

NOTE: AWS keys are region based, so repeat the SSH key steps for each region used: [`us-east-1`,`us-west-1`,`us-west-2`].

## Related Repositories

  * [terraform-aws-cf-install](https://github.com/cloudfoundry-community/terraform-aws-cf-install)
  * [terraform-aws-vpc](https://github.com/cloudfoundry-community/terraform-aws-vpc)
  * [terraform-aws-cf-net](https://github.com/cloudfoundry-community/terraform-aws-cf-net)

