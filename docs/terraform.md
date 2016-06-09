# Terraform

## Clean Terraform Cache

To reset the Terraform cached files and start over:

```sh
make clean
```

## Debugging

In your current shell, to turn on Terraform debugging to `stderr` of your terminal, run:

```sh
export TF_LOG=TRACE
```

Once you've got what you need and want to turn it back off you can run, to return to default setting:

```sh
export TF_LOG=WARN
```
