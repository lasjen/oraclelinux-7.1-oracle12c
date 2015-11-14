# packer-oraclelinux-7

Builds an Oracle Linux 7 Installation for VirtualBox and Vmware (Untested) using packer and vagrant.

Template is based on https://github.com/dbehnke/packer-oraclelinux-7.git

## Prerequisites

1. Packer - http://packer.io

2. Vagrant - http://vagrantup.com

3. VirtualBox - http://virtualbox.org  (VMWare may work but was not tested)

4. Oracle Linux 7.1 ISO - https://edelivery.oracle.com/linux
   Download the OS installation files (and place in folder "iso"):
   - OracleLinux-R7-U0-Server-x86_64-dvd.iso 
   $ wget https://edelivery.oracle.com/osdc/download?fileName=V74844-01.iso&token=OTBpcVkyeHJVRVFjS0NzekNBdGEvQSE6OiF1c2VybmFtZT1FUEQtTEFTU0UuSkVOU1NFTkBFVlJZLkNPTSZ1c2VySWQ9NjUxNDkyNyZjYWxsZXI9U2VhcmNoU29mdHdhcmUmY291bnRyeUlkPU5PJmVtYWlsQWRkcmVzcz1sYXNzZS5qZW5zc2VuQGV2cnkuY29tJmZpbGVJZD03ODAzOTUzOCZhcnU9MTg2ODkzODgmYWdyZWVtZW50SWQ9NjI0MDI1JnNvZnR3YXJlQ2lkcz0xNDg3MzImcGxhdGZvcm1DaWRzPTYwJnByb2ZpbGVJbnN0YW5jZUNpZD0zMzcxOTImbWVkaWFDaWQ9MzM3MDY4
   $ mv V74844-01.iso iso/OracleLinux-R7-U0-Server-x86_64-dvd.iso

  - VBoxGuestAdditions.iso (find the right version for your VirtualBox installation)
  $ mv VBoxGuestAdditions-{current version}.iso iso/VBoxGuestAdditions.iso

5. Download the Oracle RDBMS installation files (and place in folder "database_installer/source")
   https://edelivery.oracle.com/akam/otn/linux/oracle12c/121020/linuxamd64_12102_database_1of2.zip
   https://edelivery.oracle.com/akam/otn/linux/oracle12c/121020/linuxamd64_12102_database_2of2.zip
   https://updates.oracle.com/Orion/Services/download/p21359755_121020_Linux-x86-64.zip?aru=19194568&patch_file=p21359755_121020_Linux-x86-64.zip

  $ mv linuxamd64_12102_database_1of2.zip database_installer/source/.
  $ mv linuxamd64_12102_database_2of2.zip database_installer/source/.
  $ mv p21359755_121020_Linux-x86-64.zip database_installer/source/.

## Build Instructions

1. Clone the repository

        $ git clone https://github.com/lasjen/oraclelinux-7.1-oracle12c.git
        $ cd oraclelinux-7.1-oracle12c

2. Install the prerequisites, make sure the packer and vagrant commands are in your PATH and callable from Terminal/Command Prompt

3. Place OracleLinux-R7-U0-Server-x86_64-dvd.iso and VBoxGuestAdditions.iso in the iso folder

4. Place Oracle RDBMS files in the "database_installer/source" folder 

5. Build the box

        $ sh buildbox.sh

5. Add the box ol7ora12c to vagrant

        $ sh importbox.sh

6. Test with vagrant

```
$ mkdir ol7-test
$ cd ol7-test
$ vagrant init ol7ora12c
$ vagrant up
$ vagrant ssh
```

Sample:

```
$ mkdir ol7-test

$ cd ol7-test

$ vagrant init ol7ora12c
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.

ek2046@ws-ek2046-lt:/data/vagrant_vms/ol7-test$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 => 2222 (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection timeout. Retrying...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => /data/vagrant_vms/ol7-test
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.
ek2046@ws-ek2046-lt:/data/vagrant_vms/ol7-test$ vagrant ssh
Last login: Sat Nov 14 01:52:39 2015 from 10.0.2.2

[vagrant@localhost ~]$ cat /etc/redhat-release
Red Hat Enterprise Linux Server release 7.1 (Maipo)
```
# oraclelinux-7.1-oracle12c
