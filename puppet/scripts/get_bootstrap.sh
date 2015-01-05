#!/usr/bin/env bash
set -e
wget -O ./bootstrap.sh https://raw.githubusercontent.com/flavio-fernandes/puppet-bootstrap/master/centos_7_x.sh
chmod 755 ./bootstrap.sh

echo "puppet module install puppetlabs-stdlib" >> ./bootstrap.sh

