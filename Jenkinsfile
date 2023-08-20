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
                sh 'mvn clean install'
            }
        }
        
    //    stage('SonarQube Analysis') {
      //      steps {
         //       withSonarQubeEnv('SonarQube') {
           //         sh 'mvn sonar:sonar'
             //   }
            //}
        //}
        
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
 stage('Build') {
            steps {
                // Build your artifact here (e.g., compile, package)
                sh 'mvn clean package'  // Assuming Maven is used for building
            }
        }
        
        stage('Build Docker Image') {
            steps {
                    sh "cp target/${ARTIFACT_NAME} docker-context/"
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

        }
    }
    
