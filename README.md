# openldap_keycloak
Docker Container for development environment with OpenLDAP + Keycloak..

# ABOUT
This project is a custom dev environment, to capacite developers to use keycloak in owner apps and learn about new default environment.

# USAGE ON THE FIRST TIME
# ACCESS THE PATH OF SCRIPTS
cd ./openldap_keycloak/script_start/

# IN VM WITH INTERNET ACCESS AND DOCKER ENGINE INSTALLED
# EXECUTE FIRST SCRIPT TO PROVISIONING IMAGE/CONTAINER OF OPENLDAP SERVICE
./01_provisioning_openldap.sh

# EXECUTE SECOND SCRIPT TO PROVISIONING IMAGE/CONTAINER OF KEYCLOAK SERVER
./02_provisioning_keycloak.sh

# THE APPLICATION SERVER RUN IN FIRST PLAN. PRESS <CTRL>+c TO STOP.

# EXECUTE SCRIPT TO START ALL CONTAINER ENVIRONMENTS (CONTAINER KEYCLOAK STOPPED)
./script_start.sh
