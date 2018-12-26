#!/bin/bash

# Stop if there are any errors
set -e

###################################################################
# Script Name	: Terraform with Google Cloud Platform Bootstrapper 
# Description	: Broadly based upon the community guide from Google
#               https://bit.ly/2BBDk1Q, designed to be idempotent.
# Args        : None, however environment.sh must be configured                                                                                           
# Author      : Richard Slater
# Email       : webmaster@slaterfamily.name                                           
###################################################################

# Configuration Variables, tweak these based upon changes to GCP.
PROJECT_ROLES='roles/viewer roles/storage.admin roles/compute.viewer'
ORG_ROLES='roles/resourcemanager.projectCreator roles/billing.user roles/browser'
REQUIRED_SERVICES='cloudresourcemanager.googleapis.com cloudbilling.googleapis.com iam.googleapis.com compute.googleapis.com'

# Script Root for this script, used to source environment.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Import the environment variables
source $DIR/environment.sh

# Shortcuts for Colours
RED="\e[31m"
GREEN="\e[32m"
RESET="\e[39m"

# Extract and validate the organisation from gcloud configuration
CURRENT_ORG=$(gcloud organizations list --format=json | jq ".[] | select(.name | contains(\"organizations/$TF_VAR_org_id\"))")

DIRTY=0
if [[ "$CURRENT_ORG" == "" ]]
  then
    echo -e "${RED}Organisation ID${RESET}: The Organisation ID listed in the \$TF_VAR_org_id variables ($TF_VAR_org_id) doesn't appear to be configured in gcloud."
    DIRTY=1
  else
    echo -e "${GREEN}Organisation ID${RESET}: The Organisation ID ($TF_VAR_org_id) is configured in gcloud."
fi

# Extract and validate the billing account from gcloud configuration
CURRENT_BILLING_ACT=$(gcloud beta billing accounts list --format=json | jq ".[] | select(.name | contains(\"billingAccounts/$TF_VAR_billing_account\"))")

if [[ "$CURRENT_BILLING_ACT" == "" ]]
  then
    echo -e "${RED}Billing Account${RESET}: The Billing Account listed in the \$TF_VAR_billing_account variables ($TF_VAR_billing_account) doesn't appear to be configured in gcloud."
    DIRTY=1
  else
    echo -e "${GREEN}Billing Account${RESET}: The Billing Account ($TF_VAR_billing_account) is configured in gcloud."
fi

if [[ "$TF_VAR_admin_project" == "" ]]
  then
    echo -e "${RED}Admin Project${RESET}: The Admin Project in the \$TF_VAR_admin_project variables doesn't appear to be set."
    DIRTY=1
  else
    echo -e "${GREEN}Admin Project${RESET}: The Admin Project ($TF_VAR_admin_project) is set."
fi

if [[ "$DIRTY" == "1" ]]
  then
    echo -e "${RED}Error${RESET}: One of more guard clauses failed check environment.sh and gcloud configuration matches up"
    exit 1
fi

# Create the project if it does not already exist
EXISTING_PROJECT=$(gcloud projects list --filter=name:richardslater-terraform-admin --format=json)

if [[ "$EXISTING_PROJECT" == "[]" ]]
  then
    echo -e "${GREEN}Admin Project${RESET}: The Admin Project ($TF_VAR_admin_project) does not exist yet, creating it and linking it to the billing account."
    gcloud projects create ${TF_VAR_admin_project} --organization ${TF_VAR_org_id} --set-as-default
    gcloud beta billing projects link ${TF_VAR_admin_project} --billing-account ${TF_VAR_billing_account}
  else
    echo -e "${GREEN}Admin Project${RESET}: The Admin Project ($TF_VAR_admin_project) already exists."
fi

TF_PROJECT=$(gcloud projects list --format='value(projectNumber)' --filter=name:$TF_VAR_admin_project)
echo -e "${GREEN}Admin Project${RESET}: The Admin Project ($TF_VAR_admin_project) ID is $TF_PROJECT."

# Enable the required services

for svc in $REQUIRED_SERVICES
do
  echo -e "${GREEN}Admin Project${RESET}: Enabling $svc."
  gcloud services enable "$svc"
done

# Create the user if it does not exist

EXISTING_USER=$(gcloud iam service-accounts list --format=json --filter=name:terraform)

if [[ "$EXISTING_USER" == "[]" ]]
  then
    echo -e "${GREEN}Terraform User${RESET}: The Terraform does not exist yet, creating it and granting permissions."
    gcloud iam service-accounts create terraform --display-name "Terraform admin account"
 
    echo -e "${GREEN}Terraform User${RESET}: Downloading JSON credentials."
    gcloud iam service-accounts keys create ${TF_CREDS} --iam-account terraform@${TF_VAR_admin_project}.iam.gserviceaccount.com
  else
    echo -e "${GREEN}Terraform User${RESET}: The Admin Project ($TF_VAR_admin_project) already exists."
fi

# Assign roles for the user, don't need to check first as this works repeatedly

for prole in $PROJECT_ROLES
do
  echo -e "${GREEN}Terraform User${RESET}: Granting $prole role to the Admin Project ($TF_VAR_admin_project)."
  gcloud projects add-iam-policy-binding ${TF_VAR_admin_project} --member serviceAccount:terraform@${TF_VAR_admin_project}.iam.gserviceaccount.com --role $prole
done

for orole in $ORG_ROLES
do
  echo -e "${GREEN}Terraform User${RESET}: Granting $orole role to the organisation."
  gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} --member serviceAccount:terraform@${TF_VAR_admin_project}.iam.gserviceaccount.com --role $orole
done

# All done

echo -e "${GREEN}Bootstrap${RESET}: Bootstrapping Complete."
