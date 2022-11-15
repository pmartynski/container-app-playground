#!/usr/bin/env bash

terraform -chdir=./infrastructure plan -out=plan
terraform -chdir=./infrastructure apply 'plan'

terraform -chdir=./deploy plan -out=plan
terraform -chdir=./deploy apply 'plan'
