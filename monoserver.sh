#!/bin/sh

### BEGIN INIT INFO
# http://yojimbo87.github.io/2010/03/14/mono-startup-script.html
# Provides:          monoserve.sh
# Required-Start:    $local_fs $syslog $remote_fs
# Required-Stop:     $local_fs $syslog $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start fastcgi mono server with hosts
### END INIT INFO


PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/bin/mono
NAME=monoserver
DESC=monoserver

MONOSERVER=$(which fastcgi-mono-server4)
MONOSERVER_PID=$(ps auxf | grep fastcgi-mono-server4.exe | grep -v grep | awk '{print $2}')

#WEBAPPS="/:/var/www/html/"
WEBAPPS="/:."
ROOT="/var/www/html"

case "$1" in
        start)
                if [ -z "${MONOSERVER_PID}" ]; then
                        echo "starting mono server"
                        ${MONOSERVER} /printlog=True /applications=${WEBAPPS} /root=${ROOT} /socket=tcp:127.0.0.1:9001 /loglevels=All /logfile=/var/log/mono/fastcgi.log
                        echo "mono server started"
                else
                        echo ${WEBAPPS}
                        echo "mono server is running"
                fi
        ;;
        stop)
                if [ -n "${MONOSERVER_PID}" ]; then
                        kill ${MONOSERVER_PID}
                        echo "mono server stopped"
                else
                        echo "mono server is not running"
                fi
        ;;
esac

exit 0