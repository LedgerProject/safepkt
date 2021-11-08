# SafePKT

This project is implemented in the context of the European [NGI LEDGER program](https://ledger-3rd-open-call.fundingbox.com/).

This prototype aims at bringing more automation  
to the field of software verification tools targeting rust-based programs.

See [SafePKT description](https://ledgerproject.github.io/home/#/teams/SafePKT)

## Table of contents

 - [Preview](#preview)
 - [Learn more about this final minimal viable product](#minimal-viable-product)
 - [Install](#install)
 - [Contribute](#contribute)
 - [Acknowledgement](#acknowledgment)
 - [License](#license)

## Preview

As of today, SafePKT offers an opportunity for
 - generating [`LLVM bitcode`](https://llvm.org/docs/BitCodeFormat.html) from a `rust` binary program,
 - running [KLEE symbolic engine](http://klee.github.io/) from the output
 - verifying rust-based smart contracts implemented on top of [ink! framework](https://github.com/paritytech/ink/tree/v2.1.0)
 - fuzzing programs, which tests would have been enriched by following [`propverify`](https://github.com/project-oak/rust-verification-tools/blob/main/demos/simple/string/src/main.rs) conventions

Such program must be minimalist as we're in a prototyping phase i.e.  
it should consist in a single-file program (`lib.rs`) without dependencies  
other than [`rvt` verification-annotations](https://github.com/LedgerProject/safepkt_backend/blob/main/src/domain/project/manifest.rs),  
as there are some concerns remaining to be covered like:
 - the security aspects coming along with the compilation and execution of arbitrary source code
 - the compatibility of such programs with the underlying verification tools
 - the compatibility of KLEE, the symbolic execution engine with such programs dependencies
 - the compatibility of KLEE with the latest LLVM intrinsics, which could be leveraged for compiling such programs

Some screenshots of the successive steps execution can be found
 - in the [web frontend preview section](../../blob/main/docs/00-preview-web-frontend.md),
 - in the [CLI preview section](../../blob/main/docs/03-preview-cli.md) or
 - in the [VSCode preview section](../../blob/main/docs/05-preview-vscode.md)

## Learn more about this final minimal viable product

 - [Final MVP for Smart-Contract verification with SafePKT](../../blob/main/docs/30-final-mvp-for-safepkt-smart-contract-verifier.md) 

## Install

In a nutshell, the [installation steps](../../blob/main/docs/10-installation.md) consist in 
 - Cloning this repository and its submodules
```
git clone --recursive github.com:LedgerProject/safepkt
cd safepkt
```
 - Installing the requirements
 - Installing the project dependencies

Provided the following requirements are already available:
 - `git`,
 - `docker`,
 - `rust` (with `cargo`) and
 - `node.js` (with `npm`)
you should be able to install the project by running the next command

```shell
make install
```

## Contribute

In order to be able to contribute to the project,
you might need to follow the [installation steps](../../blob/main/docs/10-installation.md)  
*after* having considered [opening an issue](https://github.com/LedgerProject/safepkt/issues/new) to start a discussion  
regards contributions to the project.  

Running the project in a local environment is described by the [development section](../../blob/main/docs/10-development.md).

In the best-case scenario, a local environment can be built by running

```shell
make contribution
```

## Acknowledgment

We're very grateful towards all members of the NGI-Ledger Consortium for accompanying us  
  [![Blumorpho](../main/docs/img/blumorpho-logo.png?raw=true)](https://www.blumorpho.com/) [![Dyne](../main/docs/img/dyne-logo.png?raw=true)](https://www.dyne.org/ledger/) [![FundingBox](../main/docs/img/funding-box-logo.png?raw=true)](https://fundingbox.com/) [![NGI LEDGER](../main/docs/img/ledger-eu-logo.png?raw=true)](https://ledger-3rd-open-call.fundingbox.com/)

## License

This project is distributed under either the [MIT](../../blob/main/LICENSE-MIT) license or the [Apache](../../blob/main/LICENSE-APACHE) License.
