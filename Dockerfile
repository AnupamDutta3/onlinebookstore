FROM ubuntu:23.04
RUN apt update
RUN apt install openjdk-17-jre -y
RUN apt install maven -y
RUN apt install openssh-server -y
RUN apt install git -y
RUN git clone https://github.com/AnupamDutta3/onlinebookstore.git
WORKDIR /onlinebookstore
RUN mvn clean install
