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
         stage('Build Docker Image and Run Container') {
            steps {
                script {
                    def DOCKER_IMAGE_NAME = 'my-custom-tomcat'
                    def DOCKERFILE_PATH = 'Dockerfile' // Path to your Dockerfile
                    
                    // Build the Docker image
                    def dockerImage = docker.build(DOCKER_IMAGE_NAME, "-f ${DOCKERFILE_PATH} .")

                    // Run the Docker container
                    def TOMCAT_CONTAINER_NAME = 'my-tomcat-container'
                    def ARTIFACT_NAME = 'my-app' // Adjust this to match your application's name

                    dockerImage.run("-d --name ${TOMCAT_CONTAINER_NAME} -p 8080:8080")
                }
            }
        }
    }
        }
