#!/bin/bash
# user data is a script that runs once when the EC2 instance launches
# Install httpd 
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# To embed the content of index.html file to the user data
cat <<EOT > /var/www/html/index.html
${htmlPage}
EOT
