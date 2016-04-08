FROM tomcat:8.0.23
COPY target/petclinic.war /usr/local/tomcat/webapps/
