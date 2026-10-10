#!/bin/sh
set -e

PORT=${PORT:-8080}
echo "✅ Ginagamit na port: $PORT"

sed -i "s/listen\s*[0-9]*;/listen $PORT;/g" /usr/local/openresty/nginx/conf/nginx.conf

echo "🚀 Sinisimulan ang Xray..."
/usr/local/bin/xray run -config /etc/xray.json &
XRAY_PID=$!

echo "🌐 Sinisimulan ang OpenResty sa port $PORT (May Anti-DDoS WAF / Rate Limiting)..."
exec /usr/local/openresty/bin/openresty -g "daemon off;"

wait $XRAY_PID
echo "⚠️ Tumigil ang Xray, isinasara ang server..."
kill -TERM 1
