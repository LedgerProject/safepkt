# Installation

Clone the project and its submodules with [git](https://git-scm.com/).

```shell
git clone --recursive https://github.com/LedgerProject/SafePKT safepkt
```

## Components

ℹ️ This section can be skipped for the installation process  
unless you'd like to have more details about the components themselves.

 - [Backend](https://github.com/LedgerProject/safepkt_backend/blob/main/README.md)
 - [Frontend](https://github.com/LedgerProject/safepkt_frontend/blob/main/README.md)

## Requirements

Here is a list of all requirements:
 - Rust and its development tools
 - Docker
 - Node.js

### Docker

Follow the official instructions to [install **Docker**](https://docs.docker.com/get-docker/),  
  as the backend depends on `Docker engine` to run containers based on an image,  
  which encapsulates the [Rust Verification Tools](https://project-oak.github.io/rust-verification-tools/).

### Rust

 - Rust-related requirements can be installed with `rustup` by running

```shell
make install-backend-deps
```

⚠️ this command execution may take a while as [a container image embedding the Rust Verification Tools](https://hub.docker.com/r/thierrymarianne/contrib-rvt_r2ct-llvm-11/tags)  
will be downloaded by default.

### Node.js

We also recommend the installation of a **Node.js** version management tool
like one of the following for the frontend development:
- [nvm](https://github.com/nvm-sh/nvm) or
- [n](https://github.com/tj/n)

After selecting the latest LTS (Node.js 14.x at the time of writing),
install the frontend JavaScript dependencies by running

```shell
## Install the latest matching LTS with nvm
#$ nvm install $(nvm ls-remote | \grep 'v14.*' | tail -n1 | awk '{print $1}')
make install-frontend-deps
```

## Configuration

Configuration files with sensitive default values can be copied
for both the backend and the frontend.  
They can also be customized to serve requests from custom hosts and ports.

```shell
make copy-configuration-files
```

## Table of contents

 - [README](../README.md)
 - [Section 00 - Web Frontend Preview](./00-frontend-preview.md)
 - [Section 03 - CLI Preview](./03-cli-preview.md)
 - [Section 05 - VSCode Preview](./05-vscode-preview.md)
 - [Section 20 - Contribution](./20-contribution.md)
