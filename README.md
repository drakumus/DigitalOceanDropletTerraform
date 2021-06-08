# DigitalOceanDropletTerraform
Terraform for a project server on Digital Ocean.
Brings up an instance of terraform and creates a mobaxterm session file to allow for connection via ssh by simply double clicking.

# *.auto.terraform files not included

**do_token** = string api token from digital ocean see - https://cloud.digitalocean.com/account/api/

**private_ssh_key** = private ssh key i.e. ./path/to/file/ida.ssh used to create mobaxterm session file and allows the provisioner to execute commands on the freshly made droplet.

**public_ssh_key** = public ssh key i.e. ./path/to/file/ida_pub.ssh used to give droplet a public key for ssh connection

Example:

```
do_token="beepboopboop"
private_ssh_key="C:\\Users\\BeepBooper\\Documents\\rsa\\terraform\\project_server"
public_ssh_key="C:\\Users\\BeepBooper\\Documents\\rsa\\terraform\\project_server.pub"
```


# Commands
To bring up terraform and generate a droplet:
```
terraform apply
```

To destroy droplet and project
```
terraform destroy
```

To get the ssh address to connect to.
```
terraform out
```
