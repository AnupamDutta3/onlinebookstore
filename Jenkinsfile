pipeline{
    agent any

    stages{
       stage('Git Checkout'){
            steps{
                git branch: 'master', https://github.com/AnupamDutta3/simple-java-maven-app.git'
            }
         }        
       stage('Build'){
            steps{
                sh 'mvn clean install'
            }
         }
        stage('SonarQube analysis') {
			steps{
				withSonarQubeEnv('SonarQube') { 
					sh "mvn clean verify sonar:sonar -Dsonar.projectKey=OnlineBookStore  -Dsonar.projectName='OnlineBookStore "
				}
			}
        }
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
                 serverId:"Jfrog" ,
                  spec: '''{
                   "files": [
                      {
                      "pattern": "*.war",
                      "target": "libs-release-local/"
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
    }
}
