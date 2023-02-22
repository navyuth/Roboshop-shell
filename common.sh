code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[36m$1\e[0m"
}

status_check() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    echo "Read the log file ${log_file} for more information about the error"
    exit 1
  fi
}

app_prereq_setup() {

      print_head "Creating Roboshop user"
      id roboshop &>>${log_file}
      if [ $? -ne 0 ]; then
       useradd roboshop &>>${log_file}
      fi
      status_check $?

      print_head "Create application directory"
      if [ ! -d /app ]; then
        mkdir /app &>>${log_file}
      fi
      status_check $?

      print_head "Delete old content"
      rm -rf /app/* &>>${log_file}
      status_check $?

      print_head "Downloading App Content"
      curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
      cd /app
      status_check $?

      print_head "Extracting App content"
      unzip /tmp/${component}.zip &>>${log_file}
      status_check $?
}
systemd.setup() {

      print_head "Copying SystemD service file"
      cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
      status_check $?

      print_head "Reload  SystemD"
      systemctl daemon-reload &>>${log_file}
      status_check $?

      print_head "Enable ${component} Service"
      systemctl enable ${component} &>>${log_file}
      status_check $?

      print_head "Restart ${component} Service"
      systemctl restart ${component} &>>${log_file}
      status_check $?
}

schema_setup() {
  
  if [ "${schema_type}" == "mongo" ]; then

      print_head "Copy MongoDB Repo File"
      cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
      status_check $?

      print_head "Install Mongo Client"
      yum install mongodb-org-shell -y &>>${log_file}
      status_check $?

      print_head "Load Schema"
      mongo --host mongodb.devopscourse.online </app/schema/${component}.js &>>${log_file}
      status_check $?

  elif [ "${schema_type}" == "mysql" ]; then
    print_head "Install MySQL Client"
    yum install mysql -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mysql -h mysql.devopscourse.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
    status_check $?

  fi
}

nodejs() {

    print_head "Configure NodeJs Repo"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
    status_check $?

    print_head "Install NodeJs"
    yum install nodejs -y &>>${log_file}
    status_check $?

    app_prereq_setup

    print_head "Installing NodeJs dependencies"
    npm install &>>${log_file}
    status_check $?

    schema_setup
    systemd+setup
}

java() {

  print_head "Install Mavem"
  yum install maven -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Download Dependencies and package"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  status_check $?

  # Schema setup function
  schema_setup
  # SystemD setup function
  systemd_setup

}
