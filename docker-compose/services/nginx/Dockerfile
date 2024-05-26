# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM node:20.12.2-bullseye as builder
RUN apt update && apt upgrade -y && apt install software-properties-common -y
RUN apt install -y --no-install-recommends \
    git \
    python3 \
    jq

RUN corepack enable

# nginx 1.25.3
FROM nginx:1.25.3-bookworm as base
COPY proxy/default.conf.template /etc/nginx/conf.d/default.conf

# Install Certbot by Pip
RUN apt update && apt upgrade -y
RUN apt install python3 python3-venv libaugeas0 -y
# Set up a Python virtual environment for Certbot
RUN python3 -m venv /opt/certbot/
RUN /opt/certbot/bin/pip install --upgrade pip
# Install Certbot
RUN /opt/certbot/bin/pip install certbot certbot-nginx
RUN ln -s /opt/certbot/bin/certbot /usr/bin/certbot

EXPOSE 80 443 8080 8081
COPY services/nginx/init.sh /init.sh
RUN chmod +x /init.sh
CMD ["/init.sh"]
