def img
pipeline {
    environment {
        registry = "saigundavarapu/java" // Docker Hub repository name
        registryCredential = 'DOCKERHUB' // Docker Hub credentials
        githubCredential = 'Github' // GitHub credentials
        dockerImage = ''
    }
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                credentialsId: githubCredential,
                url: 'https://github.com/78sai44/java-project.git'
            }
        }

        stage('Build Image') {
            steps {
                script {
                    img = "${registry}:${env.BUILD_ID}" // Build a unique Docker image tag using the build ID
                    println("Building Docker Image: ${img}")
                    dockerImage = docker.build(img)
                }
            }
        }

        stage('Scan Docker Image with Trivy') {
    steps {
        script {
            def trivyCacheDir = "${env.WORKSPACE}/trivy-cache"
            sh """
                mkdir -p ${trivyCacheDir}
                docker run --rm \
                    -v ${trivyCacheDir}:/root/.cache/trivy \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    aquasec/trivy:latest image ${img}
            """
        }
    }
}


        stage('Push To DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop and remove any existing container with the same name
                    sh """
                        docker ps -a -q --filter "name=${JOB_NAME}" | grep -q . && docker stop ${JOB_NAME} && docker rm ${JOB_NAME} || true
                    """
                    // Run the new container
                    sh "docker run -d --name ${JOB_NAME} -p 5000:5000 ${img}"
                }
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
