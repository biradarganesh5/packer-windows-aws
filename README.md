# packer-windows-aws
Contains template to use packer to create custom windows AMI

Steps to create your custom AMI

1. Add all the powershell commands in the install.ps1 file.

2. Do not touch winrm bootstrap file

3. Customize packer script if you want to change instance properties.
