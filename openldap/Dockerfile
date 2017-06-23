FROM centos:centos7

# Volumes:
# * /var/lib/ldap/data - Datastore for OpenLDAP
# * /etc/openldap/     - Config directory for slapd
# Environment:
# * $OPENLDAP_ADMIN_PASSWORD         - OpenLDAP administrator password
# * $OPENLDAP_DEBUG_LEVEL (Optional) - OpenLDAP debugging level, defaults to 256

MAINTAINER Francisco Neto <netoralves@gmail.com>

# Add startup scripts
COPY run-*.sh /usr/local/bin/
COPY admin/*.ldif /usr/local/etc/openldap/admin/

# Install OpenLDAP Server, give it permissionst to bind to low ports
RUN yum install -y openldap openldap-servers openldap-clients migrationtools && \
    yum clean all -y && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/slapd && \
    mkdir -p /var/lib/ldap && \
    chmod a+rwx -R /var/lib/ldap && \
    mkdir -p /etc/openldap && \
    chmod a+rwx -R /etc/openldap && \
    mkdir -p /var/run/openldap && \
    chmod a+rwx -R /var/run/openldap

# Add Custom Config
COPY config/certs/*.pem /etc/openldap/certs/
COPY populate_base.sh	/usr/local/bin/

# Set OpenLDAP data and config directories in a data volume
VOLUME ["/var/lib/ldap", "/etc/openldap"]

# Expose default ports for ldap and ldaps
EXPOSE 389 636

CMD ["/usr/local/bin/run-openldap.sh"]
