#!/bin/sh
set -e

PORT=${PORT:-8080}
echo "✅ Ginagamit na port: $PORT"

# Siguraduhing mapapalitan ang port sa nginx.conf
sed -i "s/listen\s*[0-9]*\(.*\);/listen $PORT\1;/g" /usr/local/openresty/nginx/conf/nginx.conf

echo "🚀 Sinisimulan ang Xray..."
/usr/local/bin/xray run -config /etc/xray.json &
XRAY_PID=$!

# Magbigay ng maikling segundo para mag-initialize ang Xray
sleep 1

echo "🌐 Sinisimulan ang OpenResty sa port $PORT..."
exec /usr/local/openresty/bin/openresty -g "daemon off;"
