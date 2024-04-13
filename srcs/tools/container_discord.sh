WEBHOOK_URL="https://discordapp.com/api/webhooks/1167886770541703211/daZPK1_60K7YJyo83ixvXjQaTVwIY4MjYR-ct7QahUQGlM-EPQS0yLODHngVq8ZkC3o3"

CONTAINER="$@"

MESSAGE_CONTENT="container $CONTAINER has crashed"

curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE_CONTENT\"}" $WEBHOOK_URL
