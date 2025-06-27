#!/bin/bash -p

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <repository_relative_path> <secret>"
  echo "Example: GH_TOKEN=<token> $0 gh_user/my_repo \$( < ~/var/secrets/jenkins-webhook-secret )"
  exit 1
fi

gh api \
  --method POST \
  -H "Accept: application/vnd.github.v3+json" \
  /repos/$1/hooks \
  -f name=web \
  -F active=true \
  -f events[]="push" \
  -f events[]="pull_request" \
  -f events[]="check_run" \
  -f events[]="issue_comment" \
  -f events[]="repository" \
  -f config[url]="https://jenkins.hope.nyc.ny.us/github-webhook/" \
  -f config[secret]="$2" \
  -f config[content_type]="json"
