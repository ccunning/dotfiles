# Best alias ever
alias please='sudo $(fc -ln -1)'

# User specific aliases and functions
alias t='~/.todo/todo.sh -t'
alias td='~/.todo/todo.sh -t -d /home/ccunning/.todo/todo_dhs.cfg'
alias rdp="xfreerdp --sec rdp --plugin cliprdr -g 1440x900"
alias ltr="ls -ltr"
alias dc="docker-compose"
alias n='terminal_velocity'
alias c='cd ~/Projects'
alias iac='cd ~/Projects/IAC'
alias ssh-copy-id='ssh-copy-id -i ~/.ssh/id_ed25519 -o PubkeyAuthentication=no'
alias shn='shutdown -h now'
alias say='spd-say'
alias ac='aws-cred'
alias ap='source aws-prof'
alias tg='terragrunt'
alias powershell='pwsh'
alias ami='aws ec2 describe-images | jq -r '\''.["Images"][] | .["Name"] + ": " + .["ImageId"]'\'' | sort'
alias ami-west='aws ec2 describe-images | jq -r '\''.["Images"][] | .["Name"] + ": " + .["ImageId"]'\'' | sort'
alias instances='aws ec2 describe-instances --filters Name=instance-state-name,Values=running | jq -r '\''.["Reservations"][]["Instances"][] | .["InstanceId"] + ": " + (.["Tags"][] | select(.Key=="Name") | .["Value"])'\'
alias aws_inv='for profile in $(aws configure list-profiles); do aws ec2 describe-instances --profile $profile | jq -r '\''.["Reservations"][]["Instances"][] | (.["Tags"][] | select(.Key=="Name") | .["Value"]) + "," + .["PrivateIpAddress"]'\''; done'
alias wacom="~/bin/set_wacom"
alias ssm="aws ssm start-session --target"
alias ssh-add="ssh-add ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_git"
alias av="aws-vault"
