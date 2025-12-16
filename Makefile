# ============================================================================
# Makefile for VM Management with Terraform and Ansible
# ============================================================================

.PHONY: help create-vm destroy-vm plan-vm init-terraform \
        init-vm install-docker deploy-project deploy-monitoring deploy-monitor deploy-prometheus \
        setup-all clean status wait-for-ssh

# Default target
.DEFAULT_GOAL := help

# ============================================================================
# HELP
# ============================================================================

help: ## Show this help message
	@echo "=============================================="
	@echo "  VM Management - Available Commands"
	@echo "=============================================="
	@echo ""
	@echo "Terraform (VM Creation):"
	@echo "  make init-terraform  - Initialize Terraform"
	@echo "  make plan-vm         - Preview VM changes"
	@echo "  make create-vm       - Create VM on Proxmox"
	@echo "  make destroy-vm      - Destroy VM"
	@echo ""
	@echo "Ansible (VM Configuration):"
	@echo "  make init-vm         - Run all playbooks (site.yml)"
	@echo "  make install-docker  - Install Docker only"
	@echo "  make deploy-project  - Deploy project only"
	@echo "  make deploy-monitoring - Deploy monitoring (Node Exporter)"
	@echo "  make deploy-monitor  - Deploy Monitor to VM"
	@echo "  make deploy-prometheus - Deploy Prometheus + Grafana to monitor-node"
	@echo ""
	@echo "Combined Workflows:"
	@echo "  make setup-all       - Create VM + Initialize (full setup)"
	@echo "  make clean           - Destroy everything"
	@echo ""

# ============================================================================
# TERRAFORM - VM Creation
# ============================================================================

init-terraform: ## Initialize Terraform
	@echo "🔧 Initializing Terraform..."
	cd terraform && docker compose run --rm init

plan-vm: ## Preview VM changes (terraform plan)
	@echo "📋 Planning VM changes..."
	cd terraform && docker compose run --rm plan

create-vm: ## Create VM on Proxmox (terraform apply)
	@echo "🚀 Creating VM..."
	cd terraform && docker compose run --rm apply
	@echo "✅ VM created successfully!"

destroy-vm: ## Destroy VM (terraform destroy)
	@echo "💥 Destroying VM..."
	cd terraform && docker compose run --rm destroy
	@echo "✅ VM destroyed!"

wait-for-ssh: ## Wait for VM SSH to be ready (with retry)
	@echo "Waiting for VM SSH to be ready..."
	docker compose run --rm ansible sh scripts/wait-for-ssh.sh

# ============================================================================
# ANSIBLE - VM Configuration
# ============================================================================

init-vm: ## Run all Ansible playbooks (site.yml)
	@echo "🔧 Initializing VM with all playbooks..."
	docker compose run --rm ansible
	@echo "✅ VM initialization complete!"

install-docker: ## Install Docker on VM
	@echo "🐳 Installing Docker..."
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook -i inventory/hosts.ini playbooks/install-docker.yml"
	@echo "✅ Docker installed!"

deploy-project: ## Deploy project to VM
	@echo "📦 Deploying project..."
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook -i inventory/hosts.ini playbooks/deploy-project.yml"
	@echo "✅ Project deployed!"

deploy-monitoring: ## Deploy monitoring stack to VM
	@echo "📊 Deploying monitoring..."
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook -i inventory/hosts.ini playbooks/deploy-monitoring.yml"
	@echo "✅ Monitoring deployed!"

deploy-monitor: ## Deploy Monitor to VM
	@echo "📊 Deploying monitor..."
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook -i inventory/hosts.ini site.yml --tags grafana --ask-vault-pass"
	@echo "✅ Monitor deployed!"

# deploy-prometheus: ## Deploy Prometheus + Grafana to monitor-node
# 	@echo "📈 Deploying Prometheus + Grafana..."
# 	docker compose run --rm ansible sh -c "\
# 		mkdir -p /root/.ssh && \
# 		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
# 		chmod 600 /root/.ssh/id_ed25519 && \
# 		ansible-playbook -i inventory/hosts.ini playbooks/deploy-prometheus.yml"
# 	@echo "✅ Prometheus + Grafana deployed!"

deploy-prometheus: ## Deploy Prometheus
	@echo "📈 Deploying Prometheus"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook -i inventory/hosts.ini site.yml --tags prometheus --ask-vault-pass"
	@echo "✅ Prometheus deployed!"

# ============================================================================
# COMBINED WORKFLOWS
# ============================================================================

setup-all: init-terraform create-vm wait-for-ssh init-vm ## Full setup: Create VM + Initialize
	@echo ""
	@echo "=============================================="
	@echo "🎉 Full setup complete!"
	@echo "=============================================="

clean: destroy-vm ## Clean up: Destroy VM
	@echo "🧹 Cleanup complete!"
