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
                        # Check if Trivy is installed
    if ! command -v trivy &> /dev/null; then
        echo "Installing Trivy..."
        
        # Detect the system architecture and download the correct binary
        ARCH=$(uname -m)
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
        TRIVY_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep "tag_name" | cut -d '"' -f 4)
        
        wget -qO trivy.tar.gz "https://github.com/aquasecurity/trivy/releases/download/${TRIVY_VERSION}/trivy_${OS}_${ARCH}.tar.gz"
        
        # Extract and move Trivy to the appropriate directory
        tar -xzf trivy.tar.gz
        sudo mv trivy /usr/local/bin/
        
        # Clean up
        rm trivy.tar.gz
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
