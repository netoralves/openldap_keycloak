#!/bin/bash
# INGRAM MICRO
# AUTHOR: FRANCISCO NETO
# EMAIL: francisco.neto@ingrammicro.com

# see https://github.com/docker/docker/issues/8231
ulimit -n 1024

OPENLDAP_ROOT_PASSWORD=${OPENLDAP_ROOT_PASSWORD:-'admin'}
OPENLDAP_ROOT_DN_PREFIX=${OPENLDAP_ROOT_DN_PREFIX:-'admin'}
OPENLDAP_ROOT_DN_SUFFIX=${OPENLDAP_ROOT_DN_SUFFIX:-'caixa.gov.br'}
OPENLDAP_DEBUG_LEVEL=${OPENLDAP_DEBUG_LEVEL:-'256'}

DOM1=$( echo $OPENLDAP_ROOT_DN_SUFFIX | cut -f1 -d'.' )
DOM2=$( echo $OPENLDAP_ROOT_DN_SUFFIX | cut -f2 -d'.' )
DOM3=$( echo $OPENLDAP_ROOT_DN_SUFFIX | cut -f3 -d'.' )

OPENLDAP_ROOT_PASSWORD_HASH=$(slappasswd -s "${OPENLDAP_ROOT_PASSWORD}")

# Update / Execute db.ldif
sed -e "s DOM1 ${DOM1} g" \
	-e "s DOM2 ${DOM2} g" \
	-e "s DOM3 ${DOM3} g" \
	-e "s OPENLDAP_ROOT_DN_PREFIX ${OPENLDAP_ROOT_DN_PREFIX} g" \
	-e "s OPENLDAP_ROOT_PASSWORD_HASH ${OPENLDAP_ROOT_PASSWORD_HASH} g" /usr/local/etc/openldap/admin/db.ldif | ldapmodify -Y EXTERNAL -H ldapi:/// -d $OPENLDAP_DEBUG_LEVEL
	sleep 1
	echo "========================"
	echo "script db.ldif executado"
	echo "========================"
	cat /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
	echo "=========================================================="

# Generate cert and key .pem without interaction and change owner
#openssl req -new -x509 -nodes -out /etc/openldap/certs/ldapcert.pem -keyout /etc/openldap/certs/ldapkey.pem -days 365 -batch
	chown -R ldap:ldap /etc/openldap/certs/*.pem

# Execute certs.ldif
	ldapmodify -Y EXTERNAL -H ldapi:/// -d $OPENLDAP_DEBUG_LEVEL -f /usr/local/etc/openldap/admin/certs.ldif 
	sleep 1
	echo "==========================="
	echo "script certs.ldif executado"
	echo "==========================="
	cat /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
	echo "========================================================="

# Update monitor.ldif
	sed -e "s DOM1 ${DOM1} g" \
		-e "s DOM2 ${DOM2} g" \
		-e "s DOM3 ${DOM3} g" \
		-e "s OPENLDAP_ROOT_DN_PREFIX ${OPENLDAP_ROOT_DN_PREFIX} g" /usr/local/etc/openldap/admin/monitor.ldif | ldapmodify -Y EXTERNAL -H ldapi:/// -d $OPENLDAP_DEBUG_LEVEL
	sleep 1
	echo "============================="
	echo "script monitor.ldif executado"
	echo "============================="
	cat /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{1\}monitor.ldif
	echo "============================================================="

	chown -R ldap:ldap /var/lib/ldap/*
	# Import Custom schema and ldif files
	#cp -Rpvf /usr/local/etc/openldap/*.ldif /etc/openldap/schema/
	#cp -Rpvf /usr/local/etc/openldap/*.schema /etc/openldap/schema/

	chmod +x -R /etc/openldap/schema/*
	echo "cosine.ldif"
	ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
	echo "nis.ldif"
	ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
	echo "inetorperson.ldif"
	ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
	echo "cef.ldif"
	ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cef.ldif

# Update base.ldif
	sed -e "s DOM1 ${DOM1} g" \
		-e "s DOM2 ${DOM2} g" \
		-e "s DOM3 ${DOM3} g" \
		-e "s OPENLDAP_ROOT_DN_PREFIX ${OPENLDAP_ROOT_DN_PREFIX} g" /usr/local/etc/openldap/admin/base.ldif | ldapadd -x -w ${OPENLDAP_ROOT_PASSWORD} -D "cn=${OPENLDAP_ROOT_DN_PREFIX},dc=${DOM1},dc=${DOM2},dc=${DOM3}"
	sleep 1
	echo "=========================="
	echo "script base.ldif executado"
	echo "=========================="

    # Test configuration files, log checksum errors. Errors may be tolerated and repaired by slapd so don't exit
    LOG=`slaptest 2>&1`
    CHECKSUM_ERR=$(echo "${LOG}" | grep -Po "(?<=ldif_read_file: checksum error on \").+(?=\")")
    for err in $CHECKSUM_ERR
    do
        echo "The file ${err} has a checksum error. Ensure that this file is not edited manually, or re-calculate the checksum."
    done

    touch /etc/openldap/CONFIGURED

    # Start the slapd service
    # exec slapd -h "ldap:/// ldaps:///" -d $OPENLDAP_DEBUG_LEVEL
