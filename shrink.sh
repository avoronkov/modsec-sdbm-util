#!/bin/bash
set -e

# Add root crontask the following way:
# # crontab -e
# 15 * * * * /path/to/shrink.sh > /dev/null 2>&1

if [ "$1" = '-h' -o "$1" = '--help' ]; then
	echo "Usage: $0 [ <sdbm_util_path> [ <modsec_cache_dir> ] ]"
	echo "Defaults:"
	echo "    sdbm_util_path = /root/modsec-sdbm-util-master/modsec-sdbm-util"
	echo "    modsec_cache_dir = /var/cache/modsecurity"
	exit 0
fi

basedir="$(dirname $0)"
sdbm_util="${1:-$basedir/modsec-sdbm-util}"
cached="${2:-/var/cache/modsecurity}"

rm -f $cached/test.dir $cached/test.pag
"$sdbm_util" -k $cached/ip -n -N $cached/test -o
for ext in dir pag; do
        chown `stat -c '%U:%G' $cached/ip.$ext` $cached/test.$ext
        chmod 0640 $cached/test.$ext
        mv -f $cached/test.$ext $cached/ip.$ext
done
