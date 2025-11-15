# Contributing to Linux Setup

Thank you for considering contributing to linux-setup! This document provides guidelines and instructions for contributing.

## How to Contribute

### Reporting Issues

If you encounter a bug or have a suggestion:

1. **Search existing issues** to avoid duplicates
2. **Create a new issue** with:
   - Clear, descriptive title
   - Detailed description of the problem or suggestion
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - System information (OS version, architecture)
   - Relevant logs or error messages

### Suggesting Enhancements

We welcome suggestions for:
- New packages to include
- Additional scripts or utilities
- Configuration improvements
- Documentation enhancements
- Better error handling

Please open an issue to discuss major changes before implementing them.

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes** following the guidelines below
4. **Test your changes** thoroughly
5. **Commit with clear messages**: `git commit -m "Add feature: description"`
6. **Push to your fork**: `git push origin feature/your-feature-name`
7. **Open a Pull Request** with:
   - Clear description of changes
   - Reference to related issues
   - Testing details

## Development Guidelines

### Script Standards

#### Shell Scripts

1. **Shebang**: Always start with `#!/bin/bash`
2. **Error Handling**: Use `set -e` for most scripts
3. **Documentation**: Add header comments explaining purpose
4. **Functions**: Use functions for reusable code
5. **Variables**: Use descriptive names and `readonly` for constants
6. **Quotes**: Always quote variables: `"$variable"`
7. **Error Messages**: Use stderr for errors: `>&2`

Example template:
```bash
#!/bin/bash

################################################################################
# Script Name
#
# Description: Brief description of what this script does
################################################################################

set -e

readonly CONSTANT_VAR="value"

function_name() {
    local param="$1"
    # Implementation
}

main() {
    # Main logic
}

main "$@"
```

#### Code Style

- Use 4 spaces for indentation (no tabs)
- Maximum line length: 100 characters
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small

#### Testing

Before submitting:

1. **Syntax Check**: Run `bash -n script.sh`
2. **Manual Testing**: Test on Ubuntu 24.04 LTS
3. **Edge Cases**: Test error conditions
4. **Idempotency**: Ensure scripts can run multiple times safely

### Directory Structure

```
linux-setup/
├── install.sh              # Main installation script
├── Dockerfile              # Container definition
├── docker-compose.yml      # Docker Compose config
├── scripts/
│   ├── packages/          # Package installation scripts
│   ├── config/            # Configuration scripts
│   └── utils/             # Utility scripts
├── examples/              # Example configurations
└── docs/                  # Additional documentation
```

### Adding New Packages

To add a new package installer:

1. Create script in `scripts/packages/`:
   ```bash
   scripts/packages/your-category.sh
   ```

2. Follow this template:
   ```bash
   #!/bin/bash
   
   set -e
   
   echo "Installing [category] packages..."
   
   apt-get update -qq
   apt-get install -y \
       package1 \
       package2 \
       package3
   
   echo "[Category] packages installed successfully"
   ```

3. Make executable: `chmod +x scripts/packages/your-category.sh`

4. Add to `install.sh` if needed

5. Update documentation:
   - `PACKAGES.md` - Add package details
   - `README.md` - Update features list if needed

### Adding Utility Scripts

1. Create in `scripts/utils/`
2. Make standalone and reusable
3. Include help/usage information
4. Handle errors gracefully
5. Document in README

### Modifying Environment Configuration

When changing `scripts/config/environment.sh`:

1. Always backup existing configs
2. Use append (`>>`) instead of overwrite (`>`)
3. Check if configuration already exists
4. Make changes idempotent
5. Test with both new and existing configurations

### Documentation

Update documentation for any changes:

- **README.md**: Main documentation, usage, features
- **PACKAGES.md**: Package lists and versions
- **QUICKSTART.md**: Quick start scenarios
- **CONTRIBUTING.md**: This file for development guidelines

Use clear, concise language and provide examples.

## Testing Checklist

Before submitting a PR:

- [ ] Scripts pass syntax check: `bash -n script.sh`
- [ ] Tested on Ubuntu 24.04 LTS
- [ ] Scripts are idempotent (can run multiple times)
- [ ] Error handling works correctly
- [ ] Documentation updated
- [ ] No hardcoded paths (except system paths)
- [ ] Scripts work with both sudo and root user
- [ ] Log messages are clear and helpful
- [ ] No security issues (credentials, keys exposed)

## Commit Message Guidelines

Follow conventional commits format:

```
<type>: <description>

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat: add PostgreSQL installation script

fix: correct Docker group assignment in docker.sh

docs: update README with new installation options

refactor: improve error handling in install.sh
```

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Accept constructive criticism
- Focus on what's best for the community
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

## Questions?

- Open an issue for questions
- Check existing issues and documentation
- Be specific about your question or problem

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in:
- GitHub contributors page
- Release notes (for significant contributions)

## Getting Help

If you need help contributing:

1. Check existing documentation
2. Look at similar scripts for examples
3. Open an issue asking for guidance
4. Reference related issues or PRs

Thank you for contributing to linux-setup! 🎉
