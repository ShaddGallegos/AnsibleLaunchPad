# Developer Node Setup
--------------------

<img src="images/developer-node.png" alt="final image" width="400" height="400">

A comprehensive guide for setting up development environments to work with AAP.

## What is an Ansible Developer Node?

An **Ansible Developer Node** is a development environment (IDE) equipped with a curated suite of tools designed to streamline the creation, testing, and deployment of Ansible automation content. 

### Ansible Development Tools Suite
- ansible-core: The foundational automation engine.
- ansible-builder: Builds execution environments using defined schemas.
- ansible-creator: Scaffolds Ansible projects and content.
- ansible-lint: Checks playbooks for style issues and best practices.
- ansible-navigator: A text-based UI for developing and troubleshooting content.
- ansible-sign: Signs and verifies Ansible content for security.
- molecule: Facilitates testing of roles, playbooks, and collections.
- pytest-ansible: Extends pytest for testing Ansible modules and plugins.
- tox-ansible: Runs tests across multiple Python and Ansible versions.
- ansible-dev-environment: Manages virtual environments for development.

### Development Environment Support
- VS Code Extension: Adds Ansible language support, auto-completion, linting, and diagnostics.
- Dev Containers: Containerized environments using Podman or Docker for isolated development.
- Python 3.10+: Required for compatibility with the dev tools.

### Registry & Authentication
- Access to Red Hat's container registry (registry.redhat.io) is needed to pull dev containers and execution environments.

### You can set up an Ansible Developer Node using any of the following options:
- [RHEL Developer Node Setup](./rhel.md)

- [Windows Developer Node Setup](./windows.md)

- [MacOS Developer Node Setup](./macos.md)

- [Container Developer Node Setup](./container.md)
