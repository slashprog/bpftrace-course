# Lab Environment Configurations

This directory has optional configurations for setting up your lab in different ways.

## Options

| File | What it does | When to use |
|------|--------------|-------------|
| `Vagrantfile` | Defines a Vagrant-based VM | You have Vagrant + VirtualBox installed |
| `packer/ubuntu-24-04-bpftrace.pkr.hcl` | Builds a cloud image with bpftrace pre-installed | You want a reusable VM image |
| `cloud-init/user-data.yml` | Cloud-init script for cloud VMs | You're using Oracle Cloud, AWS, etc. |

## Recommended path

For most students, **don't use any of these**. Instead, follow the manual setup in [`docs/setup.md`](../docs/setup.md) and use the included `scripts/setup-lab.sh`.

These configs are for:
- Instructors who want to pre-build lab images for cohorts
- Students who already use Vagrant in their workflow
- Teams deploying bpftrace-enabled images to a cloud environment

## Vagrant quick start

```bash
# Install Vagrant (https://www.vagrantup.com/)
# Then from the repo root:
vagrant up
vagrant ssh

# Inside the VM:
cd /vagrant
sudo ./scripts/verify-install.sh
```

## Packer quick start

```bash
# Install Packer (https://www.packer.io/)
cd lab-environment/packer
packer build ubuntu-24-04-bpftrace.pkr.hcl

# The output is a cloud image you can deploy anywhere
```
