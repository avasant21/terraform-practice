<h2><u>Instruction - Terraform Deployment</u></h2>

<h3>Pre-requisites</h3>
  
1. Install terraform and connfigure appropriate binary path following the below link.</br>

      <a href="https://www.terraform.io/downloads.html"> https://www.terraform.io/downloads.html</a></br>

2. Configuring AWS Profile</br>
    Follow the below steps to create aws default profile</br>

        $ aws configure
        AWS Access Key ID [None]: <b>{Access Key}</b>
        AWS Secret Access Key [None]: <b>{Secret Access Key}</b>
        Default region name [None]: <b>{Leave as blank}</b>
        Default output format [None]: <b>{Leave as blank as default it JSON}</b>

3. Creating Key-Pair</br>
    Follow the below instructions to create keypair which will be imported as a aws key-pair part of terraform deployment</br>

        $ ssh-keygen
        Generating public/private rsa key pair.
        Enter file in which to save the key (/c/Users/vaa100/.ssh/id_rsa): <b>./test-key</b>
        Enter passphrase (empty for no passphrase): <b>{Leave as blank}</b>
        Enter same passphrase again: <b>{Leave as blank}</b>
        <b>{Enter until you get the promp}</b>

<h3>Terraform Templating</h3>
  
1. Provider Definition</br>
    Providers has been defined in <b>provider.tf</b> file</br></br>

2. Declaring Variables</br>
    Refer and modify <b>variables.tf</b> file based on requirement</br></br>

3. Declaring Variables file</br>
    Required variables can be declared in <b>vars.tfvars</b> file</br></br>

4. Declaring Data block</br>
    Data Block defination can be referred and modified in <b>data_source.tf</b></br></br>

5. Creating Key-Pair Resource</br>
    Created ssh key-pair can be imported in <b>key_pair.tf</b> file</br></br>

6. Creating Security Group Modules</br>
    Security Group has been created part of a module and referred in module <b>sg.tf</b> and <b>modules/sg/*.tf</b> </br></br>

7. Defining User Data</br>
    All the required userdata content has been created as script <b>scripts/ec2-bootstrap.sh</b></br></br>

8. Defining Cloud-Init</br>
    The script has been called as cloud-init resource in <b>modules/ec2/ec2.tf</b></br></br>

9. Defining Instance Modules</br>
    The instance creation has been defined part of modules <b>ec2.tf</b> and <b>modules/ec2/*.tf</b></br></br>

10. Defining Outputs</br>
    The Output is defined in <b>output.tf</b> file in respective modules</br>

<h3>Stack Deployment</h3>

1. Terraform Initiation</br>
    Execute below command to initializing modules and installing required provider plugins</br>

        $ terraform init

2. Terraform Syntax Validation</br>
    Validate the terraform syntax using the below command</br>

        $ terraform validate

3. Terraform Dry Run</br>
    Execute and verify the terraform templates without actually applying/creating the resources using plan as below.</br>

        $ terraform plan -var-file="vars.tfvars"

4. Terraform Deployment</br>
    Deploy the stack using the below apply command</br>

        $ terraform apply -var-file="vars.tfvars"

5. Terraform State Operations</br>
    Verify the created resources using state option as below. This will read and show the information from "*.tfstate" file created part of apply execution</br>

        $ terraform state list

6. Terraform Output Operations</br>
    List & verify the outputs using the below command</br>

        $ terraform output

7. Terraform Destroy Operations</br>
    The created resources can be fully deleted using the below destroy option</br>

        $ terraform destroy
