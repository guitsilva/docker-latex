# Docker-LaTeX

![Docker Cloud Automated
build](https://img.shields.io/docker/cloud/automated/guitsilva/docker-latex)
![Docker Cloud Build
Status](https://img.shields.io/docker/cloud/build/guitsilva/docker-latex)
![Docker Image Size (latest by
date)](https://img.shields.io/docker/image-size/guitsilva/docker-latex)

LaTeX environment within Docker containers based on Ubuntu LTS and non-full TeX
Live. This environment is used by this repository owner to build his academic
LaTeX projects: papers, posters, presentations, theses, etc. Therefore, the
Docker image is way smaller than `texlive-full` ones and rather personal. Some
cool features:

- sensible TeX Live and auxiliary packages selection assuring reasonable image
  size;

- non-root user to prevent files edited inside the container to be inaccessible
  to host user;

- persistent VS Code extensions across containers.

## Deployment

Built images can be found at
[DockerHub](https://hub.docker.com/r/guitsilva/docker-latex). Copy and execute
the following command to pull the `latest` (master branch) image:

    ~$ docker pull guitsilva/docker-latex

Visual Studio Code users, a `devcontainer.json` file is included. In order to
use it and enable all the cool features listed above, install the [Remote -
Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
extension, copy the `devcontainer.json` file into your LaTeX project folder

    ~$ curl -OJ https://raw.githubusercontent.com/guitsilva/docker-latex/master/.devcontainer.json

and execute VS Code's command `Remote-Containers: Reopen in Container`.

## Workflow

We strictly use
[Gitflow](https://nvie.com/posts/a-successful-git-branching-model/). See also
[Conventional Commits](https://conventionalcommits.org) and [SemVer](semver.org)
for commit and versioning guidelines, respectively.

## Changelog

All notable changes to this project is documented in the
[CHANGELOG.md](https://github.com/guitsilva/docker-latex/blob/master/CHANGELOG.md)
file.

## License

This project is licensed under the MIT License - see the
[LICENSE](https://github.com/guitsilva/docker-latex/blob/master/LICENSE) file
for details.