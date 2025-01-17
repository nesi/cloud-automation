# TL;DR

This is the main module that deploys the core of gen3 commons.

Multiple other modules are sub module of this one, including the VPC module, along with squi proxy.


## 1. QuickStart

```
gen3 workon <profile> <commons_name>
```

Ex.
```
$ gen3 workon cdistest test-commons
```

## 2. Table of content

- [1. QuickStart](#1-quickstart)
- [2. Table of Contents](#2-table-of-contents)
- [3. Overview](#3-overview)
- [4. Variables](#4-variables)
  - [4.1 Required Variables](#41-required-variables)
  - [4.2 Optional Variables](#42-optional-variables)
- [5. Outputs](#5-outputs)
- [6. Considerations](#6-considerations)


## 3. Overview

Once you workon the workspace, you may want to edit the config.tfvars accordingly.

There are mandatory variables, and there are a few other optionals that are set by default in the variables.tf file, but you could change them accordingly.

Ex.

```bash
# VPC name is also used in DB name, so only alphanumeric characters
vpc_name="generic-commons"
vpc_cidr_block="192.168.144.0/20"

dictionary_url="https://s3.amazonaws.com/dictionary-artifacts/datadictionary/develop/schema.json"
portal_app="dev"

aws_cert_name="arn:aws:acm:us-east-2:707767160287:certificate/c676c81c-9546-4e9a-9a72-725dd3912bc8"

# This indexd guid prefix should come from Trevar/ZAC
# indexd_prefix=ENTER_UNIQUE_GUID_PREFIX

hostname="generic-commons.planx-plan.net"
#
# Bucket in bionimbus account hosts user.yaml
# config for all commons:
#   s3://cdis-gen3-users/CONFIG_FOLDER/user.yaml
#
config_folder="dev"

google_client_secret="XXXXXXXXXXXXXXXXXXXX"
google_client_id="1234567890123455-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com"

# Following variables can be randomly generated passwords

hmac_encryption_key="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

gdcapi_secret_key="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# don't use ( ) " ' { } < > @ in password
db_password_fence="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

db_password_gdcapi="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
db_password_sheepdog="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
db_password_peregrine="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
db_password_indexd="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# password for write access to indexd
gdcapi_indexd_password="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```


## 4. Variables

### 4.1 Required Variables

| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
| db_password_fence | Admin password for fence database | string | Random number generated by gen3. |
| db_password_peregrine | Admin password for peregrine database | string | Random number generated by gen3. |
| db_password_sheepdog | Admin password for sheepdog database | string | Random number generated by gen3. |
| db_password_indexd | Admin password for indexd database | string | Random number generated by gen3. |
| dictionary_url | URL where the datadictionary of the commons is. | string |  |
| google_client_id | Google client id, for authentication purposes. Should you don't want to use google as authentication method, set this var as `""` | string | |
| google_client_secret | Secret related to the above client id. Should you don't want to use google as authentication method, set this var as `""` | string | |
| hmac_encryption_key | HMAC encryption key | string | Random number generated by gen3. |
| gdcapi_secret_key | GDCAPI secret key | string | Random number generated by gen3. |
| gdcapi_indexd_password | GDCAPI-INDEXD password | string | Random number generated by gen3. |
| config_folder | Path to user.yaml in s3://cdis-gen3-users/CONFIG_FOLDER/user.yaml | string | |




### 4.2 Optional Variables

| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
| vpc_name | The name of your commons, it is just a name that will identify your commons' resources in AWS. Must be unique if deploying multiple commons on the same account | string | "Commons1" |
| vpc_cidr_block | CIDR for your commons to live on. Currently only accepts /20 subnets. | string | "172.24.17.0/20" |
| aws_cert_name | Certificate that your commons will use, must be already provisioned in AWS Certificate Manager. Recommended to use cert's ARN | string | "AWS-CERTIFICATE-NAME" |
| csoc_account_id | Account id of the CSOC account | string | "433568766270" |
| fence_db_size | Volume size for fence database | number | 10 |
| sheepdog_db_size | Volume size for sheepdog database | number | 10 |
| indexd_db_size | Volume size for indexd database | number | 10 |
| db_password_gdcapi | Password for GDCAPI (gdcapi now deprecated in favor of sheepdog + peregrine) | string | "" |
| portal_app | Passed through to portal's APP environment to customize it | string | "dev" |
| fence_snapshot | Should fence database come from a snapshot, specify the name of the snapshot in RDS | string | "" |
| sheepdog_snapshot | Should sheepdog database come from a snapshot, specify the name of the snapshot in RDS | string | "" |
| indexd_snapshot | Should indexd database come from a snapshot, specify the name of the snapshot in RDS | string | "" |
| gdcapi_snapshot | Should gdcapi database come from a snapshot, specify the name of the snapshot in RDS | string | "" |
| fence_db_instance | Instance type for the fence database | string | "db.t2.micro" |
| sheepdog_db_instance | Instance type for the sheepdog database | string | "db.t2.micro" |
| indexd_db_instance | Instance type for the indexd database | string | "db.t2.micro" |
| hostname | Hostname that the commons will use for access | string | "dev.bionimbus.org" |
| kube_ssh_key | A list of ssh keys that will be added to compute resources deployed by this module, including squid proxy instances | string | "" |
| aws_region | Region in where to deploy the commons. The default is set to us-east-2, and might fail on any other region as for now. | string | "us-east-2" |
| ami_account_id | Account if of AMI to use for bastion host (DEPRECATED and should no longer be used) | string | "707767160287" |
| peering_cidr | CIDR from where you are running your gen3 command, usually where the adminVM is. | string | "10.128.0.0/20" |
| peering_vpc_id | Peering VPC ID. Directly related to `peering_cidr`. | string | "vpc-e2b51d99" |
| slack_webhook | Slack webhook for your commons, it might be used to send out notifications. | string | "" |
| secondary_slack_webhook | Similar as above, but if you want to send notifications to a second channel. | string | "" |
| alarm_threshold | Threshold for database storage utilization, when reached, slack webhooks would be used for alarms, the value is a number, but represents percentages | string | "85" |
| csoc_managed | If the commons will be hooked to a CSOC account | boolean | true |
| organization_name | For resource tagging purposes | string | "Basic Service" |
| fence_ha | Should you want high availability fence database | boolean | false |
| sheepdog_ha | Should you want high availability sheepdog database | boolean | false |
| indexd_ha | Should you want high availability indexd database | boolean | false |
| fence_maintenance_window | Maintenance window for fence database | string | "SAT:09:00-SAT:09:59" |
| sheepdog_maintenance_window | Maintenance window for sheepdog database | string | "SAT:10:00-SAT:10:59" |
| indexd_maintenance_window | Maintenance window for indexd database | string | "SAT:11:00-SAT:11:59" |
| fence_backup_retention_period | How many snapshots should be keep for fence | string | "4" |
| sheepdog_backup_retention_period | How many snapshots should be keep for sheepdog | string | "4" |
| indexd_backup_retention_period | How many snapshots should be keep for indexd | string | "4" |
| fence_backup_window | Backup window for fence database | string | "06:00-06:59" |
| sheepdog_backup_window | Backup window for sheepdog database | string | "07:00-07:59" |
| indexd_backup_window | Backup window for indexd database | string | "08:00-08:59" |
| fence_engine_version | Engine version for fence Postgres database | string | "9.6.11" |
| sheepdog_backup_window | Backup window for sheepdog database | string | "06:00-06:59" |
| indexd_backup_window | Backup window for indexd database | string | "06:00-06:59" |
| fence_auto_minor_version_upgrade | Should fence database minor version updates happen automatically | string | "true" |
| sheepdog_auto_minor_version_upgrade | Should sheepdog database minor version updates happen automatically | string | "true" |
| indexd_auto_minor_version_upgrade | Should indexd database minor version updates happen automatically | string | "true" |
| users_bucket_name | Bucket name where to pull users.yaml for permissions, This one should replace the bucket used in `config_folder` | string | default "cdis-gen3-users" |
| fence_database_name | Name of fence database. Not the same as instance identifier | string | "fence" |
| sheepdog_database_name | Name of sheepdog database. Not the same as instance identifier | string | "gdcapi" |
| indexd_database_name | Name of indexd database. Not the same as instance identifier | string | "indexd" |
| fence_db_username | Username to use for fence database | string | "fence_user" |
| sheepdog_db_username | Username to use for sheepdog database | string | "sheepdog" |
| indexd_db_username | Username to use for indexd database | string | "indexd_user" |
| fence_allow_major_version_upgrade | Should fence database allow amjor versions update automatically | string | "true" |
| sheepdog_allow_major_version_upgrade | Should sheepdog database allow amjor versions update automatically | string | "true" |
| indexd_allow_major_version_upgrade | Should indexd database allow amjor versions update automatically | string | "true" |
| ha-squid_instance_type | Instance type for HA squid | string | t3.medium |
| ha-squid_instance_drive_size | Volume size for HA squid instances | number | 8 |
| deploy_single_proxy | Should you want to use the single instance model instead of HA | boolean | true |
| ha-squid_bootstrap_script | Bootstrap script for HA squid instance in `cloud-automation/flavors/squid_auto` | string | "squid_running_on_docker.sh" |
| ha-squid_extra_vars | If the bootstrap script needs additional variables, they can be added to this list | list | ["squid_image=master"] |
| fence-bot_bucket_access_arns | Should fence bot user access additional data buckets, list their ARN  here | list | [] |
| deploy_ha_squid | If HA squid will be present as proxy | boolean | false |
| ha-squid_cluster_desired_capasity | The desired number of instances for HA squid | number | 2 |
| ha-squid_cluster_min_size | Minimun number of instances in the autoscaling group for HA squid | number | 1 |
| ha-squid_cluster_max_size | Maximun number of instances in the autoscaling group for HA squid | number | 3 |
| deploy_fence_db | Whether or not to deploy the database instance | boolean | true |
| deploy_sheepdog_db | Whether or not to deploy the database instance | boolean | true |
| deploy_indexd_db | Whether or not to deploy the database instance | boolean | true |
| fence_engine | Engine to deploy the db instance on | string | "postgres" |
| sheepdog_engine | Engine to deploy the db instance on | string | "postgres" |
| indexd_engine | Engine to deploy the db instance on | string | "postgres" |
| single_squid_instance_type | Instance type for squid single instance model | string | "t2.micro" |
| network_expansion | Let k8s workers be on a /22 subnet per AZ | boolean | false |
| branch | For testing purposes, when something else than the master | string | "master" |
| mailgun_api_key | Mailgun api key (NO CURRENTLY IN USE) | string | "" |
| mailgun_smtp_host | Mailgun SMTP (NO CURRENTLY IN USE) | string | "smtp.mailgun.org" | 
| mailgun_api_url | Mailgun api url (NO CURRENTLY IN USE) | string | "https://api.mailgun.net/v3/" |
| fence_max_allocated_storage | Maximum storage allocation for autoscaling | number | 0 |
| sheepdog_max_allocated_storage | Maximum storage allocation for autoscaling | number | 0 |
| indexd_max_allocated_storage | Maximum storage allocation for autoscaling | number | 0 |


## 5. Outputs

| Name | Description | 
|------|-------------|
| aws_region | Region where resources were deployed |
| vpc_name | Name of the commmons' VPC |
| vpc_cidr_block | CIDR of the VPC |
| fence_rds_id | ID of fence database |
| gdcapi_rds_id | ID of sheepdog database |
| indexd_rds_id | ID of indexd database |
| fence-bot_user_secret | Secret to use for the fence bot user |
| fence-bot_user_id | User id for the fence bot user |
| data-bucket_name | Name of the data bucket |


## 6. Consideration

If you want later on deploy EKS using a /22 subnet for the workers private network, set `network_expansion=true` this re-arranges the entire network subnets, so it will destroy the databases to make room for the new subnets.

