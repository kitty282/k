#!/bin/sh
set -e

echo "=== Starting 3proxy ==="
3proxy /etc/3proxy/3proxy.cfg &
PROXY_PID=$!

echo "=== Starting nginx ==="
nginx -g 'daemon off;' &
NGINX_PID=$!

# При получении SIGTERM/SIGINT корректно прерываем оба процесса
trap "echo 'Shutting down…'; kill -TERM $PROXY_PID $NGINX_PID" TERM INT

# Ждём, пока один из процессов завершится
wait -n $PROXY_PID $NGINX_PID
exit $?
