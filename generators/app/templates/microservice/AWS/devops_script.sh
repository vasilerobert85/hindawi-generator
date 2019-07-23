#!/bin/sh

########################################################################################################
# This script is designed to aid in common ElasticBeanstalk Environment task and RDS Database creation #
########################################################################################################

ANSIPROMPT="\033[1;31mInput-->\033[0m "

select_aws_profile () {
        
        echo "\nPlease enter your choice for what you would like to do:"
        echo "Press 1 -> to select the AWS profile to run the next sections"
        echo "Press 5 -> to quit\n"
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
                echo "Press 5 -> to quit\n\n"
        read -n 1 -p $(echo "$ANSIPROMPT") mainmenuinput
                #Should 1 be selected -> for creating a new ElasticBeanstalk Environment
                if [ "$mainmenuinput" = "1" ]; then
                        new_elasticBeanstalk_environment () {
                                echo "\nPlease enter your choice for what you would like to do:"
                                echo "Press 1 -> for new QA - Environment"
                                echo "Press 2 -> for new PROD - Environment"
                                echo "Press 3 -> to exit to main menu"
                                echo "Press 5 -> to quit\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") new_elasticBeanstalk_environment_ans
                        #provide the name for the new QA ElasticBeanstalk Environment
                        if [ "$new_elasticBeanstalk_environment_ans" = "1" ]; then
                                eb_env_name_qa () {
                                        printf "\033[1;31m Dockerrun.aws.json needs first to be uploaded and referance the name below; qa-service- already appended\033[0m\n"
                                        echo "\nPlease enter the name of the ElasticBeanstalk Environment:\n"
                                read -p $(echo "$ANSIPROMPT") eb_env_name_qa_ans
                        # use AWS CLI to find out if the privided name is available or not
                                        AWSCOMMAND1="aws elasticbeanstalk check-dns-availability --cname-prefix qa-service-$eb_env_name_qa_ans --profile $set_aws_profile_ans"
                                        qa_cname_availability=$( eval $AWSCOMMAND1 | jq .Available )
                                                echo "\nChecking AWS CNAME availability --> $qa_cname_availability\n"
                        # use AWS CLI to create the QA Environment
                                                if [ "$qa_cname_availability" = "true" ]; then
                                                        AWSCOMMAND2="aws elasticbeanstalk create-environment \
                                                        --cname-prefix qa-service-$eb_env_name_qa_ans \
                                                        --application-name Screening \
                                                        --template-name generic-app \
                                                        --version-label qa-service-$eb_env_name_qa_ans \
                                                        --environment-name qa-service-$eb_env_name_qa_ans \
                                                        --profile $set_aws_profile_ans"
                                                        local qa_create_environment=$(eval $AWSCOMMAND2)
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
                                        printf "\033[1;31m Dockerrun.aws.json needs first to be uploaded and referance the name below; prod-service- already appended\033[0m\n"
                                        echo "\n\nPlease enter the name of the ElasticBeanstalk Environment:\n\n"
                                read -p $(echo "$ANSIPROMPT") eb_env_name_prod_ans
                        # use AWS CLI to find out if the privided name is available or not
                                        AWSCOMMAND3="aws elasticbeanstalk check-dns-availability --cname-prefix prod-service-$eb_env_name_prod_ans --profile $set_aws_profile_ans"  
                                        prod_cname_availability=$( eval $AWSCOMMAND3 | jq .Available )
                                                echo "\nChecking AWS CNAME availability --> $prod_cname_availability\n"
                        # use AWS CLI to create the PROD Environment
                                                if [ "$prod_cname_availability" = "true" ]; then
                                                        AWSCOMMAND4="aws elasticbeanstalk create-environment \
                                                        --cname-prefix prod-service-$eb_env_name_prod_ans \
                                                        --application-name Screening \
                                                        --template-name generic-app \
                                                        --version-label prod-service-$eb_env_name_prod_ans \
                                                        --environment-name prod-service-$eb_env_name_prod_ans \
                                                        --profile $set_aws_profile_ans"
                                                        local prod_create_environment=$(eval $AWSCOMMAND4)
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
                        elif [ "$new_elasticBeanstalk_environment_ans" = "5" ]; then
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
                                echo "Press 5 -> to quit\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") list_elasticBeanstalk_environments_ans 
                        #list the available ElasticBeanstalk Environment variables
                        if [ "$list_elasticBeanstalk_environments_ans" = "1" ]; then
                                AWSCOMMAND5="eb list -av --profile $set_aws_profile_ans"
                                eval $AWSCOMMAND5
                        #ask for the ElasticBeanstalk Environment name
                                print_elasticBeanstalk_environments () {
                                        echo "\nPlease enter the name of the ElasticBeanstalk Environment:\n"
                                read -p $(echo "$ANSIPROMPT") print_elasticBeanstalk_environments_ans
                                }
                                print_elasticBeanstalk_environments
                        #provide the ElasticBeanstalk Environment variables specified 
                                AWSCOMMAND6="eb printenv $print_elasticBeanstalk_environments_ans --profile $set_aws_profile_ans"
                                eval $AWSCOMMAND6
                        elif [ "$list_elasticBeanstalk_environments_ans" = "3" ]; then
                                clear
                                mainmenu
                        elif [ "$list_elasticBeanstalk_environments_ans" = "5" ]; then
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
                                echo "Press 5 -> to quit\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") upload_elasticBeanstalk_environment_ans
                        #list the available ElasticBeanstalk Environment variables
                        if [ "$upload_elasticBeanstalk_environment_ans" = "1" ]; then
                                AWSCOMMAND7="eb list -av --profile $set_aws_profile_ans"
                                eval $AWSCOMMAND7
                        #ask for the ElasticBeanstalk Environment name
                                name_elasticBeanstalk_environments () {
                                        echo "\n\n"
                                        printf "\033[1;31m ForUpload file needs first to be uploaded with your ElasticBeanstalk Environment variabels\033[0m\n"
                                        echo "\nPlease enter the name of the Environment to upload variables to:\n"
                                read -p $(echo "$ANSIPROMPT") name_elasticBeanstalk_environments_ans
                                }
                                name_elasticBeanstalk_environments
                        #set the ElasticBeanstalk Environment to target
                                AWSCOMMAND8="eb use $name_elasticBeanstalk_environments_ans"
                                eval $AWSCOMMAND8
                                echo $(cat ForUpload | sed 's/ //g') > Uploaded
                                AWSCOMMAND9="eb setenv `cat  Uploaded`"
                                eval $AWSCOMMAND9
                        elif [ "$upload_elasticBeanstalk_environment_ans" = "3" ]; then
                                clear
                                mainmenu
                        elif [ "$upload_elasticBeanstalk_environment_ans" = "5" ]; then
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
                                echo "Press 1 -> for creating a new RDS DB"
                                echo "Press 3 -> to exit to main menu"
                                echo "Press 5 -> to quit\n\n"
                        read -n 1 -p $(echo "$ANSIPROMPT") create_rds_db_ans
                        if [ "$create_rds_db_ans" = "1" ]; then
                                name_db_instance_identifier () {
                                        echo "\nPlease enter the database instance identifier:\n"
                                        read -p $(echo "$ANSIPROMPT") name_db_instance_identifier_ans
                                }
                                name_db_instance_identifier 
                                name_db_master_username () {
                                        echo "\nPlease enter the database master username:\n"
                                        read -p $(echo "$ANSIPROMPT") db_master_username_ans
                                }
                                name_db_master_username
                                name_db_master_user_password () {
                                        echo "\nPlease enter the database master user password:\n"
                                        read -p $(echo "$ANSIPROMPT") db_master_user_password_ans
                                        echo $db_master_user_password_ans
                                }
                                name_db_master_user_password
                                COMMAND9="aws rds create-db-instance \
                                        --allocated-storage 20 \
                                        --db-instance-class db.t2.small \
                                        --db-instance-identifier $name_db_instance_identifier_ans \
                                        --engine postgres \
                                        --engine-version 10.9 \
                                        --master-username $db_master_username_ans \
                                        --master-user-password $db_master_user_password_ans \
                                        --preferred-maintenance-window sat:02:00-sat:02:30 \
                                        --copy-tags-to-snapshot \
                                        --monitoring-interval 60 \
                                        --monitoring-role-arn arn:aws:iam::496598730381:role/rds-monitoring-role \
                                        --enable-performance-insights \
                                        --no-deletion-protection \
                                        --performance-insights-retention-period 7 \
                                        --profile $set_aws_profile_ans"
                                eval $COMMAND9
                        elif [ "$create_rds_db_ans" = "3" ]; then
                                clear
                                mainmenu
                        elif [ "$create_rds_db_ans" = "5" ]; then
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
                elif [ "$mainmenuinput" = "5" ]; then
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
elif [ "$select_aws_profile_ans" = "5" ]; then
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
