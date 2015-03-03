wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo add-apt-repository ppa:alexx2000/doublecmd
sudo add-apt-repository ppa:chris-lea/node.js
sudo add-apt-repository ppa:webupd8team/sublime-text-3

wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
sudo add-apt-repository "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main"

sudo sh -c "echo 'deb http://archive.canonical.com/ubuntu/ trusty partner' >> /etc/apt/sources.list.d/canonical_partner.list"

sudo echo "deb http://downloads.hipchat.com/linux/apt stable main" > \
  /etc/apt/sources.list.d/atlassian-hipchat.list
wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -

sudo apt-get update
sudo apt-get install git git-cola google-chrome-stable skype nodejs sublime-text-installer mongodb elasticsearch redis-server


# Configure Elasticsearch to automatically start during bootup :
sudo update-rc.d elasticsearch defaults 95 10


#docker ubuntu 14.10
#sudo addgroup mihai docker
#sudo su - mihai
#sudo service docker restart 


# npm 
#sudo npm install -g bower grunt-cli


#sudo apt-get install libxml2 libxslt1.1 libxml2-dev libxslt1-dev python-libxml2 python-libxslt1 python-dev python-setuptools