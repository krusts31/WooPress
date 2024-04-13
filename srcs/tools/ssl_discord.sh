WEBHOOK_URL="https://discordapp.com/api/webhooks/1167886507953107114/PzNNn8tn0SYYZQPeH9hA_DBRi7aXFxrIfTZ6SRBZGky9hObq8n2dqmGztGIftOpKyq9Q"
MESSAGE_CONTENT="Your ssl olgrounds certificate will expire soon!"

curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE_CONTENT\"}" $WEBHOOK_URL
