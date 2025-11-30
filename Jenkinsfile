pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                  serviceAccountName: jenkins
                  containers:
                  - name: kaniko
                    image: gcr.io/kaniko-project/executor:debug
                    command:
                    - /busybox/sleep
                    args:
                    - 99d
                    volumeMounts:
                      - name: kaniko-secret
                        mountPath: /kaniko/.docker
                  - name: git
                    image: alpine/git:latest
                    command:
                    - cat
                    tty: true
                  - name: helm
                    image: alpine/helm:3.12.0
                    command:
                    - cat
                    tty: true
                  volumes:
                  - name: kaniko-secret
                    secret:
                      secretName: aws-ecr-secret
                      items:
                        - key: .dockerconfigjson
                          path: config.json
            '''
        }
    }
    
    environment {
        ECR_REPOSITORY = 'your-ecr-repository-url'
        AWS_REGION = 'us-west-2'
        GIT_REPO = 'https://github.com/icxodnik/DevOps_practice.git'
        HELM_CHART_PATH = 'charts/django-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                container('git') {
                    checkout scm
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                container('kaniko') {
                    script {
                        sh """
                            /kaniko/executor \
                            --context django-app \
                            --dockerfile django-app/Dockerfile \
                            --destination ${ECR_REPOSITORY}:${IMAGE_TAG} \
                            --destination ${ECR_REPOSITORY}:latest \
                            --cache=true
                        """
                    }
                }
            }
        }
        
        stage('Update Helm Chart') {
            steps {
                container('git') {
                    script {
                        // Оновлюємо тег в values.yaml
                        sh """
                            sed -i 's|repository: .*|repository: ${ECR_REPOSITORY}|g' ${HELM_CHART_PATH}/values.yaml
                            sed -i 's|tag: .*|tag: "${IMAGE_TAG}"|g' ${HELM_CHART_PATH}/values.yaml
                        """
                        
                        // Комітимо зміни
                        sh """
                            git config user.email "jenkins@example.com"
                            git config user.name "Jenkins"
                            git add ${HELM_CHART_PATH}/values.yaml
                            git commit -m "Update image tag to ${IMAGE_TAG}"
                            git push origin HEAD:main
                        """
                    }
                }
            }
        }
        
        stage('Deploy with Argo CD') {
            steps {
                script {
                    // Argo CD автоматично синхронізує зміни
                    echo "Argo CD will automatically sync the changes from Git repository"
                    echo "New image tag: ${IMAGE_TAG}"
                    echo "ECR Repository: ${ECR_REPOSITORY}"
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo "Pipeline completed successfully!"
            echo "Image: ${ECR_REPOSITORY}:${IMAGE_TAG}"
            echo "Argo CD will deploy the updated application"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
} 