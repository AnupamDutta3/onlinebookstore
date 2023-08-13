pipeline {
    agent any

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
                    releaseRepo: 'libs-release-local', 
                    snapshotRepo: 'libs-snapshot-local'
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
    }
    
}
