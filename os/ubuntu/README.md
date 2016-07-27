# Tips

### MariaDB
After installation, you might want to secure your installation by running

```
mysql_secure_installation
```

If the default empty password is not accepted, you might have to run the following (see http://askubuntu.com/a/672016)

```
sudo mysql -u root
[mysql] use mysql;
[mysql] update user set plugin='' where User='root';
[mysql] flush privileges;
```
