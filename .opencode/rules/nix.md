# Nix Configuration Standards

## Flake Best Practices

- **Use flakes** for all Nix configurations
- **Pin inputs** explicitly in flake.lock
- **Avoid impure operations**: No `<nixpkgs>`, no `NIX_PATH`
- **Use flake-utils** for cross-platform compatibility

## Package Management

- Install core tools (LSPs, linters) in the flake
- Use `pkgs.mkShell` for project-specific dev environments
- Let project dev shells provide language-specific LSPs/tools
- Don't bundle all language tools in base config

## Code Style

- **Format with nixfmt-rfc-style**: Run before committing
- **Indentation**: 2 spaces for Nix (configured in commands.lua)
- **Attribute sets**: Use consistent ordering
- **Comments**: Explain complex derivations

## Plugin Management

- Use `start` packages for plugins that must load at startup
- Use `opt` packages for lazy-loaded plugins
- Prefer `wrapNeovim` over manual config file management
- Include all plugin dependencies in flake

## Reproducibility

- All dependencies declared in flake.nix
- No `fetchurl` without hash
- Pin Neovim version if stability critical
- Document runtime dependencies in comments

## Common Patterns

- Wrap Neovim with custom config using `wrapNeovim`
- Use `runtimeInputs` for tools needed at runtime
- Create shell application for easy execution
- Export as both package and app for flexibility
