FROM jboss/base-jdk:8

ENV KEYCLOAK_VERSION 3.1.0.Final
ENV KEYCLOAK_PACKAGE keycloak-3.1.0.Final.zip
 
# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
USER root

RUN yum install -y epel-release && yum install -y jq && yum clean all

USER jboss

ADD $KEYCLOAK_PACKAGE /opt/jboss/

RUN cd /opt/jboss/ && unzip /opt/jboss/$KEYCLOAK_PACKAGE

ADD docker-entrypoint.sh /opt/jboss/

ADD setLogLevel.xsl /opt/jboss/keycloak-$KEYCLOAK_VERSION/
RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak-$KEYCLOAK_VERSION/standalone/configuration/standalone.xml -xsl:/opt/jboss/keycloak-$KEYCLOAK_VERSION/setLogLevel.xsl -o:/opt/jboss/keycloak-$KEYCLOAK_VERSION/standalone/configuration/standalone.xml

ENV JBOSS_HOME /opt/jboss/keycloak-$KEYCLOAK_VERSION

#Enabling Proxy address forwarding so we can correctly handle SSL termination in front ends
#such as an OpenShift Router or Apache Proxy
RUN sed -i -e 's/<http-listener /& proxy-address-forwarding="${env.PROXY_ADDRESS_FORWARDING}" /' $JBOSS_HOME/standalone/configuration/standalone.xml

EXPOSE 8080
EXPOSE 9990

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD ["-Djboss.bind.address=0.0.0.0", "-Djboss.bind.address.management=0.0.0.0"]
