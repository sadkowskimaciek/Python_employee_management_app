pipeline {
    // Jenkins użyje swojego środowiska (w którym zainstalowaliśmy dockera w infrastrukturze)
    agent any 

    stages {
        stage('Clone') {
            steps {
                // Punkt 1: Krok pobierania kodu (Jenkins robi to domyślnie, ale zapisujemy jawnie)
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                script {
                    // Punkt 1 i 2: Budowanie i testy wewnątrz kontenerów
                    // Uruchamiamy komendę budującą nasz wieloetapowy Dockerfile.
                    // Testy wykonają się wewnątrz hermetycznego etapu 'builder/tester'.
                    // Przekierowujemy logi (> build_logs.txt 2>&1) do pliku, żeby móc je zarchiwizować.
                    sh 'docker build -t employee-app . > build_logs.txt 2>&1'
                }
            }
        }
    }

    // Punkt 3: Obsługa błędów (Post-actions)
    post {
        always {
            // Punkt 5: Archiwizacja logów
            // Plik z logami zostanie na stałe podpięty pod ten konkretny "build" w Jenkinsie
            archiveArtifacts artifacts: 'build_logs.txt', allowEmptyArchive: true
        }
        
        failure {
            // Punkt 4: Integracja Mail/Teams w momencie przerwania potoku
            // Przykład wysyłki Maila (najpopularniejszy i domyślny w Jenkinsie)
            mail to: 'macieks@student.agh.edu.pl',
                 subject: "Awaria potoku w Jenkins: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Potok zakończył się błędem (np. testy nie przeszły). Sprawdź zarchiwizowane logi: ${env.BUILD_URL}"
                 
            // Przykład dla Webhooka MS Teams (możesz odkomentować, jeśli masz wtyczkę Office 365 Connector)
            // office365ConnectorSend message: "Błąd potoku ${env.JOB_NAME}", status: "Failure", webhookUrl: "TUTAJ_WKLEJ_LINK_Z_TEAMS"
        }
        
        success {
            echo 'Sukces! Obraz zbudowany, a testy w kontenerze przeszły pomyślnie.'
        }
    }
}
