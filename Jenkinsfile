pipeline {
    agent any
  
environment {
        DOCKER_SERVER = 'http://52.87.35.78:2375/' // Replace with your remote Docker server address
        TOMCAT_CONTAINER_NAME = 'my-tomcat-container'
        TOMCAT_IMAGE_NAME = 'tomcat:9' // Change to the appropriate Tomcat image
        ARTIFACT_NAME = 'onlinebookstore' // Replace with your artifact name
    }
  
     tools {
     
        maven 'maven'

    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
     /*
        stage('Publish to Artifactory') {
            steps {
                rtMavenDeployer(
                    id: 'Jfrog', 
                    serverId: 'Jfrog', 
                    releaseRepo: 'example-repo-local/', 
                    snapshotRepo: 'example-repo-local/'
                )
            }
        }
        stage('Upload'){
            steps{
                rtUpload (
                 serverId:"Jfrog",
                  spec: '''{
                   "files": [
                      {
                      "pattern": "*.war",
                      "target": "example-repo-local/"
                      }
                            ]
                           }''',
                        )
            }
        }
        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "Jfrog"
                )
            }
        }
        stage('Code Coverage and SonarQube Analysis') {
            steps {
                // Set up Jacoco for code coverage
                sh 'mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent test'
                // This assumes you are using Maven. If you are using a different build tool,
                // replace the command accordingly.
                
                // Generate code coverage report
                sh 'mvn org.jacoco:jacoco-maven-plugin:report'
                
                // Publish code coverage results to SonarQube
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=onlinebookstore:onlinebookstore'
                }
            }
        }
        */
        stage('Build Docker image') {
           steps {
                script {
                    def dockerImage = docker.build("${ARTIFACT_NAME}:${env.BUILD_NUMBER}", "-f Dockerfile .")
                    sh "docker -H=${DOCKER_SERVER} save -o ${ARTIFACT_NAME}_${env.BUILD_NUMBER}.tar ${ARTIFACT_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
            stage('Deploy to Tomcat Container') {
            steps {
                script {
                    sh "docker -H=${DOCKER_SERVER} run -d --name ${TOMCAT_CONTAINER_NAME} -p 8080:8080 -v ${PWD}/${ARTIFACT_NAME}.war:/usr/local/tomcat/webapps/${ARTIFACT_NAME}.war ${TOMCAT_IMAGE_NAME}"
                }
            }
        }
        }
    }
