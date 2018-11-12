# miklezzzz_infra
miklezzzz Infra repository

++++++++++++++++++++++++++++
HW03: Self study
++++++++++++++++++++++++++++

***Direct connect to an internal host inside GCP:

In order to connect to an internal host through Bastion-host we can use following one line syntax:

   ssh -i <local path to your ssh secret key> -A -t <your user name>@<bastion-host public ip> 'ssh <internal host name>'

"-A" switch stands for forwarding of the authentication agent
"-t" switch stands for pseudo-terminal allocation

Or we can use ssh ProxyCommand feature:

We should create ssh "config" file in our home directory "~/.ssh/" with appropriate permissions (0600 would be enough) and following content:

   Host <alias for our internal host>
   ProxyCommand ssh <bastion-host public ip> -W %h:%p

bastion_IP = 35.234.123.137
someinternalhost_IP = 10.156.0.3


++++++++++++++++++++++++++++
HW04: Self study
++++++++++++++++++++++++++++

testapp_IP = 104.155.35.71
testapp_port = 9292 

***gcloud syntax for startup_script:

gcloud compute instances create reddit-app-with-startup --boot-disk-size=10GB --image-family=ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags=puma-server --restart-on-failure --metadata-from-file startup-script=<local path to startup_script file>/startup_script.sh

***gcloud syntax for firewall rules:

gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --description="This rule permits ingress traffic to tcp:9292 from any source"  --priority=1000 --source-ranges="0.0.0.0/0" --target-tags=puma-server

++++++++++++++++++++++++++++
HW05: Self study
++++++++++++++++++++++++++++

- "Reddit-base" image was added to GCP infrastructure via packer config file with predefined applications for our test project.

- Packer configuration file for "reddit-base" image was parametirized by means of "user variables" and file.

- More packer GCP options were added (disk size/type, image description, etc... tags doesn't work, by the way) to packer configuration file.

- Extended packer template and a couple of additional scripts were added to bake "Reddit-full" image with the test project running from the start (via systemd unit).

- Shell script was added to run GCP instance from "Reddit-full" image via gcloud utility.

++++++++++++++++++++++++++++
HW06: Self study
++++++++++++++++++++++++++++

- Simple IaC project based on Terraform utility was added.

- Main TF file was parameterized by few variables.

- All TF files were formatted by means of "fmt" switch (awesome).

- SSH public key for an user was added to a project metadata via Terraform (ssh authentication via public key passed successfully). 

- Two more ssh public keys were added to a project metadata via Terraform (ssh authentication via public keys passed successfully).

- One more ssh public key was added via GCP WEB GUI so configuration drift was introduced and remediated by next "terraform apply". 

- HTTP load balancer was added via Terraform utility.

- Another one instance of reddit-app resource was added with intention to introduce high availability into our project. An infrastructure won't scale well with such rough approach.

- Project "scalability" was improved by means of "count" attribute used in GCP instance resource definition.

++++++++++++++++++++++++++++
HW07: Self study
++++++++++++++++++++++++++++

- Test app server configuration was splitted up into App server and DB server roles. Corresponding GCI images were builded with Packer.

- Test IaC project was separated into reusable modules.

- Modules were parameterized to extend the code reusability.

- Production and Stage environments were introduced.

- Terraform states for Prod and Stage were moved to remote backends (Google Cloud Storage), created with the "storage bucket" module from Terraform Module Registry.

- State lock feature for GCS backend was tested. Tried to perform two different changes in an infrastructure simultaneously, with no luck.

- App and DB modules were supplemented with provisioners capable to deploy "distributed" reddit application.

- "deploy" variable was introduced into the project to control provisioners behavior (turn on/off provisioners).

++++++++++++++++++++++++++++
HW08: Self study
++++++++++++++++++++++++++++

- "Reddit" repo was cloned twice with "git" module: first time there was already cloned repo in "reddit" directory and Ansible had nothing to do (changed=0) and next time, after deleting "reddit" directory by hands, Ansible indeed cloned "reddit" repo from a remote source (changed=1).

- Corresponding inventory file inventory.json with current infrastructure was added.

- In order to run fake dynamic inventory generation the script named dynamic_inventory.sh was added. It prints inventory.json file to stdout during execution so we can use it with Ansible like this: "ansible all -m ping -i ./dynamic_inventory.sh"

- To run actual dynamic inventory generation another one script named dynamic_inventory.py was added. It works in conjunction with remote terraform tfstate file so you should put correct Google Cloud Storage bucket URL (full path) into the "GCS" variable. The script gets Terraform state file from a bucket and parse it out to produce JSON-formatted output suitable to use as inventory.
