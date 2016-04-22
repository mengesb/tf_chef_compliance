#!/usr/bin/env bash
sudo rm -rf /var/chef/cookbooks
sudo mkdir -p /var/chef/cookbooks
for DEP in chef-ingredient chef-compliance ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
sudo chown -R root:root /var/chef/cookbooks
echo Finished

