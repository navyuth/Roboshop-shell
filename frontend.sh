source common.sh

print_head "Installing nginx"
yum install nginx -y &>>${log_file}
status check $?

print_head "Removing the old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status check $?

print_head "Downloading frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status check $?

print_head "Extracting downloaded frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
status check $?

print_head "Copying Nginx Config for Roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status check $?

print_head "Enabling nginx service"
systemctl enable nginx &>>${log_file}
status check $?

print_head "Starting Nginx service"
systemctl restart nginx &>>${log_file}
status check $?

# Roboshop Config is not copied - It is done
# If any command is failed in middle, we need to stop the script(by default it will proceed to the next command)
# Status of the command need to be printed

