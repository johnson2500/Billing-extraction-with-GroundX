# ============================================================
# Billing Extraction with GroundX — Makefile
# ============================================================
#
# Deployment is handled by two umbrella Helm charts:
#   1. helm/billing-operators  — operators and cluster prep
#   2. helm/billing-workloads  — application pods and workloads
#
# The helm/Makefile drives both charts.  This root Makefile is a
# convenience wrapper so you can run commands from the repo root.

NAMESPACE ?= eyelevel

# ============================================================
# Install / Uninstall (delegates to helm/Makefile)
# ============================================================
.PHONY: install
install: ## Install operators + workloads
	$(MAKE) -C helm install NAMESPACE=$(NAMESPACE)

.PHONY: uninstall
uninstall: ## Uninstall workloads + operators
	$(MAKE) -C helm uninstall NAMESPACE=$(NAMESPACE)

# ============================================================
# Status & Debugging
# ============================================================
.PHONY: get-pods
get-pods: ## List all pods in the namespace
	@oc get pods -n $(NAMESPACE)

.PHONY: get-all
get-all: ## List all resources in the namespace
	@oc get all -n $(NAMESPACE)

.PHONY: get-routes
get-routes: ## List OpenShift routes
	@oc get routes -n $(NAMESPACE)

.PHONY: get-services
get-services: ## List all services
	@oc get services -n $(NAMESPACE)

.PHONY: describe
describe: ## Describe all resources in the namespace
	@oc describe all -n $(NAMESPACE)

# ============================================================
# Logs
# ============================================================
.PHONY: logs-groundx
logs-groundx: ## Tail GroundX logs
	@oc logs -n $(NAMESPACE) -l app.kubernetes.io/component=groundx --tail=100 -f

.PHONY: logs-minio
logs-minio: ## Tail MinIO logs
	@oc logs -n $(NAMESPACE) -l app.kubernetes.io/component=minio --tail=100 -f

.PHONY: logs-percona
logs-percona: ## Tail Percona MySQL logs
	@oc logs -n $(NAMESPACE) -l app.kubernetes.io/component=percona --tail=100 -f

.PHONY: logs-notebook
logs-notebook: ## Tail Jupyter notebook logs
	@oc logs -n $(NAMESPACE) -l app.kubernetes.io/component=notebook --tail=100 -f

# ============================================================
# Help
# ============================================================
.PHONY: help
help: ## Show this help
	@echo ""
	@echo "Billing Extraction with GroundX"
	@echo "================================"
	@echo ""
	@echo "  NAMESPACE=$(NAMESPACE)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Targets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""
