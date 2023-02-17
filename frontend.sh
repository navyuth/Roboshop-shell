code_dir=$(pwd)
echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y

echo -e "\e[35mRemoving the old content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35mDownloading frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35mExtracting downloaded frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35mCopying Nginx Config for Roboshop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35mEnabling nginx service\e[0m"
systemctl enable nginx

echo -e "\e[35mStarting Nginx service\e[0m"
systemctl restart nginx

# Roboshop Config is not copied - It is done in the config file adding the DNS records from route 53
# If any command is failed in middle, we need to stop the script(by default it will proceed to the next command)
