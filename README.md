# Hosting simple website on container in EC2
## Task
Create Terraform configuration file that creates EC2 instance with:
- Security Groups
- Elastic IP
- CloudWatch Alarm

## How to run
Clone repository to your computer
```
git clone https://github.com/DanyaCt/EC2TerraformDocker.git
```
Also you need download Terraform and AWS CLI, you can use these links:

>Terraform: https://developer.hashicorp.com/terraform/downloads
>
>AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Next you must login to your account in AWS, guide for this:
>https://docs.aws.amazon.com/cli/latest/reference/configure/

You will also need to create a key pair in AWS, guide for this:

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html

Then you must change my key to your own in code (line 17)

Run these commands:
```
terraform init
terraform apply -auto-approve
```
Now you can check your website using output from Terraform, just paste that in your browser!
