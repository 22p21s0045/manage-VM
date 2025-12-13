#!/bin/sh
# Wait for SSH to be ready with retry logic

MAX_ATTEMPTS=10
DELAY=15

mkdir -p /root/.ssh
cp /tmp/id_ed25519 /root/.ssh/id_ed25519
chmod 600 /root/.ssh/id_ed25519

attempt=1
while [ $attempt -le $MAX_ATTEMPTS ]; do
    echo "  Attempt $attempt/$MAX_ATTEMPTS..."
    
    if ansible all -i inventory/hosts.ini -m ping 2>/dev/null; then
        echo "SSH is ready!"
        exit 0
    fi
    
    echo "  SSH not ready, waiting $DELAY seconds..."
    sleep $DELAY
    attempt=$((attempt + 1))
done

echo "Failed to connect after $MAX_ATTEMPTS attempts"
exit 1
