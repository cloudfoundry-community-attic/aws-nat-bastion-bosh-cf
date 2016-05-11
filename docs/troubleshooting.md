## Troubleshooting

If this message is received:
```
Error applying plan:

1 error(s) occurred:

* aws_instance.bastion: Error launching source instance: OptInRequired: In order to use this AWS Marketplace product you need to accept terms and subscribe. To do so please visit http://aws.amazon.com/marketplace/pp?sku=aw0evgkw8e5c1q413zgy5pjce
  status code: 401, request id:

Terraform does not automatically rollback in the face of errors.
Instead, your Terraform state file has been partially updated with
any resources that successfully completed. Please address the error
above and apply again to incrementally change your infrastructure.
```
Go to the URL in the error message and click "Manual Launch" tab (for EC2 APIs / CLI) and click the giant orange button to "Accept Software Terms". Then re-run the commands.
