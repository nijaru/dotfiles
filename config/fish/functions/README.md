# Fish Shell Functions

This directory contains Fish shell functions organized by category into subdirectories.

## Directory Structure

- `editor/` - Editor-related functions
- `fs/` - Filesystem operations
- `git/` - Git operations
- `homebrew/` - Homebrew package manager operations
- `kubernetes/` - Kubernetes operations
- `modern-cli/` - Modern CLI replacement tools
- `navigation/` - Directory navigation
- `utils/` - Utility functions
- `docker/` - Docker operations

## Function Organization

Each function is in its own file named after the function, following Fish's autoloading convention. This approach:

1. Makes functions immediately available without explicit sourcing
2. Improves shell startup performance
3. Keeps the codebase organized and maintainable
4. Simplifies debugging and testing

## Usage

Functions are automatically loaded when called. You can see all available functions with:

```fish
functions -n | sort
```

Or view a specific function's definition with:

```fish
functions function_name
```

## Adding New Functions

To add a new function:

1. Identify the appropriate category subdirectory
2. Create a new file named `function_name.fish`
3. Define your function using the Fish function syntax:

```fish
function function_name --description "Description of what the function does"
    # Your code here
end
```

## Legacy Support

For backwards compatibility, some legacy aliases are still defined in the `aliases.fish` file, but these are being phased out in favor of proper functions.

## Documentation

See `../functions.fish` for a comprehensive list of all available functions with descriptions.