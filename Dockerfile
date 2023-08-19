FROM ubuntu:23.04 AS stage1
RUN apt update
RUN apt install openjdk-17-jre -y
RUN apt install maven -y
RUN apt install openssh-server -y
RUN apt install git -y
RUN git clone https://github.com/AnupamDutta3/onlinebookstore.git
WORKDIR /onlinebookstore
RUN mvn clean install

// FROM ubuntu:23.04 AS stage2
// WORKDIR /app/
// COPY --from=stage1 /onlinebookstore/target/onlinebookstore.war /app/

// FROM tomcat:9
// COPY --from=stage1 /onlinebookstore/target/onlinebookstore.war /usr/local/tomcat/webapps/
  // EXPOSE 8080
