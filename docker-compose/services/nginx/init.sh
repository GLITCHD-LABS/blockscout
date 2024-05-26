#!/bin/sh

set -xe

# start nginx in background
nginx -g "daemon on;"
# create a certificate
# apply for the certificates separately as a way to avoid the request limit
certbot --nginx --non-interactive --agree-tos --keep-until-expiring --email "taoqinget@gmail.com" -d explorer.glitchd.network -d explorer.jieyoubaoapp.com --no-redirect --verbose
# reload nginx
nginx -s quit
nginx -g "daemon off;"
