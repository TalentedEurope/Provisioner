#! /usr/bin/env bash
# Loosely based on https://github.com/andrewhood125/do-debian-setup, 
# but making the provision install the packages instead of the project

# What it does

# Update
# Upgrade
# Install dependencies (PHP/Mariadb/Redis/Beanstalkd)
# Add sudo user deploy with password "password"
# Create a beta user without configured acess / setup if needed
# Expire deploys password so it must be reset on first login
# Copy roots authorized_keys to deploy
# Disables root from logging in directly

# Usage
# run this as bash setup.sh IP_ADDR

if [[ "${1}x" == "x" ]] ; then
  echo -e "\nSYNOPSIS"
  echo -e "\tsetup.sh [IP_ADDR | HOST_NAME]"
  exit 1
fi

ssh root@$1 'bash -s' < provision.sh

echo -e "\n\tYou may now login to $1 as deploy"
echo -e "\tyou must set your password on first login.\n"
echo -e "\t\tDefault password is \"password\"\n"
echo -e "\tssh deploy@$1"