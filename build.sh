if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` {boxname}"
  exit 1
fi

echo "starting $1 for first time without provision to set hostname"
vagrant destroy $1 -f
vagrant up $1 --provision
echo "rebooting $1 for provisioning, join windomain"
vagrant reload $1 --provision
echo "rebooting $1 to finalize provisioning"
vagrant reload $1 --provision
