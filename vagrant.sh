apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 2> /dev/null

echo "deb http://repo.mongodb.org/apt/ubuntu precise/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# Make sure we're using the latest version of the repos
apt-get update

apt-get install -y nodejs 2> /dev/null

apt-get install -y memcached libmemcached-tools 2> /dev/null

#apt-get install -y mongodb-clients mongodb-dev mongodb-server 2> /dev/null
sudo apt-get install -y mongodb-org 2> /dev/null

# Make sure we're in the right folder
cd /vagrant

# Run additional commands as the vagrant user
su -c "source /vagrant/user.sh" vagrant