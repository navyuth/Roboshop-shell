source common.sh

print_head "Setup MongoDB repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "Install MongoDB"
yum install mongodb-org -y

print_head "Enable MongoDB service"
systemctl enable mongod

print_head "Start MongoDB service"
systemctl start mongod

# update /etc/mongod.conf file 127.0.0.1 with 0.0.0.0