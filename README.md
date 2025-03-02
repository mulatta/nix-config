# nix-config

## Core Concepts

- Hosts are defined as combination of hardware & user profiles
- Each hosts possess their own ROLE

## Hosts

- `seungwon`: My "personal laptop/desktop" user profile.
- `mulatta`: My "personal server/backend" user profile.

## Directory Structure

```
.
├── core
├── hardwares
├── programs
│   ├── common
│   └── nixos
└── users
    ├── mulatta
    │   └── nixos
    └── seungwon
        └── darwin

```

## Commit Conventions

This project uses structured commit messages to automatically generate organized release notes using GoReleaser. Follow these conventions when making commits:

### Commit Format

```
type(scope): description
```

- **type**: Describes the kind of change (feat, fix, chore, etc.)
- **scope**: The area of the codebase being changed
- **description**: A brief description of the change

### Types

- `feat`: New features or enhancements
- `fix`: Bug fixes
- `chore`: Maintenance tasks (excluded from changelog when scope is "nix")
- `docs`: Documentation changes
- `refactor`: Code refactoring without feature changes
- `test`: Adding or updating tests
- `style`: Formatting changes
- `perf`: Performance improvements

### Scopes

Your commit will be categorized in the changelog based on these scopes:

| Category     | Scopes                                                |
| ------------ | ----------------------------------------------------- |
| System       | `system`, `fish`, `fzf`, `ssh`, `core`, `pkg`, `pkgs` |
| Nix          | `nix`                                                 |
| Darwin/macOS | `darwin`, `macos`                                     |
| Linux        | `linux`, `nixos`                                      |
| Editor       | `helix`, `vim`, `nvim`, `neovim`                      |
| Tmux         | `zellij`, `tmux`                                      |
| Git          | `git`, `gh`                                           |
| Terminals    | `kitty`, `wezterm`, `rio`, `ghostty`, `alacritty`     |
| AI           | `ai`                                                  |

### Examples

```
feat(nix): Add Helix editor package
fix(macos): Resolve keyboard shortcut conflict in Yabai
refactor(vim): Simplify plugin configuration
chore(system): Update package versions
feat(tmux): Add new status bar layout
```

When creating a release, GoReleaser will automatically organize these commits into a structured changelog with sections for improvements, fixes, and other changes within each category.
