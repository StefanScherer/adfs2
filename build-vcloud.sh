if [ $# -lt 1 ]
then
  echo "Usage: `basename $0` {boxname} [--provider=vcloud]"
  exit 1
fi

echo "rebooting $1 for provisioning, join windomain"
vagrant destroy $1 -f
vagrant up $1 --provider=vcloud
echo "rebooting $1 to finalize provisioning"
vagrant reload $1
vagrant provision $1
