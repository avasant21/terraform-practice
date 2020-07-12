<h2><u>Instruction - Terraform Deployment</u></h2>
<h3>Pre-requisites</hv3>
1. Install terraform and connfigure appropriate binary path following the below link.

<a href="https://www.terraform.io/downloads.html"> https://www.terraform.io/downloads.html</a>

2. Configuring AWS Profile
Follow the below steps to create aws default profile

$ aws configure
AWS Access Key ID [None]: <b>{Access Key}</b>
AWS Secret Access Key [None]: <b>{Secret Access Key}</b>
Default region name [None]: <b>{Leave as blank}</b>
Default output format [None]: <b>{Leave as blank as default it JSON}</b>

3. Creating Key-Pair
Follow the below instructions to create keypair which will be imported as a aws key-pair part of terraform deployment

$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/vaa100/.ssh/id_rsa): <b>./test-key</b>
Enter passphrase (empty for no passphrase): <b>{Leave as blank}</b>
Enter same passphrase again: <b>{Leave as blank}</b>
<b>{Enter until you get the promp}</b>

<h3>Structuring Terraform Templates</h3>
1. Provider Definition
Providers has been defined in <b>provider.tf</b> file

2. Declaring Variables
Refer and modify <b>variables.tf</b> file based on requirement

3. Declaring Variables file
Required variables can be declared in <b>vars.tfvars</b> file

4. Declaring Data block
Data Block defination can be referred and modified in <b>data_source.tf</b>

5. Creating Key-Pair Resource
Created ssh key-pair can be imported in <b>key_pair.tf</b> file

6. Creating Security Group Modules
Security Group has been created part of a module and referred in module <b>sg.tf</b> and <b>modules/sg/*.tf</b> 

7. Defining User Data
All the required userdata content has been created as script <b>scripts/ec2-bootstrap.sh</b>

8. Defining Cloud-Init
The script has been called as cloud-init resource in <b>modules/ec2/ec2.tf</b>

9. Defining Instance Modules
The instance creation has been defined part of modules <b>ec2.tf</b> and <b>modules/ec2/*.tf</b>

10. Defining Outputs
The Output is defined in <b>output.tf</b> file in respective modules

<h3>Stack Deployment</h3>
1. Terraform Initiation
Execute below command to initializing modules and installing required provider plugins

$ terraform init

2. Terraform Syntax Validation
Validate the terraform syntax using the below command

$ terraform validate

3. Terraform Dry Run
Execute and verify the terraform templates without actually applying/creating the resources using plan as below.

$ terraform plan -var-file="vars.tfvars"

4. Terraform Deployment
Deploy the stack using the below apply command

$ terraform apply -var-file="vars.tfvars"

5. Terraform State Operations
Verify the created resources using state option as below. This will read and show the information from *.tfstate file created part of apply execution

$ terraform state list

6. Terraform Output Operations
List & verify the outputs using the below command

$ terraform output

7. Terraform Destroy Operations
The created resources can be fully deleted using the below destroy option

$ terraform destroy