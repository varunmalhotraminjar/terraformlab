# Packer_Terraform_AWS_DOCKER_SWARM SETUP

Here is the basic setup to run docker swarm cluster in AWS using Packer and Terraform. This will setup a swarm cluster with one swarm manager + two swarm workers. The swarm is initiated during provisioning. All other swarm agents (workers) will automatically connect to the manager, Since we don't know the manager join token before the initialisation, we choose to copy it to a file on the swarm manager and do "scp" to the master host from the agent's machines.by a token, generated during the swarm initialisation. 

# Preparation 

AWS account

Generate IAM Access Key and Secret Key and assign EC2 Full permission to that user. 

SSH keys
Before to start, create ssh keys. Terraform will create key-pair in AWS, based on these keys.

# Preparation 

provider.tf : - defines the aws credentials and region.
vars.tf :-  contains all variables used on the scripts.
securitygroup.tf :- defines the security groups for elastic load balancer and ec2 instances.
packer-example.json :-  defines the steps to build AMI and run script which will inturn install docker and update packages

build-and-launch.sh :-  is a script that contains the steps to build the image, after building the image grab the AMI ID and put it  in a file "amivar.tf" and finally run Terraform apply. 

vpc.tf	:-              defines the steps to build a VPC

instance.tf :-          contains the steps to create manager and worker nodes and join swarm cluster
