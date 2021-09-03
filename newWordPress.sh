#!/bin/bash

echo "Quel est le nom du site internet à créer ?"
read name
unzip /home/alexandre/Bureau/www.zip -d /var/www/${name}
sudo setfacl -Rm u:alexandre:rwx,d:u:alexandre:rwx /var/www/${name}
sudo chown -R www-data: /var/www/${name}
sudo touch /etc/apache2/sites-available/${name}.conf
echo "<VirtualHost *:80>
        ServerName ${name}
        DocumentRoot /var/www/${name}
        <Directory /var/www/${name}>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>" > /home/alexandre/${name}.conf
sudo mv /home/alexandre/${name}.conf /etc/apache2/sites-available/${name}.conf
ligne=$(sed -n '/# The following lines are desirable for IPv6 capable hosts/=' /etc/hosts)
let ligne--
sudo sed -i "${ligne}i\127.0.0.1\t${name}" /etc/hosts
sudo a2ensite ${name}.conf
sudo systemctl reload apache2
