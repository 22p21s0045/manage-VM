# ============================================================================
# Makefile for VM Management with Terraform and Ansible
# ============================================================================

.PHONY: help create-vm destroy-vm plan-vm init-terraform wait-for-ssh \
        init-vm setup-base-package \
        deploy-monitor-stack deploy-prometheus deploy-grafana deploy-node-exporter deploy-project \
        clean-monitor-stack clean-prometheus clean-grafana clean-node-exporter clean-project \
        setup-all clean

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
	@echo "  make init-terraform      - Initialize Terraform"
	@echo "  make plan-vm             - Preview VM changes"
	@echo "  make create-vm           - Create VM on Proxmox"
	@echo "  make destroy-vm          - Destroy VM"
	@echo ""
	@echo "Base Setup:"
	@echo "  make init-vm             - Run site.yml (full setup)"
	@echo "  make setup-base-package  - Setup base packages"
	@echo ""
	@echo "Deploy:"
	@echo "  make deploy-monitor-stack  - Deploy all monitoring"
	@echo "  make deploy-prometheus     - Deploy Prometheus"
	@echo "  make deploy-grafana        - Deploy Grafana"
	@echo "  make deploy-node-exporter  - Deploy Node Exporter"
	@echo "  make deploy-project        - Deploy project"
	@echo ""
	@echo "Clean:"
	@echo "  make clean-monitor-stack   - Clean all monitoring"
	@echo "  make clean-prometheus      - Clean Prometheus"
	@echo "  make clean-grafana         - Clean Grafana"
	@echo "  make clean-node-exporter   - Clean Node Exporter"
	@echo "  make clean-project         - Clean project"
	@echo ""
	@echo "Combined Workflows:"
	@echo "  make setup-all           - Create VM + Initialize (full setup)"
	@echo "  make clean               - Destroy everything"
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
	@echo "🔧 Initializing VM with site.yml playbook"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/site.yml --ask-vault-pass"
	@echo "✅ VM initialization complete!"

setup-base-package: ## Install Docker on VM
	@echo "🐳 Setup base package on all hosts"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/base-package-setup.yml"
	@echo "✅ Base package setup complete!"
	
deploy-monitor-stack: ## Deploy Monitor Node Exporter
	@echo "📊 Deploying Monitoring Service"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook -i inventory/hosts.ini site.yml --tags "deploy-grafana,deploy-node-exporter,deploy-prometheus" --ask-vault-pass"
	@echo "✅ Monitor Node Exporter deployed!"

deploy-prometheus: ## Deploy Prometheus
	@echo "📈 Deploying Prometheus"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/prometheus-deploy.yml"
	@echo "✅ Prometheus deployed!"

deploy-grafana: ## Deploy Grafana
	@echo "📈 Deploying Grafana"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/grafana-deploy.yml --ask-vault-pass"
	@echo "✅ Grafana deployed!"

deploy-node-exporter: ## Deploy Node Exporter
	@echo "📈 Deploying Node Exporter"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/node-exporter-deploy.yml"
	@echo "✅ Node Exporter deployed!"

deploy-project: ## Deploy project to VM
	@echo "📦 Deploying project..."
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/project-deploy.yml"
	@echo "✅ Project deployed!"

clean-monitor-stack: ## Clean Monitor Node Exporter
	@echo "🧹 Cleaning Monitoring Service"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook -i inventory/hosts.ini site.yml --tags "clean-grafana,clean-node-exporter,clean-prometheus" --ask-vault-pass"
	@echo "✅ Monitor Node Exporter cleaned!"

clean-prometheus: ## Clean Prometheus
	@echo "🧹 Cleaning Prometheus"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/prometheus-clean.yml"
	@echo "✅ Prometheus cleaned!"

clean-grafana: ## Clean Grafana
	@echo "🧹 Cleaning Grafana"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/grafana-clean.yml"
	@echo "✅ Grafana cleaned!"

clean-node-exporter: ## Clean Node Exporter
	@echo "🧹 Cleaning Node Exporter"
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/node-exporter-clean.yml"
	@echo "✅ Node Exporter cleaned!"

clean-project: ## Clean project from VM
	@echo "🧹 Cleaning project..."
	docker compose run --rm ansible sh -c "\
		mkdir -p /root/.ssh && \
		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
		chmod 600 /root/.ssh/id_ed25519 && \
		ansible-playbook playbooks/project-clean.yml"
	@echo "✅ Project cleaned!"

# run-site: ## Run site.yml playbook
# 	@echo "🔧 Running site.yml playbook..."
# 	docker compose run --rm ansible sh -c "\
# 		mkdir -p /root/.ssh && \
# 		cp /tmp/id_ed25519 /root/.ssh/id_ed25519 && \
# 		chmod 600 /root/.ssh/id_ed25519 && \
# 		ansible-playbook playbooks/site.yml --ask-vault-pass"
# 	@echo "✅ site.yml playbook run complete!"

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
