pipeline {
    agent any 

    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Budowanie obrazu z nowym kodem...'
              
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
                
                sh 'terraform plan -out=tfplan'
                
                
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
