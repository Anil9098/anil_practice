#!/bin/bash

set -e

# ssh on ec2 and run commands

ssh -T ~/.ssh/id_rsa ubuntu@13.233.100.250 << EOF
  # Commands to run on the EC2 instance
  echo "Running script on EC2 instance"
EOF






