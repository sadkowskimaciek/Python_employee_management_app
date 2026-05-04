pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Budowanie obrazu z nowym kodem...'
                // Budujesz obraz z tagiem "latest"
                sh 'docker build -t moja-aplikacja:latest .'
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Inicjalizacja środowiska Terraform...'
                sh 'terraform init'
            }
        }

        stage('Terraform Plan & Apply') {
            steps {
                echo 'Planowanie i wdrażanie infrastruktury (Zadanie z obrazka)...'

                // POPRAWKA TUTAJ: Przekazujemy wartości zmiennych do main.tf
                sh 'terraform plan -var="image_tag=latest" -var="container_name=moja-aplikacja-kontener" -out=tfplan'

                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
