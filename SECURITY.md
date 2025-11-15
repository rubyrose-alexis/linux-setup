# Security Policy

## Overview

This document outlines the security considerations and best practices for the linux-setup project.

## Security Features

### 1. Root Privilege Checks

All installation scripts require root privileges and verify this before execution:
```bash
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root or with sudo"
    exit 1
fi
```

### 2. HTTPS for All Downloads

All external resources are downloaded over HTTPS to prevent man-in-the-middle attacks:
- Package repositories use HTTPS
- Binary downloads use HTTPS (Go, AWS CLI, etc.)
- Installation scripts are fetched over HTTPS

### 3. GPG Key Verification

Repository keys are properly verified before adding:
- Docker repository: GPG key added to `/etc/apt/keyrings/`
- Google Cloud SDK: Signed packages
- HashiCorp (Terraform): GPG verification
- Cloud providers: Official repositories with signature verification

### 4. No Hardcoded Credentials

Scripts do not contain or generate:
- API keys
- Passwords
- Access tokens
- SSH keys
- Cloud credentials

Users must configure their own credentials after installation.

### 5. Proper File Permissions

Scripts set appropriate permissions:
- Configuration backups are created before modification
- User files maintain proper ownership
- Scripts are executable but not writable by others

### 6. Error Handling

All scripts use `set -e` to exit on errors, preventing partial installations from leaving the system in an insecure state.

### 7. Idempotency

Scripts can be run multiple times safely without:
- Corrupting existing configurations
- Creating security vulnerabilities
- Duplicating sensitive settings

## Known Considerations

### 1. Docker Group Access

Adding users to the `docker` group grants root-equivalent access to the system. This is a Docker design decision, not a vulnerability in these scripts. Users should:
- Only add trusted users to the docker group
- Be aware of the security implications
- Consider alternatives like rootless Docker for production

### 2. Package Sources

Packages are installed from:
- **Ubuntu official repositories**: Trusted by default
- **NodeSource**: Official Node.js provider
- **Docker**: Official Docker repository
- **Cloud providers**: AWS, Google, Microsoft official repositories
- **HashiCorp**: Official Terraform repository

All third-party repositories are from official sources.

### 3. Piping to Bash

Some installations require piping to bash (e.g., `curl ... | bash`):
- This is unavoidable for certain official installers
- All URLs use HTTPS
- Only official sources are used
- Alternative: Download, inspect, then execute

If concerned, download scripts first:
```bash
curl -O https://example.com/install.sh
# Inspect the script
cat install.sh
# Then execute
bash install.sh
```

### 4. User-Data/Cloud-Init Security

When using cloud-init or user-data:
- Do not include secrets in user-data scripts
- User-data may be visible in cloud provider metadata
- Use parameter stores or secrets managers for sensitive data
- Cloud-init logs may contain script output

## Security Best Practices

### For Users

1. **Review scripts before execution**
   ```bash
   cat install.sh
   cat scripts/packages/docker.sh
   ```

2. **Use minimal installation in production**
   ```bash
   sudo ./install.sh --minimal
   ```

3. **Keep systems updated**
   ```bash
   sudo bash scripts/utils/update-system.sh
   ```

4. **Secure SSH access**
   ```bash
   # Use SSH keys, not passwords
   ssh-keygen -t ed25519
   # Disable password authentication in /etc/ssh/sshd_config
   ```

5. **Configure firewalls**
   ```bash
   sudo ufw enable
   sudo ufw allow ssh
   ```

6. **Monitor system**
   ```bash
   # Check running services
   sudo systemctl list-units --type=service --state=running
   
   # Check listening ports
   sudo ss -tulpn
   ```

### For Contributors

1. **Never commit secrets**
   - No API keys, tokens, or passwords
   - Use `.gitignore` for sensitive files
   - Review commits before pushing

2. **Validate all inputs**
   ```bash
   if [[ ! "$INPUT" =~ ^[a-zA-Z0-9_-]+$ ]]; then
       echo "Invalid input"
       exit 1
   fi
   ```

3. **Quote variables properly**
   ```bash
   # Good
   rm -rf "$TEMP_DIR"
   
   # Bad (security risk if variable contains spaces or special chars)
   rm -rf $TEMP_DIR
   ```

4. **Use secure temporary files**
   ```bash
   TEMP_FILE=$(mktemp)
   trap "rm -f $TEMP_FILE" EXIT
   ```

5. **Avoid eval when possible**
   - Can lead to code injection
   - Only use with trusted input
   - Consider alternatives

## Reporting Security Issues

### Scope

Please report:
- Code execution vulnerabilities
- Privilege escalation issues
- Credential exposure
- Injection vulnerabilities
- Insecure default configurations

Do not report:
- Issues in third-party packages (report to upstream)
- Docker group access (documented design decision)
- Missing features (use feature requests)

### Process

1. **Do NOT open a public issue** for security vulnerabilities

2. **Email the maintainer** with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

3. **Wait for acknowledgment** (typically within 48 hours)

4. **Coordinate disclosure** timing with maintainers

### What to Expect

- Acknowledgment within 48 hours
- Assessment and triage within 1 week
- Fix development and testing
- Coordinated public disclosure
- Credit in release notes (if desired)

## Security Updates

### How Updates are Handled

1. Security issues are prioritized
2. Fixes are developed and tested
3. Updates are released quickly
4. Users are notified via:
   - GitHub releases
   - Security advisories
   - README updates

### Keeping Your Installation Secure

```bash
# Update linux-setup scripts
cd linux-setup
git pull origin main

# Update system packages
sudo bash scripts/utils/update-system.sh

# Check for reboot requirements
[ -f /var/run/reboot-required ] && echo "Reboot required"
```

## Secure Configuration Examples

### Minimal Production Setup

```bash
# Minimal installation
sudo ./install.sh --minimal

# Configure firewall
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Harden SSH
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Enable automatic security updates
sudo apt-get install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

### Docker Security

```bash
# Use rootless Docker (more secure alternative)
# See: https://docs.docker.com/engine/security/rootless/

# Or restrict docker group membership
sudo groupmems -g docker -l

# Use Docker security options
docker run --security-opt=no-new-privileges --cap-drop=ALL myimage
```

## Compliance

This project follows:
- Principle of least privilege
- Defense in depth
- Secure by default configurations
- Regular security updates

## Additional Resources

- [Ubuntu Security](https://ubuntu.com/security)
- [Docker Security](https://docs.docker.com/engine/security/)
- [Cloud Security Best Practices](https://cloud.google.com/security/best-practices)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

## Version

This security policy applies to:
- Version: 1.0
- Last Updated: 2024-11-15
- Ubuntu: 24.04 LTS

## Questions?

For security questions (not vulnerability reports), please open a public issue on GitHub.
