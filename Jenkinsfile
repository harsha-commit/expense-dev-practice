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
        stage('Init'){
            steps{
                sh """
                    for i in 01-vpc/ 02-sg/ 03-vpn/ 05-rds/ 06-app-alb/; do cd $i; terraform init -reconfigure; cd ..; done
                """
            }
        }
        stage('Plan'){
            steps{
                sh """
                    for i in 01-vpc/ 02-sg/ 03-vpn/ 05-rds/ 06-app-alb/; do cd $i; terraform plan; cd ..; done
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
                    for i in 01-vpc/ 02-sg/ 03-vpn/ 05-rds/ 06-app-alb/; do cd $i; terraform apply -auto-approve; cd ..; done
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
                    for i in 06-app-alb/ 05-rds/ 03-vpn/ 02-sg/ 01-vpc/; do cd $i; terraform destroy -auto-approve; cd ..; done
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