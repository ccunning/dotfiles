#!/bin/bash

for profile in $(aws configure list-profiles); do
    export AWS_PROFILE=${profile}
    /usr/local/bin/aws-parse-inventory.py
done
