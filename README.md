# Homebrew Tap for Legion CLI

This directory contains Homebrew formulas for installing legion-cli on macOS and Linux.

## Quick Install

```bash
# Install latest development version
brew install endgame-build/legion/legion-cli

# Install stable version (when available)
brew install endgame-build/legion/legion-cli-stable
```

## Setup Homebrew Tap Repository

To set up the Homebrew tap, you'll need to create a separate repository for the tap:

### 1. Create Tap Repository

```bash
# Create a new repository named 'homebrew-legion'
gh repo create endgame-build/homebrew-legion --public --description "Homebrew tap for Legion CLI"

# Clone the repository
git clone https://github.com/endgame-build/homebrew-legion.git
cd homebrew-legion

# Create Formula directory
mkdir Formula

# Copy formula files from main repository
cp /path/to/legion-cli/homebrew/legion-cli.rb Formula/
cp /path/to/legion-cli/homebrew/legion-cli-stable.rb Formula/

# Initial commit
git add .
git commit -m "feat: add legion-cli homebrew formulas"
git push origin main
```

### 2. Repository Structure

Your tap repository should look like this:

```
homebrew-legion/
├── README.md
└── Formula/
    ├── legion-cli.rb          # Development version
    └── legion-cli-stable.rb   # Stable version
```

### 3. Configure GitHub Secrets

To enable automatic formula updates, add this secret to your main repository:

- `HOMEBREW_TAP_TOKEN`: Personal access token with write access to the tap repository

## Usage

### Install Development Version

```bash
# Add the tap
brew tap endgame-build/legion

# Install latest development build
brew install legion-cli

# Update to latest development build
brew upgrade legion-cli
```

### Install Stable Version

```bash
# Install stable version
brew install legion-cli-stable

# Update stable version
brew upgrade legion-cli-stable
```

### Switch Between Versions

```bash
# Uninstall current version
brew uninstall legion-cli

# Install different version
brew install legion-cli-stable  # or legion-cli
```

## Formula Details

### Development Formula (legion-cli.rb)
- **Source**: Latest development release from GitHub
- **Updates**: Automatically updated on each development release
- **Version Format**: `0.1.0-dev` (with commit hash in release notes)

### Stable Formula (legion-cli-stable.rb)
- **Source**: PyPI stable releases
- **Updates**: Updated when stable versions are published
- **Version Format**: `1.0.0` (semantic versioning)

## Automatic Updates

The formulas are automatically updated via GitHub Actions:

1. **Trigger**: New development release published
2. **Action**: Downloads latest release, calculates SHA256
3. **Update**: Updates formula files with new URLs and hashes
4. **Push**: Commits changes to both main repo and tap repository

## Manual Formula Updates

If you need to manually update the formulas:

```bash
# Update formulas with latest releases
python scripts/update-homebrew-formula.py

# Review changes
git diff homebrew/

# Commit and push
git add homebrew/
git commit -m "chore(homebrew): update formulas"
git push
```

## Testing Formulas

Test the formulas locally before publishing:

```bash
# Test development formula
brew install --build-from-source ./homebrew/legion-cli.rb
brew test legion-cli

# Test stable formula
brew install --build-from-source ./homebrew/legion-cli-stable.rb
brew test legion-cli-stable
```

## Troubleshooting

### Formula Fails to Install

1. Check if Python 3.12 is available:
   ```bash
   brew install python@3.12
   ```

2. Update Homebrew:
   ```bash
   brew update
   ```

3. Clear cache and retry:
   ```bash
   brew cleanup legion-cli
   brew install --force legion-cli
   ```

### Formula Out of Date

If the formula is behind the latest release:

1. Check if automatic updates are working
2. Manually trigger the update workflow
3. Update the formula manually using the update script

## Contributing

To contribute improvements to the Homebrew formulas:

1. Fork the repository
2. Update the formula files in `homebrew/`
3. Test your changes locally
4. Submit a pull request

## Resources

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Python Formula Guide](https://docs.brew.sh/Python-for-Formula-Authors)
- [Creating Taps](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)