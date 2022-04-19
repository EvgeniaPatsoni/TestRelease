pipeline {
   agent {
         docker {
            image 'eddevopsd2/ubuntu-dind:dind-mvn3.6.3-jdk15-npm6.14.13-buildx-azurecli'
            args '--privileged -v /root/.m2:/root/.m2'
        }
   }
   options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
   }
    stages {
        stage ('Prompt for Input') {
            steps {
                script {
                    env.RELEASE_VERSION = input message: 'Release version:',
                                     parameters: [string(defaultValue: '',
                                                  description: '',
                                                  name: 'Release version')]
                    env.NEXT_DEV_VERSION = input message: 'Snapshot version:',
                                     parameters: [string(defaultValue: '',
                                                  description: '',
                                                  name: 'Next development version')]
                }
            }
        }        
        stage ('Set to release version')
        {
            steps{
                sh '''
                    git fetch --tags --force                
                    mvn versions:set -DnewVersion=$RELEASE_VERSION
                    mvn versions:commit
                '''
            }
        }
        stage ('Push changes for release version') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'epats-github',
                usernameVariable: 'Username',
                passwordVariable: 'Password')]){
                    sh '''
                        git remote set-url origin https://$Username:$Password@github.com/EvgeniaPatsoni/TestRelease.git
                        git config --global user.email "patsonievgenia@gmail.com"
                        git config --global user.name "$Username"

                        git commit -a -m "release: prepare release $RELEASE_VERSION"
                        git tag -a $RELEASE_VERSION -m "$RELEASE_VERSION"
                        docker run -v "$PWD":/workdir quay.io/git-chglog/git-chglog -o CHANGELOG.md
                        git add . && git commit --amend --no-edit && git tag -d $RELEASE_VERSION && git tag -a $RELEASE_VERSION -m "$RELEASE_VERSION"
                        git push https://$Username:$Password@github.com/EvgeniaPatsoni/TestRelease.git HEAD:main --tags
                    '''
                }
            }
        }        
    }
}   
