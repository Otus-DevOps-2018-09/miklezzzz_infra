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
