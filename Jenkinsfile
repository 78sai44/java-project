def img
pipeline {
    environment {
        registry = "saigundavarapu/java" //To push an image to Docker Hub, you must first name your local image using your Docker Hub username and the repository name that you created through Docker Hub on the web.
        registryCredential = 'DOCKERHUB'
        githubCredential = 'Github'
        dockerImage = ''
    }
    agent any
    stages {
       
        stage('checkout') {
                steps {
                git branch: 'main',
                credentialsId: githubCredential,
                url: 'https://github.com/78sai44/java-project.git'
                }
        }
       
 
        stage('Build Image') {
            steps {
                script {
                    img = registry + ":${env.BUILD_ID}"
                    println ("${img}")
                    dockerImage = docker.build("${img}")
                }
            }
        }
        

        stage('Push To DockerHub') {
            steps {
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com ', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
                   
        stage('Deploy') {
           steps {
                sh label: '', script: "docker run -d --name ${JOB_NAME} -p 5000:5000 ${img}"
          }
        }
 
      }
        post {
            always {
                echo 'Pipeline execution completed.'
            }
            success {
                echo 'Pipeline executed successfully!'
            }
            failure {
                echo 'Pipeline failed.'
            }
        }
    }
