# Tips

### MariaDB
After a fresh install, you might want to run

```Shell
rm -rf /var/lib/mysql
sudo mysql_install_db
sudo mysqladmin -u root -p "new_password"
```

to install mysql databases and set root password.
