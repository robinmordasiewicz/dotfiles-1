# Fix for DOTFILEDIR Readonly Variable Error

## Problem
The script was failing with the error:
```
./install.sh: line 425: DOTFILEDIR: readonly variable
```

## Root Cause
The `DOTFILEDIR` variable was being declared as readonly twice in the script:
1. Once during the initial variable setup 
2. Again later in the script execution flow

## Solution Applied
1. **Moved the readonly declaration** to the beginning of the script execution section (after function definitions but before any function calls)
2. **Removed the duplicate declaration** that was causing the conflict
3. **Placed the variable setup in the correct location** - right after the function definitions but before the main script execution begins

## Code Changes
- Moved `DOTFILEDIR` and `SCRIPT_DIR` declarations to line ~395-399
- Removed duplicate declarations from line ~425
- Added proper section comments to clarify script structure

## Script Structure Now
```
#!/usr/bin/env bash
# Header comments and exit codes

set -euo pipefail

# Global variables
# Function definitions
# ...

# Set readonly variables (NEW LOCATION)
declare -r DOTFILEDIR
DOTFILEDIR="$(pwd)"
declare -r SCRIPT_DIR  
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validation
# Main script execution begins
# Parse arguments
# Detect context
# Setup user
# Continue with installation...
```

## Verification
The script should now run without the readonly variable error and properly support:
- Manual execution: `./install.sh`
- Cloud-init mode: `./install.sh --cloud-init --user ubuntu`
- Help option: `./install.sh --help`
- User specification: `./install.sh --user username`

## Testing
```bash
# Syntax check
bash -n install.sh

# Help test  
./install.sh --help

# Manual execution test
./install.sh

# Cloud-init simulation
sudo ./install.sh --cloud-init --user ubuntu
```
