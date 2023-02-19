code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[36m$1\e[0m"
}

print_head "Installing nginx"
yum install nginx -y &>>${log_file}

print_head "Removing the old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Extracting downloaded frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying Nginx Config for Roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "Enabling nginx service"
systemctl enable nginx &>>${log_file}

print_head "Starting Nginx service"
systemctl restart nginx &>>${log_file}

# Roboshop Config is not copied - It is done
# If any command is failed in middle, we need to stop the script(by default it will proceed to the next command)
