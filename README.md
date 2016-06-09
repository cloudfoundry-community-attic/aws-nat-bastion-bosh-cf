# README

Set up a best practices Cloud Foundry with just a few commands.

## Setup

1. Change to your projects folder, and clone the repo.

    <pre class="terminal">
    git clone https://github.com/cloudfoundry-community/aws-nat-bastion-bosh-cf.git
    cd aws-nat-bastion-bosh-cf
    </pre>

1. Install [Homebrew](http://brew.sh/).

    <pre class="terminal">
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    </pre>

1. Our project can direct Homebrew to install dependencies (`direnv`,`jq`,`terraform`).

    <pre class="terminal">
    make install-dependencies
    </pre>

1. Add Infrastructure CLI tools, for example AWS CLI tools is available via Homebrew.

    <pre class="terminal">
    homebrew install awscli
    </pre>

#### No Mac? No Homebrew? Here's your "shopping list"

Those of you who aren't on OS X and/or rolling with brew, the tools you need are as follows. Be aware that we're doing our best to document the main version of the tool we've developed against here, and some projects may not follow [semver](http://semver.org) correctly if at all. Just be sure that if you install something and the version is dramatically different than what's here, you try something closer to the below versions if you run into trouble.

> Hint: Check out the shell function in [bin/nbb](bin/nbb) called `install_dependencies` for the implementation we have for Mac users.

| Tool | Version |
| :--- | :-----: |
| [Homebrew](https://github.com/homebrew/brew) _only if running OS X_ | `~> 0.9.9` |
| [Terraform](https://www.terraform.io/) | `v0.6.16` |
| [jq](https://stedolan.github.io/jq/) | `jq-1.5` |
| [direnv](http://direnv.net/) | `2.8.1` |
| [awscli](https://aws.amazon.com/cli/) | `aws-cli/1.10.35` |

Finally, be sure that the start script or binary for each of these is installed and available in your `$PATH`. You might have to reload/relaunch your shell after installing these depending on said shell and its configuration.

### SSH Key

Both BOSH and Cloud Foundry expect to find the key named `sshkeys/bosh.pem`.  Rename your private key to match this and copy it to the `sshkeys` folder.

### Configure Terraform

Terraform creates a `plan`.  Then users `apply` the `plan` and the infrastructure is allocated for the given provider.

Configure the `terraform/aws/terraform.tfvars` file and Terraform will know who you are on AWS and where to create it's resources.

> Hint: `cp terraform/aws/terraform.tfvars.example terraform/aws/terraform.tfvars` and edit the second one. Remember: the non-example version is in `.gitignore` for a good reason: do you want your AWS variables for potentially `PowerUser` access to your whole account in git history and/or maybe even public on GitHub? :smiley:

TODO Find location somewhere to state the region names us-west-1 since the EC2 displays (North California)

Follow the instructions in the example file about any changes that need to be made.

## Make It Go

This command will handle the entire bootstrap process start to finish. _It's going to take a while to finish so run this before lunch, or something, so it's non-blocking relative to your workflow._ It's not uncommon (in our testing anyway) to have this take over an hour depending on various factors, so **be patient**.

```sh
make all
```

### List of make commands

**SSH up to your bastion host** to control the BOSH Director, run BOSH cli, or Cloud Foundry cli commands.

```sh
make ssh
```

**Tail the logs**

When running longer running tasks like `make provision-cf` or `make provision-bosh` it can be useful to see progress by running `tail -f /home/centos/provision.log` on the bastion server.

```sh
make ssh
# ...random output...
tail -f $HOME/provision.log
```

**DESTROY EVERYTHING!**

If you're developing/testing/debuging or just feeling particularly cruel, you can nuke the entire deployment - bastion host, BOSH director, all the CF instances, everything - with this one all-powerful command:

```sh
make destroy
```

This will tear down the BOSH Director, Bastion host, NAT server and remove the Amazon Virtual Private Cloud definitions created by Terraform.

> **_Gotcha! DependencyViolation_** If you get some error output while running `make destroy` saying that there's a "dependency violation", please create a GH issue for it and give us as much detail as possible _including the relevant parts of the log file_. We've run into this bug during development and while we _think_ we've got it squashed, should it resurface we'd like to know. _To recover_, just go into the AWS console manually (https://aws.amazon.com) and remove each of the major resources that would be involved - instances, volumes, subnets, security groups, non-default VPCs, etc. Then drop back into your terminal and run `make destroy` again before continuing.


## More Information

More information about this project is available in the [docs](docs) folder.

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).
