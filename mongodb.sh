
cp /configs/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

# update /etc/mongod.conf file 127.0.0.1 with 0.0.0.0