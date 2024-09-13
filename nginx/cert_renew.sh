#!/usr/bin/env bash

set -uex

acme=~/.acme.sh/acme.sh

systemctl stop nginx

# $acme --cron --home /root/.acme.sh --force --debug

domain_names=("$@")
main_domain_name="${domain_names[0]}"

args=""

for i in "${domain_names[@]}"; do
    args+=" -d $i"
done

$acme --issue --standalone $args

mkdir -p /etc/ssl/$main_domain_name

~/.acme.sh/acme.sh --installcert --ecc --force \
                   -d $main_domain_name \
                   --fullchainpath /etc/ssl/$main_domain_name/fullchain.pem \
                   --keypath /etc/ssl/$main_domain_name/privkey.pem

systemctl start nginx
