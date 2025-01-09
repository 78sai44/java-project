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
        stage('Scan with Trivy') {
            steps {
                script {
                    // Install Trivy if it's not already installed
                    sh '''
                        if ! command -v trivy &> /dev/null; then
                            echo "Installing Trivy..."
                            wget -qO- https://github.com/aquasecurity/trivy/releases/latest/download/trivy_$(uname -s)_$(uname -m).tar.gz | tar xz
                            sudo mv trivy /usr/local/bin/
                        fi
                    '''
                    
                    // Run Trivy scan
                    sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${img}"
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
