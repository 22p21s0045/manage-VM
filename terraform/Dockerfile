FROM hashicorp/terraform:1.6

WORKDIR /workspace

# Copy terraform files
COPY *.tf ./
COPY *.tfvars ./
COPY templates/ ./templates/

# Initialize terraform
RUN terraform init

# Default command
ENTRYPOINT ["terraform"]
CMD ["plan"]
