yum install nginx -y
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

cp /configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
systemctl enable nginx
systemctl restart nginx

# Roboshop Config is not copied - It is done in the config file adding the DNS records from route 53
# If any command is failed in middle, we need to stop the script(by default it will proceed to the next command)
