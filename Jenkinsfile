//#!groovy
//  groovy Jenkinsfile
properties([disableConcurrentBuilds()])\

pipeline  {
        agent { 
           label ''
        }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps()
    }
    stages {
        stage("Git clone") {
            steps {
                sh '''
                cd /home/an2/
                git clone https://github.com/olegstepit/ansible.jen.git   
                '''
            }
        }    
        stage("Build") {
            steps {
                sh '''
                cd /home/word
                docker build -t oleg222/word .
                '''
            }
        } 
        stage("Postgres") {
            steps {
                sh '''
                docker run \
                --name ansible2 \
                -d oleg222/word
                '''
            }
        }
        stage("docker login") {
            steps {
                echo " ============== docker login =================="
                withCredentials([usernamePassword(credentialsId: 'DockerHub-Credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                    docker login -u $USERNAME -p $PASSWORD
                    '''
                }
            }
        }
        stage("docker push") {
            steps {
                echo " ============== pushing image =================="
                sh '''
                docker push oleg222/word
                '''
            }
        }
    }
}
