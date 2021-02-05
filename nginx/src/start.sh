#!/bin/sh

/usr/bin/envsubst < /etc/nginx/nginx.conf.envsubst > /etc/nginx/nginx.conf
exec nginx -g "daemon off;";
