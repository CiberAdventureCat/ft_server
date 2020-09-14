#!/bin/bash

# config nginx
#mv ./nginx.conf /etc/nginx/
#mkdir /var/www/server
#chown -R $USER:$USER /var/www/server
mv /var/www/server/your_domain /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=RU/ST=Moscow/L=Moscow/O=School21/CN=kbatwoma"

# start
service nginx start
service php7.3-fpm start 

# mysql
service mysql start
#mysql -u root --skip-password CREATE DATABASE wordpress;
#mysql -u root --skip-password GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;
#mysql -u root --skip-password UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user='root';
#mysql -u root --skip-password FLUSH PRIVILEGES;
#mysql wordpress -u root < /root/wordpress.sql
mysql -e "CREATE USER 'kbatwoma'@'localhost' IDENTIFIED BY 'root';"
mysql -e "CREATE DATABASE ft_server_database;"
mysql -e "GRANT ALL ON *.* TO 'kbatwoma'@'localhost' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"

# phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar xzf phpMyAdmin-4.9.0.1-all-languages.tar.gz
mv phpMyAdmin-4.9.0.1-all-languages /var/www/server/phpMyAdmin
rm phpMyAdmin-4.9.0.1-all-languages.tar.gz

# wordpress
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
#mv wordpress /var/www/server
rm latest.tar.gz
#mv wp-config.php /var/www/server

#wordpress
wpurl="localhost"
wptitle="ft_server by kbatwoma"
wpemail="kbatwoma@student.21-school.ru"
wpuser="kbatwoma"
wppass="Visokoprevoschoditelstvo27."
curl -d "weblog_title=$wptitle&user_name=$wpuser&admin_password=$wppass&admin_password2=$wppass&admin_email=$wpemail" -k https://$wpurl/wp-admin/install.php?step=2  > /dev/null

# restart
service php7.3-fpm restart 
service nginx restart
service mysql restart

bash
