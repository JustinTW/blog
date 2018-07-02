#!/bin/bash

DEPLOY_ENV=${1-staging}

cp packages/blog/_config.sample.yml packages/blog/_config.yml
sed -i "s/FTP_HOST/${FTP_HOST}/" packages/blog/_config.yml
sed -i "s/FTP_USER/${FTP_USER}/" packages/blog/_config.yml
sed -i "s/FTP_PASS/${FTP_PASS}/" packages/blog/_config.yml

if [ $DEPLOY_ENV == "production" ]; then
  sed -i "s/staging//" packages/blog/_config.yml
fi

make build
make publish -C packages/blog
