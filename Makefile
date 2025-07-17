# Makefile for csb-bootstrap terraform/tofu operations

.PHONY: template plan apply force clean init

# Template target - runs bdt
template:
	@echo "Generating provider template..."
	bdt -o _provider.tf --idempotent

# Plan target - runs tofu plan (depends on template)
plan: 
	@echo "Planning changes..."
	tofu plan

# Apply target - runs tofu apply (depends on plan)
apply: plan
	@echo "Applying changes..."
	tofu plan

# Force target - runs tofu apply with auto-approve (depends on plan)
force: 
	@echo "Forcing apply with auto-approve..."
	tofu apply -auto-approve

format:
	@echo "Formatting Terraform files..."
	tofu fmt	
	
# Clean target - removes generated files
clean:
	@echo "Cleaning up generated files..."
	# rm -f _provider.tf

init:
	@echo "Initializing environment..."
	tofu init
	@echo "Environment initialized."

sso:
	@echo "Running SSO login..."
	aws sso login