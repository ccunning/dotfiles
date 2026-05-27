#!/bin/bash


# Set default values for the parameters
TERRAGRUNT_CACHE=true
TERRAFORM_PROVIDERS=false
MV_TFLOCK=false
DEL_TFLOCK=false
VERBOSE=false
DRY_RUN=false
BACKGROUND_OP=""

# Function to display script usage
usage() {
    echo "# Script to recursively initialize dependencies for Terragrunt"
    echo "Usage: $0 [-cplLvh]"
    echo "  -c        Toggle clearing the terragrunt-cache (default true)."
    echo "  -p        Reinitialize provider caches (default false)"
    echo "  -l        Move the terraform.lock.hcl files to .old (default false)"
    echo "  -L        Delete the terraform.lock.hcl files (use with caution, supercedes move)"
    echo "  -b        Have each init in a background process (default false)."
    echo "  -v        Enable verbose mode (default false)."
    echo "  -d        Enable dry-run mode (default false)."
    echo "  -h        Display this help message."
    exit 1
}

# Parse command-line arguments using getopts
# The string 'u:o:vh' tells getopts what to expect:
# - 'u:' and 'o:' mean the -u and -o options require an argument.
# - 'v' and 'h' mean the -v and -h options are simple flags without arguments.
while getopts "cplLbvdh" opt; do
  case ${opt} in
    c )
      TERRAGRUNT_CACHE=false
      ;;
    p )
      TERRAFORM_PROVIDERS=true
      ;;
    l )
      MV_TFLOCK=true
      ;;
    L )
      DEL_TFLOCK=true
      ;;
    b )
      BACKGROUND_OP='&'
      ;;
    v )
      VERBOSE=true
      ;;
    d )
      DRY_RUN=true
      ;;
    h )
      usage
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
  esac
done

for dep in $(terragrunt list --dependencies --external --dag --experiment cli-redesign); do
  echo "=== $dep ==="
  eval "(
    cd $dep
    # Set DEBUG logging for terraform
    if $VERBOSE; then
      if $DRY_RUN; then
        echo '$dep: TF_LOG="DEBUG"'
      else
        TF_LOG="DEBUG"
      fi
    fi

    # Clear Terragrunt cache
    if $TERRAGRUNT_CACHE; then
      if $DRY_RUN; then
        echo '$dep: rm -rf .terragrunt-cache'
      else
        rm -rf .terragrunt-cache
      fi
    fi

    # Delete or Move the TF lock file
    if $DEL_TFLOCK; then
      if $DRY_RUN; then
        echo '$dep: rm -f .terraform.lock.hcl'
      else
        rm -f .terraform.lock.hcl
      fi
    elif $MV_TFLOCK; then
      if $DRY_RUN; then
        echo '$dep: mv -f .terraform.lock.hcl .terraform.lock.old'
      else
        mv -f .terraform.lock.hcl .terraform.lock.old
      fi
    fi

    # Reinitialize providers in the lock file with all platforms
    if $TERRAFORM_PROVIDERS; then
      if $DRY_RUN; then
        echo '$dep: terragrunt providers lock -platform=linux_arm64 -platform=linux_amd64 -platform=darwin_amd64 -platform=darwin_arm64'
      else
        terragrunt providers lock -platform=linux_arm64 -platform=linux_amd64 -platform=darwin_amd64 -platform=darwin_arm64
      fi
    fi

    # Run the terragrunt init on that folder
    if $DRY_RUN; then 
      echo '$dep: terragrunt init'
    else
      terragrunt init
    fi
  ) $BACKGROUND_OP"
done

wait
