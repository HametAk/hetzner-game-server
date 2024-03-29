# Hetzner Game Server
## About this project
Hello everyone,
I decided to start a project to create dedicated servers for a few games I play on a single host on Hetzner.
This code is all written by me.

This project is able to deploy:
- Valheim
- Terraria
- Minecraft with Mods

Future updates will include:
- V Rising
- ...
## Requirements
- [Terraform](https://www.terraform.io)

- [Hetzner API Token](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/) \
To use this project, it is necessary to have a full verified hetzner account and an api key with read & write privileges

## Optional
- [SSH Key](https://community.hetzner.com/tutorials/howto-ssh-key) \
If you want to connect to the VM, you should provide a ssh key.

## How it works
This project was built on two things: VM and Storage
To build and destroy as you want, it is best practice to have two states. One for the storage and one for the VM.
That's because if it all would be in a single state file, deletion would cause your save files to be deleted too.
So in the end you would only delete the VM and don't touch the storage (unless you really want to destroy it too).

Set the shared.tfvars in the root module with your desired values.
With that done you can start to deploy it.

Go into <module-path>/storage and use the command:
```sh
terraform init
terraform apply -auto-approve -var-file=../shared.tfvars
```
After successful deployment of the storage you can deploy the VM.
Go into <module-path>/game and use the command:
```sh
terraform init
terraform apply -auto-approve -var-file=../shared.tfvars
```

Since this is Infrastructure as Code you can delete the VM if you don't play anymore, so you don't generate any costs.
```sh
terraform destroy -auto-approve -var-file=../shared.tfvars
```

## Disclaimer 

This project is not affiliated with the games listed above or any of its employees, therefore it do not reflect the views of said parties and do not endorse or sponsor this project.
