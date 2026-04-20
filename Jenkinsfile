pipeline {
    agent any 

    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                script {
                    sh 'docker build -t employee-app . > build_logs.txt 2>&1'
                }
            }
        }

       -
        stage('Deploy') {
            steps {
                script {
                    echo 'Rozpoczynam wdrożenie nowej wersji...'
                    // Usuwamy stary kontener, jeśli istnieje (żeby uniknąć konfliktu nazw)
                    sh 'docker rm -f employee-app-prod || true'
                    
                    // Uruchamiamy aplikację z nowo zbudowanego obrazu
                    sh 'docker run --name employee-app-prod employee-app'
                }
            }
        }

        stage('Smoke Test') {
            steps {
                script {
                    echo 'Weryfikacja poprawności działania (Smoke Test)...'
                    sh 'docker logs employee-app-prod | grep "Yoana Ivanova"'
                    
                    echo 'Smoke test zakończony sukcesem! Aplikacja wdrożona i działa poprawnie.'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'build_logs.txt', allowEmptyArchive: true
        }
        failure {
            mail to: 'twoj.mail@domena.pl',
                 subject: "Awaria potoku w Jenkins: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Potok zakończył się błędem. Sprawdź zarchiwizowane logi: ${env.BUILD_URL}"
        }
        success {
            echo 'Cały proces CI/CD zakończony pomyślnie!'
        }
    }
}
