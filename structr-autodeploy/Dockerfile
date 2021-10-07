FROM ubuntu
RUN apt-get update && apt-get install curl -y
ADD wait-for-url /usr/local/bin/wait-for-url.sh
ADD structr-autodeploy.sh /usr/local/bin/structr-autodeploy.sh
RUN chmod +x /usr/local/bin/wait-for-url.sh
RUN chmod 777 /usr/local/bin/wait-for-url.sh
RUN chmod +x /usr/local/bin/structr-autodeploy.sh
RUN chmod 777 /usr/local/bin/structr-autodeploy.sh
ARG HOST
ARG APP_ZIP_URL
ARG DATA_ZIP_URL
ARG STRUCTR_SUPERADMIN_PASSWORD
CMD ["/usr/local/bin/structr-autodeploy.sh"]
