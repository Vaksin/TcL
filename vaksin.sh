#!/bin/sh
[ "$(ls -A /home/vaksin/public_html/)" ] && rm -rf /home/vaksin/public_html/*.* || echo "empty"

exit 0 
}
