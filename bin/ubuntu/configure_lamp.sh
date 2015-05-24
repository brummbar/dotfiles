#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

	declare -r PHPINI="/etc/php5/apache2/php.ini"

	# Configure php.ini
	if [ -f $PHPINI ]; then

		# Create a backup first
		execute "cp $PHPINI $PHPINI.orig" "Backup $PHPINI → $PHPINI.orig" "true"

		sed -i \
			-e "s/^\(display_errors = \)Off/\1On/" \
			-e "s/^\(display_startup_errors = \)Off/\1On/" \
			-e "s/^\(html_errors = \)Off/\1On/" \
			-e "s/^\(max_execution_time = \)[0-9][0-9]*/\1300/" \
			-e "s/^\(memory_limit = \)[0-9][0-9]*M/\1512M/" \
			-e "s/^\(upload_max_filesize = \)[0-9][0-9]*M/\164M/" \
			-e "s/^\(post_max_size = \)[0-9][0-9]*M/\164M/" \
			-e "s/^;\(date.timezone =\)$/\1 \"Europe\/Rome\"/" \
			$PHPINI &> /dev/null
		print_result $? "Configure $PHPINI"
	fi

	# Enable mod_rewrite
	execute "a2enmod rewrite" "mod_rewrite enabled"

	# Restart apache
	execute "service apache2 restart" "Restart Apache"

}

main
