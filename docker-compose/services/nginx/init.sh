#!/bin/sh

set -xe

# start nginx in background
nginx -g "daemon on;"
# create a certificate
certbot --nginx --non-interactive --agree-tos --keep-until-expiring --email "george@glitchd.network" -d explorer.glitchd.network -d explorer.jieyoubaoapp.com --no-redirect --verbose
# reload nginx
nginx -s quit
nginx -g "daemon off;"
