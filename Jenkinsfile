pipeline {
    agent any

environment {
        TOMCAT_CONTAINER_NAME = 'tomcat-deployed'
        ARTIFACT_NAME = 'onlinebookstore.war'
        DOCKER_IMAGE_NAME = 'tomcat-deployed:v1'
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
                // Build your artifact here (e.g., compile, package)
                sh 'mvn clean package'  
            }
        }
        
        stage('Build Docker Image') {
            steps {
                     sh "cp target/${ARTIFACT_NAME} ${ARTIFACT_NAME}"
                //    sh "cp target/${ARTIFACT_NAME} docker-context/"
                // Build a Docker image containing the WAR file
                script {
                    docker.build(DOCKER_IMAGE_NAME, '-f Dockerfile .')
                }
            }
        }
        
        stage('Deploy to Tomcat Docker Container') {
            steps {
                // Run the Tomcat Docker container
                sh "docker run -d -p 8080:8080 --name ${TOMCAT_CONTAINER_NAME} ${DOCKER_IMAGE_NAME}"
                
                // Copy the WAR file into the running container
                sh "docker cp target/${ARTIFACT_NAME} ${TOMCAT_CONTAINER_NAME}:/usr/local/tomcat/webapps/"
            }
        }
    }
    /*---------------------    
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
   --------------------------*/     
    //    stage('SonarQube Analysis') {
      //      steps {
         //       withSonarQubeEnv('SonarQube') {
           //         sh 'mvn sonar:sonar'
             //   }
            //}
        //}
        
        stage('Publish to Artifactory - configure') {
            steps {
                rtMavenDeployer(
                    id: 'Jfrog', 
                    serverId: 'Jfrog', 
                    releaseRepo: 'example-repo-local/', 
                    snapshotRepo: 'example-repo-local/'
                )
            }
        }
        stage('Upload the artifact'){
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
        
        /*
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
        */

        /*

        stages {
        stage('Build Docker image') {
           steps {
                script {
                  def dockerImage = docker.build("${ARTIFACT_NAME}:${env.BUILD_NUMBER}", "-f Dockerfile .")
                    sh "docker save -o ${ARTIFACT_NAME}_${env.BUILD_NUMBER}.tar ${ARTIFACT_NAME}:${env.BUILD_NUMBER}"
                    
                    //  def dockerImage = docker.build("${ARTIFACT_NAME}:${env.BUILD_NUMBER}", "-f Dockerfile .")
                   // sh "docker -H=${DOCKER_SERVER} save -o ${ARTIFACT_NAME}_${env.BUILD_NUMBER}.tar ${ARTIFACT_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
            stage('Deploy to Tomcat Container') {
            steps {
                script {
                      docker.image(TOMCAT_IMAGE_NAME).run("-d --name ${TOMCAT_CONTAINER_NAME} -p 8080:8080 -v ${PWD}/${ARTIFACT_NAME}.war:/usr/local/tomcat/webapps/${ARTIFACT_NAME}.war")
                    //sh "docker -H=${DOCKER_SERVER} run -d --name ${TOMCAT_CONTAINER_NAME} -p 8080:8080 -v ${PWD}/${ARTIFACT_NAME}.war:/usr/local/tomcat/webapps/${ARTIFACT_NAME}.war ${TOMCAT_IMAGE_NAME}"
                }
            }
        }
        */
        
  

        }
    
