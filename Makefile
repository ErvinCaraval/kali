.PHONY: help kali-run kali-test docker-build docker-up docker-down docker-logs docker-test clean

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color
BOLD := \033[1m

# Default target
help:
	@echo "$(BOLD)$(BLUE)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BOLD)$(BLUE)║  VULNERABLE APPLICATION - MAKEFILE                         ║$(NC)"
	@echo "$(BOLD)$(BLUE)║  Network Reconnaissance Training (Nmap PoC)                ║$(NC)"
	@echo "$(BOLD)$(BLUE)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(BOLD)KALI LINUX (VirtualBox) - Direct Execution:$(NC)"
	@echo "  $(GREEN)make kali-run$(NC)          - Run vulnerable app directly"
	@echo "  $(GREEN)make kali-test$(NC)         - Run and test services"
	@echo ""
	@echo "$(BOLD)DOCKER - Containerized Execution:$(NC)"
	@echo "  $(GREEN)make docker-build$(NC)      - Build Docker image"
	@echo "  $(GREEN)make docker-up$(NC)         - Start container (docker-compose)"
	@echo "  $(GREEN)make docker-down$(NC)       - Stop container"
	@echo "  $(GREEN)make docker-logs$(NC)       - View container logs"
	@echo "  $(GREEN)make docker-test$(NC)       - Test with nmap inside container"
	@echo ""
	@echo "$(BOLD)UTILITY:$(NC)"
	@echo "  $(GREEN)make clean$(NC)             - Clean up containers/images"
	@echo "  $(GREEN)make help$(NC)              - Show this help message"
	@echo ""
	@echo "$(BOLD)EXAMPLES:$(NC)"
	@echo "  $(YELLOW)# For Kali Linux:$(NC)"
	@echo "    $(BLUE)make kali-run$(NC)"
	@echo ""
	@echo "  $(YELLOW)# For Docker:$(NC)"
	@echo "    $(BLUE)make docker-build$(NC)"
	@echo "    $(BLUE)make docker-up$(NC)"
	@echo ""

# ============================================================================
# KALI LINUX TARGETS
# ============================================================================

kali-run:
	@echo "$(BOLD)$(GREEN)Starting Vulnerable Application (Kali Linux)...$(NC)"
	@chmod +x start-vulnerable-app.sh
	@./start-vulnerable-app.sh

kali-test:
	@echo "$(BOLD)$(GREEN)Testing Vulnerable Application...$(NC)"
	@echo "$(YELLOW)Starting app in background...$(NC)"
	@python3 vulnerable-app.py &
	@APP_PID=$$!
	@sleep 3
	@echo "\n$(YELLOW)Testing services:$(NC)"
	@echo "  HTTP (8080):  $$(nc -zv localhost 8080 2>&1 | tail -1)"
	@echo "  SSH (2222):   $$(nc -zv localhost 2222 2>&1 | tail -1)"
	@echo "  FTP (2121):   $$(nc -zv localhost 2121 2>&1 | tail -1)"
	@echo "  Telnet (2323): $$(nc -zv localhost 2323 2>&1 | tail -1)"
	@echo "  SMTP (2525):  $$(nc -zv localhost 2525 2>&1 | tail -1)"
	@kill $$APP_PID 2>/dev/null || true
	@echo "$(GREEN)✓ Tests completed$(NC)"

# ============================================================================
# DOCKER TARGETS
# ============================================================================

docker-build:
	@echo "$(BOLD)$(GREEN)Building Docker image...$(NC)"
	@docker build -t vulnerable-app:latest .
	@echo "$(GREEN)✓ Image built successfully$(NC)"
	@echo ""
	@echo "$(YELLOW)Image details:$(NC)"
	@docker images | grep vulnerable-app

docker-up:
	@echo "$(BOLD)$(GREEN)Starting vulnerable application with docker-compose...$(NC)"
	@docker-compose up -d
	@echo "$(GREEN)✓ Services started$(NC)"
	@sleep 2
	@echo ""
	@echo "$(YELLOW)Container status:$(NC)"
	@docker-compose ps
	@echo ""
	@echo "$(YELLOW)Exposed ports:$(NC)"
	@echo "  • HTTP:   http://localhost:8080"
	@echo "  • SSH:    localhost:2222"
	@echo "  • FTP:    localhost:2121"
	@echo "  • Telnet: localhost:2323"
	@echo "  • SMTP:   localhost:2525"
	@echo ""
	@echo "$(YELLOW)View logs with:$(NC) make docker-logs"

docker-down:
	@echo "$(BOLD)$(YELLOW)Stopping containers...$(NC)"
	@docker-compose down
	@echo "$(GREEN)✓ Containers stopped$(NC)"

docker-logs:
	@docker-compose logs -f vulnerable-app

docker-test:
	@echo "$(BOLD)$(GREEN)Testing Docker services with nmap...$(NC)"
	@if command -v nmap >/dev/null 2>&1; then \
		echo "$(YELLOW)Running: nmap -sV localhost$(NC)"; \
		nmap -sV localhost; \
	else \
		echo "$(RED)Nmap not installed - install with: sudo apt-get install -y nmap$(NC)"; \
	fi

# ============================================================================
# UTILITY TARGETS
# ============================================================================

clean:
	@echo "$(BOLD)$(YELLOW)Cleaning up...$(NC)"
	@echo "  • Stopping containers..."
	@docker-compose down 2>/dev/null || true
	@echo "  • Removing images..."
	@docker rmi vulnerable-app:latest 2>/dev/null || true
	@echo "  • Cleaning processes..."
	@pkill -f vulnerable-app.py 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup completed$(NC)"

status:
	@echo "$(BOLD)$(BLUE)System Status:$(NC)"
	@echo ""
	@echo "$(YELLOW)Docker Info:$(NC)"
	@docker ps -a | grep vulnerable || echo "  No containers running"
	@echo ""
	@echo "$(YELLOW)Python Process:$(NC)"
	@pgrep -f vulnerable-app.py || echo "  No Python processes"
	@echo ""
	@echo "$(YELLOW)Port Status:$(NC)"
	@netstat -tlnp 2>/dev/null | grep -E '8080|2222|2121|2323|2525' || echo "  Ports not in use"

# ============================================================================
# ADVANCED TARGETS
# ============================================================================

install-deps:
	@echo "$(BOLD)$(GREEN)Installing dependencies...$(NC)"
	@command -v docker >/dev/null 2>&1 || (echo "Installing Docker..." && sudo apt-get install -y docker.io)
	@command -v docker-compose >/dev/null 2>&1 || (echo "Installing Docker Compose..." && sudo apt-get install -y docker-compose)
	@command -v nmap >/dev/null 2>&1 || (echo "Installing nmap..." && sudo apt-get install -y nmap)
	@command -v python3 >/dev/null 2>&1 || (echo "Installing Python3..." && sudo apt-get install -y python3)
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

quick-start:
	@echo "$(BOLD)$(GREEN)Quick Start Guide:$(NC)"
	@echo ""
	@echo "1. For $(YELLOW)Kali Linux$(NC):"
	@echo "   $$ make kali-run"
	@echo ""
	@echo "2. For $(YELLOW)Docker$(NC):"
	@echo "   $$ make docker-build"
	@echo "   $$ make docker-up"
	@echo ""
	@echo "3. Test with nmap:"
	@echo "   $$ nmap -sV localhost"

.DEFAULT_GOAL := help
