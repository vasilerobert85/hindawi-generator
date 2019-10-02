#!/bin/sh

#################################################################################################################################
## This script is designed to aid in common tasks:                                                                             ##
##                                                                                                                             ##
## ElasticBeanstalk Environment -> new environment with ECR Repositiory for the new service, list/update environment variables ##
##                                                                                                                             ##
## RDS Database creation --> PostgreSQL                                                                                        ##
##                                                                                                                             ##
## CloudWatch log deletion                                                                                                     ##
#################################################################################################################################

ANSIPROMPT="\033[1;31mInput-->\033[0m "

select_aws_profile () {
        
        echo "\nPlease enter your choice for what you would like to do:"
        echo "Press 1 -> to select the AWS profile to run the next sections"
        echo "Press 6 -> to quit\n"
read -n 1 -p $(echo "$ANSIPROMPT") select_aws_profile_ans
        if [ "$select_aws_profile_ans" = "1" ]; then
        #list available AWS profiles
                echo "\nThe listed below are the available AWS profiles on your machine\n"
        cat ~/.aws/credentials | grep -o '\[[^]]*\]'
        set_aws_profile () {
                echo "\nPlease enter the name of the AWS account you want to use:\n"
        read -p $(echo "$ANSIPROMPT") set_aws_profile_ans
        echo "\n\nYour have selected to use $set_aws_profile_ans AWS account\n\n"
       }
       set_aws_profile
        mainmenu () {
                echo "Please enter your choice for what you would like to do:"
                echo "Press 1 -> for creating a new ElasticBeanstalk Environment"
                echo "Press 2 -> for listing ElasticBeanstalk Environment variables"
                echo "Press 3 -> for uploading ElasticBeanstalk Environment variables"
                echo "Press 4 -> for creating a new RDS Database"
                echo "Press 5 -> to delete a CloudWatch log"
                echo "Press 6 -> to quit\n\n"
        read -n 1 -p $(echo "$ANSIPROMPT") mainmenuinput
                #Should 1 be selected -> for creating a new ElasticBeanstalk Environment
                if [ "$mainmenuinput" = "1" ]; then
                        new_elasticBeanstalk_environment () {
                                echo "\nPlease enter your choice for what you would like to do:"
                                echo "Press 1 -> for new QA - Environment"
                                echo "Press 2 -> for new PROD - Environment"
                                echo "Press 3 -> to exit to main menu"
                                echo "Press 6 -> to quit\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") new_elasticBeanstalk_environment_ans
                        #provide the name for the new QA ElasticBeanstalk Environment
                        if [ "$new_elasticBeanstalk_environment_ans" = "1" ]; then
                                eb_env_name_qa () {
                                        printf "\033[1;31m Dockerrun.aws.json needs first to be uploaded and referance the name below;\033[0m\n"
                                        echo "\nPlease enter the name of the ElasticBeanstalk Environment--> qa-service- already appended :\n"
                                read -p $(echo "$ANSIPROMPT") eb_env_name_qa_ans
                        # use AWS CLI to find out if the privided name is available or not
                                        cname1="aws elasticbeanstalk check-dns-availability --cname-prefix qa-service-$eb_env_name_qa_ans --profile $set_aws_profile_ans"
                                        qa_cname_availability=$( eval $cname1 | jq .Available )
                                                echo "\nChecking AWS CNAME availability --> $qa_cname_availability\n"
                        # use AWS CLI to create the QA Environment
                                                if [ "$qa_cname_availability" = "true" ]; then
                                                        create_eb_env1="aws elasticbeanstalk create-environment \
                                                        --cname-prefix qa-service-$eb_env_name_qa_ans \
                                                        --application-name Screening \
                                                        --template-name generic-app \
                                                        --version-label qa-service-$eb_env_name_qa_ans \
                                                        --environment-name qa-service-$eb_env_name_qa_ans \
                                                        --profile $set_aws_profile_ans"
                                                        local qa_create_environment=$(eval $create_eb_env1)
                        # create ECR Repositiory for the new service
                                                echo "Now creating the ECR Repository for the new service"
                                                create_repo1="aws ecr create-repository --repository-name $eb_env_name_qa_ans --profile $set_aws_profile_ans"
                                                eval $create_repo1
                        # set the ECR Repositiory permisions for the new service
                                                set_repo_policy1="aws ecr set-repository-policy --repository-name $eb_env_name_qa_ans --policy-text file://repo_access.json --profile $set_aws_profile_ans"
                                                eval $set_repo_policy1
                                                else
                                                        echo "\nYou have entered an already existing Environment name!\n"
                                                                clear
                                                                eb_env_name_qa
                                                fi
                                }
                                eb_env_name_qa
                        #provide the name for the new PROD ElasticBeanstalk Environment
                        elif [ "$new_elasticBeanstalk_environment_ans" = "2" ]; then
                                eb_env_name_prod () {
                                        printf "\033[1;31m Dockerrun.aws.json needs first to be uploaded and referance the name below\033[0m\n"
                                        echo "\n\nPlease enter the name of the ElasticBeanstalk Environment--> prod-service- already appended :\n\n"
                                read -p $(echo "$ANSIPROMPT") eb_env_name_prod_ans
                        # use AWS CLI to find out if the privided name is available or not
                                        cname2="aws elasticbeanstalk check-dns-availability --cname-prefix prod-service-$eb_env_name_prod_ans --profile $set_aws_profile_ans"  
                                        prod_cname_availability=$( eval $cname2 | jq .Available )
                                                echo "\nChecking AWS CNAME availability --> $prod_cname_availability\n"
                        # use AWS CLI to create the PROD Environment
                                                if [ "$prod_cname_availability" = "true" ]; then
                                                        create_eb_env2="aws elasticbeanstalk create-environment \
                                                        --cname-prefix prod-service-$eb_env_name_prod_ans \
                                                        --application-name Screening \
                                                        --template-name generic-app \
                                                        --version-label prod-service-$eb_env_name_prod_ans \
                                                        --environment-name prod-service-$eb_env_name_prod_ans \
                                                        --profile $set_aws_profile_ans"
                                                        local prod_create_environment=$(eval $create_eb_env2)
                                                else
                                                        echo "\nYou have entered an already existing Environment name!\n"
                                                        clear
                                                        eb_env_name_prod
                                                fi
                                }
                                eb_env_name_prod
                        elif [ "$new_elasticBeanstalk_environment_ans" = "3" ]; then
                                clear
                                mainmenu
                        elif [ "$new_elasticBeanstalk_environment_ans" = "6" ]; then
                                exit 1
                        else
                                echo "\nYou have entered an invallid selection!"
                                echo "Please try again!\n"
                                echo "Press any key to continue...\n"
                                read -n 1
                                clear
                                new_elasticBeanstalk_environment
                        fi
                        }
                        new_elasticBeanstalk_environment
                #Should 2 be selected -> for listing ElasticBeanstalk Environment variables
                elif [ "$mainmenuinput" = "2" ]; then
                        list_elasticBeanstalk_environments () {
                                echo "\nPlease enter your choice for what you would like to do:"
                                echo "Press 1 -> for the available ElasticBeanstalk Environment variables"
                                echo "Press 3 -> to exit to main menu"
                                echo "Press 6 -> to quit\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") list_elasticBeanstalk_environments_ans 
                        #list the available ElasticBeanstalk Environment variables
                        if [ "$list_elasticBeanstalk_environments_ans" = "1" ]; then
                                list_eb_env="eb list -av --profile $set_aws_profile_ans"
                                eval $list_eb_env
                        #ask for the ElasticBeanstalk Environment name
                                print_elasticBeanstalk_environments () {
                                        echo "\nPlease enter the name of the ElasticBeanstalk Environment:\n"
                                read -p $(echo "$ANSIPROMPT") print_elasticBeanstalk_environments_ans
                                }
                                print_elasticBeanstalk_environments
                        #provide the ElasticBeanstalk Environment variables specified 
                                print_eb_env="eb printenv $print_elasticBeanstalk_environments_ans --profile $set_aws_profile_ans"
                                eval $print_eb_env
                        elif [ "$list_elasticBeanstalk_environments_ans" = "3" ]; then
                                clear
                                mainmenu
                        elif [ "$list_elasticBeanstalk_environments_ans" = "6" ]; then
                                exit 1
                        else
                                echo "\nYou have entered an invallid selection!"
                                echo "Please try again!\n"
                                echo "Press any key to continue...\n"
                                read -n 1
                                clear
                                list_elasticBeanstalk_environments
                        fi
                        }
                        list_elasticBeanstalk_environments
                #Should 3 be selected -> for uploading ElasticBeanstalk Environment variables
                elif [ "$mainmenuinput" = "3" ]; then

                        upload_elasticBeanstalk_environment () {
                                echo "\nPlease enter your choice for what you would like to do:"
                                echo "Press 1 -> to generate a list of the available ElasticBeanstalk Environments"
                                echo "Press 3 -> to exit to main menu"
                                echo "Press 6 -> to quit\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") upload_elasticBeanstalk_environment_ans
                        #list the available ElasticBeanstalk Environment variables
                        if [ "$upload_elasticBeanstalk_environment_ans" = "1" ]; then
                                list_eb_env2="eb list -av --profile $set_aws_profile_ans"
                                eval $list_eb_env2
                        #ask for the ElasticBeanstalk Environment name
                                name_elasticBeanstalk_environments () {
                                        echo "\n\n"
                                        printf "\033[1;31m ForUpload file needs first to be uploaded with your ElasticBeanstalk Environment variabels\033[0m\n"
                                        echo "\nPlease enter the name of the Environment to upload variables to:\n"
                                read -p $(echo "$ANSIPROMPT") name_elasticBeanstalk_environments_ans
                                }
                                name_elasticBeanstalk_environments
                        #set the ElasticBeanstalk Environment to target
                                eb_use="eb use $name_elasticBeanstalk_environments_ans --profile $set_aws_profile_ans"
                                eval $eb_use
                                echo $(cat ForUpload | sed 's/ //g') > Uploaded
                                upload_eb_env="eb setenv `cat  Uploaded` --profile $set_aws_profile_ans"
                                eval $upload_eb_env
                        elif [ "$upload_elasticBeanstalk_environment_ans" = "3" ]; then
                                clear
                                mainmenu
                        elif [ "$upload_elasticBeanstalk_environment_ans" = "6" ]; then
                                exit 1
                        else
                                echo "\nYou have entered an invallid selection!"
                                echo "Please try again!\n"
                                echo "Press any key to continue...\n"
                                read -n 1
                                clear
                                list_elasticBeanstalk_environments

                        fi
                        }
                        upload_elasticBeanstalk_environment
                #Should 4 be selected -> for creating a new RDS Database
                elif [ "$mainmenuinput" = "4" ]; then
                        create_rds_db () {
                                echo "Please enter your choice for what you would like to do:"
                                echo "Press 1 -> for creating a new Sandbox RDS DB"
                                echo "Press 2 -> for creating a new PROD RDS DB"
                                echo "Press 3 -> to exit to main menu"
                                echo "Press 6 -> to quit\n\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") create_rds_db_ans
                        if [ "$create_rds_db_ans" = "1" ]; then
                                name_db_instance_identifier () {
                                        echo "\nPlease enter the database instance identifier (my-db):\n"
                                        read -p $(echo "$ANSIPROMPT") name_db_instance_identifier_ans
                                }
                                name_db_instance_identifier
                                name_db_name() {
                                        echo "\nPlease enter the database name (my_db):\n"
                                        read -p $(echo "$ANSIPROMPT") name_db_name_ans
                                }
                                name_db_name
                                name_db_master_username () {
                                        echo "\nPlease enter the database master username (db_user):\n"
                                        read -p $(echo "$ANSIPROMPT") db_master_username_ans
                                }
                                name_db_master_username
                                name_db_master_user_password () {
                                        echo "\nPlease enter the database master user password:\n"
                                        read -p $(echo "$ANSIPROMPT") db_master_user_password_ans
                                        echo $db_master_user_password_ans
                                }
                                name_db_master_user_password
                                create_db="aws rds create-db-instance \
                                        --allocated-storage 20 \
                                        --db-instance-class db.t2.small \
                                        --db-instance-identifier $name_db_instance_identifier_ans \
                                        --master-username $db_master_username_ans \
                                        --master-user-password $db_master_user_password_ans \
                                        --db-name $name_db_name_ans \
                                        --engine postgres \
                                        --engine-version 10.9 \
                                        --preferred-maintenance-window sat:02:00-sat:02:30 \
                                        --copy-tags-to-snapshot \
                                        --monitoring-interval 60 \
                                        --monitoring-role-arn arn:aws:iam::496598730381:role/rds-monitoring-role \
                                        --enable-performance-insights \
                                        --no-deletion-protection \
                                        --performance-insights-retention-period 7 \
                                        --profile $set_aws_profile_ans"
                                eval $create_db
                        elif [ "$create_rds_db_ans" = "2" ]; then
                                name_db_instance_identifier () {
                                        echo "\nPlease enter the database instance identifier (my-db):\n"
                                        read -p $(echo "$ANSIPROMPT") name_db_instance_identifier_ans
                                }
                                name_db_instance_identifier
                                name_db_name() {
                                        echo "\nPlease enter the database name (my_db):\n"
                                        read -p $(echo "$ANSIPROMPT") name_db_name_ans
                                }
                                name_db_name
                                name_db_master_username () {
                                        echo "\nPlease enter the database master username (db_user):\n"
                                        read -p $(echo "$ANSIPROMPT") db_master_username_ans
                                }
                                name_db_master_username
                                name_db_master_user_password () {
                                        echo "\nPlease enter the database master user password:\n"
                                        read -p $(echo "$ANSIPROMPT") db_master_user_password_ans
                                        echo $db_master_user_password_ans
                                }
                                name_db_master_user_password
                                create_db_prod="aws rds create-db-instance \
                                        --allocated-storage 20 \
                                        --db-instance-class db.t2.small \
                                        --db-instance-identifier $name_db_instance_identifier_ans \
                                        --master-username $db_master_username_ans \
                                        --master-user-password $db_master_user_password_ans \
                                        --db-name $name_db_name_ans \
                                        --engine postgres \
                                        --engine-version 10.9 \
                                        --preferred-maintenance-window sat:02:00-sat:02:30 \
                                        --copy-tags-to-snapshot \
                                        --monitoring-interval 60 \
                                        --monitoring-role-arn arn:aws:iam::918602980697:role/rds-monitoring-role \
                                        --enable-performance-insights \
                                        --no-deletion-protection \
                                        --performance-insights-retention-period 7 \
                                        --profile $set_aws_profile_ans"
                                eval $create_db_prod
                        elif [ "$create_rds_db_ans" = "3" ]; then
                                clear
                                mainmenu
                        elif [ "$create_rds_db_ans" = "6" ]; then
                                exit 1
                        else
                                echo "\nYou have entered an invallid selection!"
                                echo "Please try again!\n"
                                echo "Press any key to continue...\n"
                                read -n 1
                                clear
                                create_rds_db_ans

                        fi
                        }
                        create_rds_db

                #Should 5 be selected -> to delete a CloudWatch log
                elif [ "$mainmenuinput" = "5" ]; then
                        delete_CloudWatch_log () {
                                echo "Please enter your choice for what you would like to do:"
                                echo "Press 1 -> for deleting CloudWatch application logs"
                                echo "Press 3 -> to exit to main menu"
                                echo "Press 6 -> to quit\n\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") delete_CloudWatch_log_ans
                        if [ "$delete_CloudWatch_log_ans" = "1" ]; then
                                delete_CloudWatch_log_name () {
                                        echo "\nPlease enter the application name:\n"
                                        read -p $(echo "$ANSIPROMPT") delete_CloudWatch_log_name_ans
                                }
                                delete_CloudWatch_log_name 
                                delete_logs_1="aws logs delete-log-group --log-group-name /aws/elasticbeanstalk/$delete_CloudWatch_log_name_ans/environment-health.log --profile $set_aws_profile_ans"
                                delete_logs_2="aws logs delete-log-group --log-group-name /aws/elasticbeanstalk/$delete_CloudWatch_log_name_ans/var/log/docker --profile $set_aws_profile_ans"
                                delete_logs_3="aws logs delete-log-group --log-group-name /aws/elasticbeanstalk/$delete_CloudWatch_log_name_ans/var/log/docker-events.log --profile $set_aws_profile_ans"
                                delete_logs_4="aws logs delete-log-group --log-group-name /aws/elasticbeanstalk/$delete_CloudWatch_log_name_ans/var/log/eb-activity.log --profile $set_aws_profile_ans"
                                delete_logs_5="aws logs delete-log-group --log-group-name /aws/elasticbeanstalk/$delete_CloudWatch_log_name_ans/var/log/eb-docker/containers/eb-current-app/stdouterr.log --profile $set_aws_profile_ans"
                                delete_logs_6="aws logs delete-log-group --log-group-name /aws/elasticbeanstalk/$delete_CloudWatch_log_name_ans/var/log/nginx/access.log --profile $set_aws_profile_ans"
                                delete_logs_7="aws logs delete-log-group --log-group-name /aws/elasticbeanstalk/$delete_CloudWatch_log_name_ans/var/log/nginx/error.log --profile $set_aws_profile_ans"
                                eval $delete_logs_1
                                eval $delete_logs_2
                                eval $delete_logs_3
                                eval $delete_logs_4
                                eval $delete_logs_5
                                eval $delete_logs_6
                                eval $delete_logs_7
                        elif [ "$delete_CloudWatch_log_ans" = "3" ]; then
                                clear
                                mainmenu
                        elif [ "$delete_CloudWatch_log_ans" = "6" ]; then
                                exit 1
                        else
                                echo "\nYou have entered an invallid selection!"
                                echo "Please try again!\n"
                                echo "Press any key to continue...\n"
                                read -n 1
                                clear
                                delete_CloudWatch_log

                        fi
                        }
                        delete_CloudWatch_log

                elif [ "$mainmenuinput" = "6" ]; then
                        exit 1
                else
                        echo "\nYou have entered an invallid selection!"
                        echo "Please try again!\n"
                        echo "Press any key to continue...\n"
                        read -n 1
                        clear
                        mainmenu
                fi
        }
        mainmenu
elif [ "$select_aws_profile_ans" = "6" ]; then
        exit 1
else
        echo "\nYou have entered an invallid selection!"
        echo "Please try again!\n"
        echo "Press any key to continue...\n"
        read -n 1
        clear
        select_aws_profile
fi
}
select_aws_profile
