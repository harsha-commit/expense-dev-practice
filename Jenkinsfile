pipeline{
    
    agent {
        label 'AGENT-1'
    }

    options{
        disableConcurrentBuilds()
        timeout(time: 45, unit: 'MINUTES')
        ansiColor('xterm')
    }

    parameters{
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Pick something')
    }

    stages{
        stage('Test'){
            steps{
                sh """
                    ls -ltr
                """
            }
        }
        stage('Init'){
            steps{
                sh """
                    cd 01-vpc/; terraform init -reconfigure; cd ..
                    cd 02-sg/; terraform init -reconfigure; cd ..
                    cd 03-vpn/; terraform init -reconfigure; cd ..
                    cd 05-rds/; terraform init -reconfigure; cd ..
                    cd 06-app-alb/; terraform init -reconfigure; cd ..
                """
            }
        }
        stage('Plan'){
            steps{
                sh """
                    cd 01-vpc/; terraform plan; cd ..
                    cd 02-sg/; terraform plan; cd ..
                    cd 03-vpn/; terraform plan; cd ..
                    cd 05-rds/; terraform plan; cd ..
                    cd 06-app-alb/; terraform plan; cd ..
                """
            }
        }
        stage('Apply'){
            when{
                expression{
                    params.action == 'apply'
                }
            }
            steps{
                sh """
                    cd 01-vpc/; terraform apply -auto-approve; cd ..
                    cd 02-sg/; terraform apply -auto-approve; cd ..
                    cd 03-vpn/; terraform apply -auto-approve; cd ..
                    cd 05-rds/; terraform apply -auto-approve; cd ..
                    cd 06-app-alb/; terraform apply -auto-approve; cd ..
                """
            }
        }
        stage('Destroy'){
            when{
                expression{
                    params.action == 'destroy'
                }
            }
            steps{
                sh """
                    cd 06-app-alb/; terraform destroy -auto-approve; cd ..
                    cd 05-rds/; terraform destroy -auto-approve; cd ..
                    cd 03-vpn/; terraform destroy -auto-approve; cd ..
                    cd 02-sg/; terraform destroy -auto-approve; cd ..
                    cd 01-vpc/; terraform destroy -auto-approve; cd ..  
                """
            }
        }
    }

    post{
        always{
            echo 'Infrastructure Build Completed'
            deleteDir()
        }
        success{
            echo 'Infrastructure Build SUCCESSFUL!!!'
        }
        failure{
            echo 'Infrastructure Build FAILED!!!'
        }
    }
}