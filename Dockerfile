FROM python:3.11-slim

# Install Ansible and SSH client
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-client \
    sshpass \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir ansible

# Set working directory
WORKDIR /ansible

# Default command
CMD ["ansible-playbook", "--version"]
