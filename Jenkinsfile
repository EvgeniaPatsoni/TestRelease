pipeline {
   agent {
         docker {
            image 'eddevopsd2/maven-java-npm-docker:mvn3.6.3-jdk11-npm6.14.4-docker'
            args '-v /root/.m2:/root/.m2'
        }
   }
   options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
   }
    stages {
        stage ('Clone from github')
        {
            steps{
                withCredentials([usernamePassword(credentialsId: 'epats-github',
                usernameVariable: 'Username',
                passwordVariable: 'Password')]){
                    sh '''
                        mkdir test-release
                        cd test-release
                        git clone https://$Username:$Password@github.com/EvgeniaPatsoni/TestRelease.git
                        cd ../..
                    '''
                }
            }
        }
        stage ('Deliver code to gitlab repository') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'epats-gitlab',
                usernameVariable: 'Username',
                passwordVariable: 'Password')]){
                    sh '''
                        git clone https://$Username:$Password@gitlab.com/EvgeniaPatsoni/test-remote.git
                        cd test-remote
                        git checkout development
                        rm -rf $(ls -A | grep -v .git)
                        cd ..

                        mkdir temp

                        cd test-release/TestRelease
                        git checkout 0.0.8
                        cd ../..

                        cp -R test-release/TestRelease/. temp/
                        rm -rf temp/.git temp/.gitignore temp/Jenkinsfile temp/docs/ed temp/sonar-project.properties
                        cp -R temp/. test-remote/
                          
                        cd test-remote
                        
                        git config --global user.email "patsonievgenia@gmail.com"
                        git config --global user.name "EvgeniaPatsoni"
                        git remote set-url origin https://$Username:$Password@gitlab.com/EvgeniaPatsoni/test-remote.git
 
                        git add .
                        git status
                        git commit -m "v 0.0.8 delivery"
                        git push -u https://$Username:$Password@gitlab.com/EvgeniaPatsoni/test-remote.git -o merge_request.create HEAD:development
                    '''
                }
            }
        }  
    }
}   
