#!/bin/bash

# check if work is already done by checking if some sentinel dot.file exists in /var/www/html
# if it doesn't then
# .htaccess mod, put plugins and themes in place
# then touch the sentinel dotfile

# plugins I think I will want: ssl redirect thing, total cache, updraft plus premium...
#   check the current prod server, and also wpdev-round2
#   keep in mind that the restore from updraft plus will put many things in place

# invoke apache2-foreground
