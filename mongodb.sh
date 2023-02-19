source common.sh

print_head "Setup MongoDB repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Install MongoDB"
yum install mongodb-org -y &>>${log_file}

print_head "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

print_head "Enable MongoDB service"
systemctl enable mongod &>>${log_file}

print_head "Start MongoDB service"
systemctl start mongod &>>${log_file}

# update /etc/mongod.conf file 127.0.0.1 with 0.0.0.0