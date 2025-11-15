# Makefile for linux-setup
# Provides convenient shortcuts for common tasks

.PHONY: help install install-minimal install-docker install-dev system-info update docker-build docker-run clean

# Default target
help:
	@echo "Linux Setup - Available targets:"
	@echo ""
	@echo "  make install          - Full installation (essential + dev + docker)"
	@echo "  make install-minimal  - Minimal installation (essential only)"
	@echo "  make install-docker   - Install Docker and container tools"
	@echo "  make install-dev      - Install development tools"
	@echo "  make system-info      - Display system information"
	@echo "  make update           - Update system packages"
	@echo "  make docker-build     - Build Docker image"
	@echo "  make docker-run       - Run Docker container"
	@echo "  make docker-compose   - Start with docker-compose"
	@echo "  make clean            - Clean temporary files"
	@echo "  make help             - Show this help message"
	@echo ""

# Installation targets
install:
	@echo "Running full installation..."
	sudo ./install.sh --full

install-minimal:
	@echo "Running minimal installation..."
	sudo ./install.sh --minimal

install-docker:
	@echo "Installing Docker..."
	sudo ./install.sh --docker

install-dev:
	@echo "Installing development tools..."
	sudo ./install.sh --dev

# Utility targets
system-info:
	@bash scripts/utils/system-info.sh

update:
	@echo "Updating system..."
	@sudo bash scripts/utils/update-system.sh

# Docker targets
docker-build:
	@echo "Building Docker image..."
	docker build -t ubuntu-devenv:latest .

docker-run:
	@echo "Running Docker container..."
	docker run -it --rm -v $(PWD):/workspace ubuntu-devenv:latest

docker-compose:
	@echo "Starting with docker-compose..."
	docker-compose up -d
	@echo "Container started. Attach with: docker-compose exec devenv bash"

docker-stop:
	@echo "Stopping docker-compose..."
	docker-compose down

# Maintenance
clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.backup-*" -delete
	@find . -name "*.log" -delete
	@echo "Clean complete"

# Testing
test:
	@echo "Running syntax checks..."
	@for script in install.sh scripts/**/*.sh; do \
		bash -n "$$script" && echo "✓ $$script" || exit 1; \
	done
	@echo "All scripts validated successfully"
