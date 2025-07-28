# Cloud-Init Integration Guide

This document explains how to use the enhanced `install.sh` script with cloud-init for automated dotfiles installation.

## Overview

The enhanced script now supports both manual execution and automated cloud-init deployment with proper user handling, permission management, and unattended operation.

## Usage Scenarios

### 1. Manual Installation (Current User)
```bash
./install.sh
```

### 2. Manual Installation (Specific User)
```bash
sudo ./install.sh --user ubuntu
```

### 3. Cloud-Init Installation
```bash
./install.sh --cloud-init --user ubuntu
```

### 4. Environment Variable Override
```bash
sudo DOTFILES_USER=myuser ./install.sh
```

## Cloud-Init Integration

### Basic Cloud-Init Configuration

Add this to your cloud-init configuration file:

```yaml
#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash

packages:
  - git
  - curl
  - zsh

runcmd:
  - |
    # Clone dotfiles repository
    cd /tmp
    git clone https://github.com/yourusername/dotfiles.git
    cd dotfiles
    
    # Run installation for ubuntu user
    ./install.sh --cloud-init --user ubuntu
    
    # Cleanup
    cd /
    rm -rf /tmp/dotfiles
```

### Advanced Cloud-Init with Custom Repository

```yaml
#cloud-config
users:
  - name: devuser
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/zsh
    groups: [docker, sudo]

packages:
  - git
  - curl
  - zsh
  - docker.io

write_files:
  - path: /tmp/install-dotfiles.sh
    permissions: '0755'
    content: |
      #!/bin/bash
      set -euo pipefail
      
      # Clone your dotfiles
      git clone https://github.com/yourusername/dotfiles.git /tmp/dotfiles
      cd /tmp/dotfiles
      
      # Install for specific user
      DOTFILES_USER=devuser ./install.sh --cloud-init
      
      # Cleanup
      rm -rf /tmp/dotfiles

runcmd:
  - /tmp/install-dotfiles.sh
```

### Terraform Example

```hcl
resource "aws_instance" "dev_server" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.micro"
  
  user_data = templatefile("${path.module}/cloud-init.yaml", {
    dotfiles_repo = "https://github.com/yourusername/dotfiles.git"
    target_user   = "ubuntu"
  })

  tags = {
    Name = "DevServer"
  }
}
```

With `cloud-init.yaml`:
```yaml
#cloud-config
users:
  - name: ${target_user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/zsh

packages:
  - git
  - curl
  - zsh

runcmd:
  - |
    cd /tmp
    git clone ${dotfiles_repo} dotfiles
    cd dotfiles
    ./install.sh --cloud-init --user ${target_user}
    cd /
    rm -rf /tmp/dotfiles
```

## Environment Variables

The script supports several environment variables for configuration:

| Variable | Description | Example |
|----------|-------------|---------|
| `DOTFILES_USER` | Target user for installation | `ubuntu` |
| `DOTFILES_HOME` | Target home directory | `/home/ubuntu` |
| `DEBUG` | Enable debug mode | `1` |
| `CI` | Indicates CI/automation environment | `true` |

## Features for Cloud-Init

### 1. **User Detection and Switching**
- Automatically detects cloud-init execution context
- Handles user switching with proper permission management
- Supports running as root with target user specification

### 2. **Ownership Management**
- Automatically sets correct file ownership when run as root
- Preserves permissions and security contexts
- Creates proper directory structures

### 3. **Network Resilience**
- Retry logic for network operations with exponential backoff
- Handles temporary connectivity issues during cloud instance startup
- Graceful degradation on network failures

### 4. **Unattended Operation**
- No interactive prompts or user input required
- Comprehensive logging for troubleshooting
- Clear error messages and exit codes

### 5. **Error Handling**
- Proper exit codes for automation integration
- Comprehensive error logging with timestamps
- Rollback capabilities with automatic backups

## Exit Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 0 | Success | Installation completed successfully |
| 1 | General Error | Configuration or logic errors |
| 2 | Network Error | Download or git operation failures |
| 3 | Filesystem Error | Permission, disk space, or file operations |
| 4 | Permission Error | User switching or access issues |

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   # Solution: Run with sudo or ensure proper user context
   sudo ./install.sh --user ubuntu
   ```

2. **Network Timeouts**
   ```bash
   # Solution: The script automatically retries, but you can enable debug mode
   DEBUG=1 ./install.sh --cloud-init --user ubuntu
   ```

3. **User Not Found**
   ```bash
   # Solution: Ensure the user exists before running the script
   sudo useradd -m -s /bin/bash ubuntu
   ./install.sh --user ubuntu
   ```

### Debug Mode

Enable debug mode for verbose output:

```bash
DEBUG=1 ./install.sh --cloud-init --user ubuntu
```

### Log Analysis

The script outputs structured logs that can be easily parsed:

```bash
# Filter for errors
./install.sh 2>&1 | grep "\[ERROR\]"

# Filter for specific user operations
./install.sh 2>&1 | grep "ubuntu"
```

## Security Considerations

1. **Repository Trust**: Only use trusted dotfiles repositories
2. **User Permissions**: The script handles permissions correctly but verify your dotfiles don't contain sensitive data
3. **Network Security**: All downloads use HTTPS
4. **File Ownership**: Proper ownership is maintained when switching users

## Best Practices

1. **Test First**: Always test your cloud-init configuration in a development environment
2. **Version Pin**: Consider pinning specific versions of tools rather than using "latest"
3. **Minimal Privileges**: Use the least privileged user possible
4. **Logging**: Monitor cloud-init logs for installation status
5. **Idempotency**: The script is designed to be run multiple times safely

## Integration Examples

### GitHub Actions (Self-Hosted Runner Setup)
```yaml
- name: Setup Dotfiles
  run: |
    git clone https://github.com/username/dotfiles.git
    cd dotfiles
    ./install.sh --user runner
```

### Docker Container
```dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y git curl zsh sudo

# Create user
RUN useradd -m -s /bin/zsh developer
RUN echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install dotfiles
COPY . /tmp/dotfiles
WORKDIR /tmp/dotfiles
RUN ./install.sh --user developer

USER developer
WORKDIR /home/developer
```

This enhanced script provides a robust foundation for automated dotfiles deployment in any cloud or CI/CD environment.
