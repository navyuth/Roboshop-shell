source common.sh

print_head "Configure NodeJs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install NodeJs"
yum install nodejs -y &>>${log_file}

print_head "Creating Roboshop user"
useradd roboshop &>>${log_file}

print_head "Create application directory"
mkdir /app &>>${log_file}

print_head "Delete old content"
rm -rf /app/* &>>${log_file}

print_head "Downloading App Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app

print_head "Extracting App content"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "Installing NodeJs dependencies"
npm install &>>${log_file}

print_head "Copying SystemD service file"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "Reload  SystemD"
systemctl daemon-reload &>>${log_file}

print_head "Enable Catalogue Service"
systemctl enable catalogue &>>${log_file}

print_head "Start Catalogue Service"
systemctl start catalogue &>>${log_file}

print_head "Copy MongoDB Repo File"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}

print_head "Load Schema"
mongo --host mongodb.devopscourse.online </app/schema/catalogue.js &>>${log_file}

