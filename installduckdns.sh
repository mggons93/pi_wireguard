#!/bin/bash

ps -ef | grep cr[o]n

cd
mkdir duckdns
cd duckdns
sudo bash -c 'echo -e "#!/bin/sh\nTOKEN=\'Remplazar con el token\'\nDOMAINS=\'Remplazar con tu dominio\'\nHOST=\"www.duckdns.org\"\nPORT=\"80\"\n\n# MAKE THE REQUEST PATTERN - remove the Verbose if you want to\nURI=\$(echo /update?domains=\$DOMAINS\&token=\$TOKEN\&ip=\&verbose=true)\n\n# BUILD FULL HTTP REQUEST - note extra \ at the end to ignore editor and OS carraige returns\nHTTP_QUERY=\"GET \$URI HTTP/1.1\r\n\\Host: \$HOST\r\n\\Accept: text/html\r\n\\Connection: close\r\n\r\n\"\n\n# OUTPUT TO SCREEN - Nice for Debug\necho \"\$HTTP_QUERY\"\n(printf \"\$HTTP_QUERY\" && sleep 5) | nc \$HOST \$PORT" > ~/duckdns/duck.sh'

chmod 700 duck.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * ~/duckdns/duck.sh >/dev/null 2>&1") | crontab -
./duck.sh
