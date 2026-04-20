pipeline {
    agent any 

    environment {
        APP_VERSION = "1.0.${env.BUILD_NUMBER}"
        GIT_HASH = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
    }

    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                script {
                    sh "docker build -t employee-app:${APP_VERSION} -t employee-app:${GIT_HASH} -t employee-app:latest . > build_logs.txt 2>&1"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Rozpoczynam wdrożenie wersji ${APP_VERSION} (Commit: ${GIT_HASH})..."
                    sh 'docker rm -f employee-app-prod || true'
                    sh "docker run --name employee-app-prod employee-app:${APP_VERSION}"
                }
            }
        }

        stage('Smoke Test') {
            steps {
                script {
                    echo 'Weryfikacja poprawności działania...'
                    sh 'docker logs employee-app-prod | grep "Yoana Ivanova"'
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    echo "Zapisywanie obrazu Docker jako artefakt..."
                    sh "docker save -o employee-app-v${APP_VERSION}-${GIT_HASH}.tar employee-app:${APP_VERSION}"
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'build_logs.txt, *.tar', allowEmptyArchive: true
        }
        failure {
            mail to: 'macieks185@gmail.com',
                 subject: "Awaria potoku w Jenkins: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Potok zakończył się błędem. Commit: ${GIT_HASH}. Sprawdź logi: ${env.BUILD_URL}"
        }
        success {
            echo "Sukces! Wersja ${APP_VERSION} (Commit: ${GIT_HASH}) została opublikowana."
        }
    }
}
