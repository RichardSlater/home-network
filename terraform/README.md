# Terraform

Configures Google Cloud and G-Suite.

## Pre-requisites

 - Google Cloud Account created.
 - Billing configured in Google Cloud.
 - Bootstrapping completed successfully.
 
## Configure the Shell

    source bootstrap/environment.sh

### Checking the environment

Running:

    gcloud organizations list --format=json

Should result in something similar to:

    [                                              
      {                                            
        "creationTime": "2018-12-17T16:20:45.405Z",
        "displayName": "slaterfamily.name",        
        "lifecycleState": "ACTIVE",                
        "name": "organizations/862145970828",      
        "owner": {                                 
          "directoryCustomerId": "C03834put"       
        }                                          
      }                                            
    ]                                              

And running:

    gcloud beta billing accounts list --format=json

Should result in something similar to:

    [          
      {          
        "displayName": "My Billing Account",
        "name": "billingAccounts/01D50D-302263-962D85",
        "open": true                
      }                                           
    ]

## Setup 

## Executing Terraform

Commands to execute:

    $ terraform init
    $ terraform plan
    $ terraform apply
