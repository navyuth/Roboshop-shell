source common.sh

print_head "Setup MongoDB repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install MongoDB"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check $?

print_head "Enable MongoDB service"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "Start MongoDB service"
systemctl restart mongod &>>${log_file}
status_check $?

# update /etc/mongod.conf file 127.0.0.1 with 0.0.0.0