# Changelog

All notable changes to this project is documented in this file. See
[Conventional Commits](https://conventionalcommits.org) and [SemVer](https://semver.org/)
for commit and versioning guidelines, respectively.

## [Release 1.6.1](https://github.com/guitsilva/docker-latex/releases/tag/v1.6.1) (2020-07-07)

### Bug Fixes

- give back non-root user access to .local folder after .local/bin creation
  ([493002d](https://github.com/guitsilva/docker-latex/commit/493002d))

## [Release 1.6.0](https://github.com/guitsilva/docker-latex/releases/tag/v1.6.0) (2020-07-07)

### New Features

- add texlive-extra-utils package
  ([e6875a0](https://github.com/guitsilva/docker-latex/commit/e6875a0))

## [Release 1.5.0](https://github.com/guitsilva/docker-latex/releases/tag/v1.5.0) (2020-07-06)

### New Features

- add direnv package to general utilities
  ([f2625ab](https://github.com/guitsilva/docker-latex/commit/f2625ab))
- create non-root user's private bin folder
  ([c4219bd](https://github.com/guitsilva/docker-latex/commit/c4219bd))

## [Release 1.3.0](https://github.com/guitsilva/docker-latex/releases/tag/v1.3.0) (2020-06-12)

### New Features

- **dockerfile:** set container default CMD
  ([b40848f](https://github.com/guitsilva/docker-latex/commit/b40848f))
- **setup:** set zsh as default shell for non-root user
  ([2d3ea4c](https://github.com/guitsilva/docker-latex/commit/2d3ea4c))
- **dockerfile:** change base image from ubuntu to buildpack-deps:focal
  ([e5fd707](https://github.com/guitsilva/docker-latex/commit/e5fd707))

## [Release 1.0.0](https://github.com/guitsilva/docker-latex/releases/tag/v1.0.0) (2020-05-26)

### New Features

- **setup:** install recommended packages
  ([4265116](https://github.com/guitsilva/docker-latex/commit/4265116))
- **dockerfile:** set container USER and WORKDIR
  ([23bed3d](https://github.com/guitsilva/docker-latex/commit/23bed3d))
- **setup:** generate pt_BR.UTF-8 locale
  ([4e91fea](https://github.com/guitsilva/docker-latex/commit/4e91fea))

### Breaking Changes

- remove Oh-My-Zsh install
  ([be2a3f1](https://github.com/guitsilva/docker-latex/commit/be2a3f1))

## [Release 0.3.0](https://github.com/guitsilva/docker-latex/releases/tag/v0.3.0) (2020-05-19)

### New Features

- include devcontainer.json for VS Code features
  ([3455fd4](https://github.com/guitsilva/docker-latex/commit/3455fd4))

## [Release 0.2.1](https://github.com/guitsilva/docker-latex/releases/tag/v0.2.1) (2020-05-18)

### Bug Fixes

- **script:** remove RUN from VSCode extension folder creation command
  ([04f635d](https://github.com/guitsilva/docker-latex/commit/04f635d))

### Features

- add Microsoft's common script integration
  ([c49afb7](https://github.com/guitsilva/docker-latex/commit/c49afb7))

## [Release 0.1.0](https://github.com/guitsilva/docker-latex/releases/tag/v0.1.0) (2020-05-14)

### New Features

- create initial Dockerfile
  ([e638735](https://github.com/guitsilva/docker-latex/commit/e638735))
