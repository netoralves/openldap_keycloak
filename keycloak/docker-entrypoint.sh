#!/bin/bash
# AUTHOR: FRANCISCO NETO
# EMAIL: netoralves@gmail.com

if [ $KEYCLOAK_USER ] && [ $KEYCLOAK_PASSWORD ]; then
    $JBOSS_HOME/bin/add-user-keycloak.sh --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
fi

if [ $JBOSS_USER ] && [ $JBOSS_PASSWORD ]; then
    $JBOSS_HOME/bin/add-user.sh --user $JBOSS_USER --password $JBOSS_PASSWORD
fi

exec $JBOSS_HOME/bin/standalone.sh $@
exit $?
