# openldap_keycloak
Docker Container for development environment with Keycloak + OpenLDAP.

# About
This project is a custom dev environment, to capacite developers to use SSO in owner apps and learn about new default environment.

#Usage

To execute this Container you need to know all variebles:

OPENLDAP_ROOT_PASSWORD="admin"
OPENLDAP_ROOT_DN_PREFIX="admin"
OPENLDAP_DEBUG_LEVEL="256"
OPENLDAP_CONTAINER_NAME="ldap"
OPENLDAP_ROOT_DN_SUFFIX="example.com.br"
OPENLDAP_CONTAINER_HOSTNAME="ldap.example.com.br"
SRC_PORT1="389"
DST_PORT1="389"
SRC_PORT2="636"
DST_PORT2="636"
VERSION_C_OPENLDAP="1.0"

# Building Images:

To build image of container:

docker build . -t netoralves/openldap:${VERSION_C_OPENLDAP}

# Provisioning LDAP Container

docker run -e OPENLDAP_ROOT_PASSWORD="${OPENLDAP_ROOT_PASSWORD}" -e OPENLDAP_ROOT_DN_PREFIX="${OPENLDAP_ROOT_DN_PREFIX}" -e OPENLDAP_DEBUG_LEVEL="${OPENLDAP_DEBUG_LEVEL}" -e OPENLDAP_ROOT_DN_SUFFIX="${OPENLDAP_ROOT_DN_SUFFIX}" -d --name "${OPENLDAP_CONTAINER_NAME}" --hostname "${OPENLDAP_CONTAINER_HOSTNAME}" -p $SRC_PORT1:$DST_PORT1 -p $SRC_PORT2:$DST_PORT2 netoralves/openldap:$VERSION_C_OPENLDAP
