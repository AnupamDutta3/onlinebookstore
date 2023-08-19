pipeline {
    agent any
  
//environment {
     //   DOCKER_SERVER = 'http://52.87.35.78:2375/' // Replace with your remote Docker server address
    //    TOMCAT_CONTAINER_NAME = 'my-tomcat-container'
    //    TOMCAT_IMAGE_NAME = 'tomcat:9' // Change to the appropriate Tomcat image
   //     ARTIFACT_NAME = 'onlinebookstore' // Replace with your artifact name
 //   }
//    triggers {
//        githubPush()
//    }
  /*
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
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def DOCKER_IMAGE_NAME = 'onlinebookstore:v1'
                    def DOCKERFILE_PATH = '/' // Path to your Dockerfile
                    
                    // Build the Docker image
                    def dockerImage = docker.build(DOCKER_IMAGE_NAME, "-f ${DOCKERFILE_PATH} .")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    def TOMCAT_IMAGE_NAME = 'tomcat:9'
                    def TOMCAT_CONTAINER_NAME = 'my-tomcat-container'
                    def ARTIFACT_NAME = 'onlinebookstore'
                    
                    // Remove the existing container if it exists
                    try {
                        docker.image(TOMCAT_IMAGE_NAME).withRun("-d --name ${TOMCAT_CONTAINER_NAME} -p 8080:8080") { c ->
                            // Copy the artifact to the Tomcat container
                            c.copyFile("${ARTIFACT_NAME}.war", "/usr/local/tomcat/webapps/${ARTIFACT_NAME}.war")
                        }
                    } catch (Exception e) {
                        echo "Container ${TOMCAT_CONTAINER_NAME} does not exist. Creating a new one."
                        docker.image(TOMCAT_IMAGE_NAME).run("-d --name ${TOMCAT_CONTAINER_NAME} -p 8080:8080")
                    }
                }
            }
        }
        }
        }
