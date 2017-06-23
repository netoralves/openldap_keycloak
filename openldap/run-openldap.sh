#!/bin/bash
# INGRAM MICRO
# AUTHOR: FRANCISCO NETO
# EMAIL: francisco.neto@ingrammicro.com

# see https://github.com/docker/docker/issues/8231
ulimit -n 1024

# Only run if no config has happened fully before

	# Start the daemon in another process and make config changes
	slapd -h "ldap:/// ldaps:/// ldapi:///" -d $OPENLDAP_DEBUG_LEVEL
	 for ((i=30; i>0; i--))
         do
            ping_result=`ldapsearch 2>&1 | grep "Can.t contact LDAP server"`
            if [ -z "$ping_result" ]
            then
                break
            fi
            sleep 1
        done
        if [ $i -eq 0 ]
        then
            echo "slapd did not start correctly"
            exit 1
        fi

echo "slapd did not stop correctly"
exit 1
