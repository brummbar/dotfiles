#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

	declare -r PHPINI="$(php --ini | grep Loaded | sed 's|^[^/]*\(.*php\.ini\)$|\1|')"

	# Configure php.ini
	if [ -f $PHPINI ]; then

		sed -i ".orig" \
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

	print_info "Follow README instructions in os/os_x folder for additional steps to complete"

	# Restart apache
	execute "apachectl -k restart" "Restart Apache"

}

main
