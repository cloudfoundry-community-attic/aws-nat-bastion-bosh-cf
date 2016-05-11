# Amazon Web Services Setup

Before you begin please ensure you have created an account or have logged in to AWS.

[Create an account](https://aws.amazon.com/free) or [sign in](https://console.aws.amazon.com/console/home).

## Create an IAM User and Group

We're creating the [IAM User](http://docs.aws.amazon.com/IAM/latest/UserGuide/id.html) that will have it's abilities defined by the membership to the Group and Role you create.

* Create your user.  For example: `tbird`. This will likely match what is used as the SSH Key below.
* Add that user to a Group.  Give that user permissions on the system by attaching a policy.

NOTE: An interesting tool to discover more about IAM Polices is the [IAM Policy Simulator](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html).

## Access Key ID and Secret Access Key

At AWS, the **Access Key ID and Secret Access Key** are a global ID and token that can be used to authenticate to the services you use.

If you've not already you can create an [Access Key ID and Secret Access Key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html).

Otherwise it's in the IAM Dashboard for your User, located under the **Security Credentials** tab.

## SSH Key

We use an SSH Key to perform authentication to AWS on your behalf.  You can either use an [existing key or generate a key for this purpose](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).

## Verify the Key

You can verify your key is installed correctly by running this command to get the output of your local file's fingerprint.

```
openssl pkcs8 -in path_to_private_key -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c
```

Then sign into AWS. At the top of the page click on Services, then EC2.  Look on the left hand side, under NETWORK & SECURITY and click on Key Pairs.  The fingerprint in the AWS Console for your user should match the output from the command above.

NOTE: Be aware that AWS EC2 keys are region based, and require 2048 bit encryption.
