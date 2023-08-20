FROM tomcat:9
COPY ${ARTIFACT_NAME} /usr/local/tomcat/webapps/
