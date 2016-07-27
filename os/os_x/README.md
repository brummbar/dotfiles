# Manual steps

You need to manually insert the configuration to load the wanted version of PHP in Apache.
You can get the code to add by running `brew info php56` and copying it from the Caveats section.

Edit then the Apache configuration file (usually `/etc/apache2/httpd.conf`) to:
* uncomment the mod_rewrite line
```Shell
#LoadModule rewrite_module libexec/apache2/mod_rewrite.so
```
* comment out the shipped PHP line
```Shell
LoadModule php5_module libexec/apache2/libphp5.so
```
* paste the code you copied before (I recommend to put it at the end of the default LoadModule lines)
