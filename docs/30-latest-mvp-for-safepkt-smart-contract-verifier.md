# Latest MVP for Smart-Contract verification with SafePKT

SafePKT project is implemented in the context of the European [NGI LEDGER program](https://ledger-3rd-open-call.fundingbox.com/) (see https://ledger-3rd-open-call.fundingbox.com/).

SafePKT is a project to study and build static analysis technology for the Rust code used in the PKT project. PKT is a project for disintermediating telecom monopolies by de-coupling the roles of infrastructure operation from (internet) service provision. PKT uses a blockchain based on the bitcoin protocol and a proof of work algorithm called PacketCrypt which requires bandwidth in order to mine. The vision of PacketCrypt is to drive investment into network infrastructure by creating artificial demand for bandwidth.

You can find out more about the overall PKT project by going to: https://pkt.cash/

In the SafePKT project we are focused on improving software development efficiency (and therefore time to market) for software used within the PKT ecosystem (e.g. PacketCrypt / cjdns). As security breaches in cryptocurrency software often lead to irrecoverable loss, such projects have higher than normal security requirements. However in this innovative and competitive space, time to market is also a critical to a project's overall success. With the help of cutting edge research in the academic space, we are developing improved software verification tools which will be easier to use and more helpful to developers who will apply them to improving software development efficiency and security in projects within the PKT ecosystem.

## Table of contents

 - [The technology](#the-technology)
 - [Change log](#change-log)
   - [Phase 1 - Web-based application implementation](#phase-1---web-based-application-implementation)
   - [Phase 2 - Scope reduction and simplification](#phase-2---scope-reduction-and-simplification)
   - [Phase 3 - VS Code Extension implementation](#phase-3---vs-code-extension-implementation)
 - [Bug fixing and improvements](#bug-fixing-and-improvements)
   - [Trade-offs](#trade-offs)
   - [Security concerns](#security-concerns)
   - [Improvements](#improvements)
 - [System stability, maintainability](#system-stability-maintainability)
   - [Ballpark performance](#ballpark-performance)
   - [VS Code Extension and backend maintenance and deployment](#vs-code-extension-and-backend-maintenance-and-deployment)
   - [Frontend improvements](#frontend-improvements)
   - [Backend configuration](#backend-configuration)
 - [Links](#links)

## The Technology

The technology of PKT overall includes [PacketCrypt](https://pkt.cash/PacketCrypt-2020-09-04.pdf) bandwidth-hard proof of work, [Lightning Network](https://en.wikipedia.org/wiki/Lightning_Network), and [cjdns](https://github.com/cjdelisle/cjdns) networking protocol.

SafePKT technology consists of a web based frontend and server-side backend, which work together to provide a software developer with reports about potential bugs or security
issues in their code.

Both a [command-line (CLI) application](https://github.com/LedgerProject/safepkt_backend/releases) and a [Visual Studio Code plugin](https://marketplace.visualstudio.com/items?itemName=CJDNS.safepkt-verifier) offer independently from the two previous components, reports containing the same level of detail offered by the backend when it comes to
analyzing a rust-based smart-contract written on top of [Parity's ink! eDSL](https://github.com/paritytech/ink/tree/v2.1.0) - see https://github.com/paritytech/ink/tree/v2.1.0.

While the backend is responsible for handling all the transformation logic from a program source file or a rust library-oriented or binary-oriented project, the frontend (single-page application) is responsible for enabling developers and researchers to triggers the verification process from a web browser before receiving reports usually made available and formatted for command-line shells.

In the same vein as for the frontend component, the command-line binary emitted at compilation of the backend, provides with the capability to verify a rust program when the constraints needed by the verifier are followed per instruction. Such verification process consists in running successively containerized jobs consisting in the following steps:
 - Scaffolding of a new rust project uniquely identified from a  rust program source file  
 - Generation of LLVM bitcode from the newly created project   
 - Symbolic execution of the program based on two strategies
   - the declaration of assumed input values types before having the program intermediate representation (obtained from the previous step) run by KLEE symbolic execution engine
   - the addition of tests also run by KLEE for library-oriented project (what we've eventually decided we would be focusing on)

SafePKT depends on the following technologies:
 - Single-page application:
   - [Node.js](https://nodejs.org/),
   - [Typescript](https://www.typescriptlang.org/),
   - [Vue.js](https://vuejs.org/),
   - [NuxtJs](https://nuxtjs.org/)
 - Server-side back-end and command-line application:
   - [Rust](https://www.rust-lang.org/),
   - [Docker engine](https://www.docker.com/products/container-runtime),
   - [Rust Verification Tools](https://project-oak.github.io/rust-verification-tools/),
   - [LLVM](https://llvm.org/),
   - [KLEE](http://klee.github.io/)
 - VS Code extension:
   - [Got](https://github.com/sindresorhus/got/tree/v11.8.2),
   - [Tree-sitter](https://tree-sitter.github.io/tree-sitter/),
   - [Typescript](https://www.typescriptlang.org/),
   - [VS Code Extension API](https://code.visualstudio.com/api)

## Change log

### Phase 1 - Web-based application implementation

 - Implementation of backend application skeleton,
 responding to HTTP requests matching the following routes:
   - POST `/source`  
   to upload program source code (rust-based program for compiling a binary)
   - GET `/steps`  
   to list verifications steps
   - POST `/llvm-bitcode-generation/{{ project_id }}`  
   to run LLVM bitcode generation from a previously uploaded source
   - GET `/llvm-bitcode-generation/{{ project_id }}/report`  
   to get a report for some LLVM bitcode generation 
   - GET `/llvm-bitcode-generation/{{ project_id }}/progress`  
   to get the completion status for some LLVM bitcode generation 
   - POST `/symbolic-execution/{ project_id }`  
   to run KLEE symbolic execution from a previously uploaded program after having generated intermediate representation with LLVM
   - GET `/symbolic-execution/{{ project_id }}/report`  
   to get a report for some symbolic execution 
   - GET `/symbolic-execution/{{ project_id }}/progress`  
   to get the completion status for some symbolic execution
 - Implementation of a frontend application enabling a developer or a researcher to chain commands required to verify a program written in Rust by using the [Rust Verification Tools](https://github.com/project-oak/rust-verification-tools) from the comfort of a web browser.   

In the initial phase, our web-based prototype clearly revealed some limitations in terms of usability and ergonomy. There were too many steps involved (three of them, which had to be taken in a specific and tedious order). However working with a web application also allowed us to better modularize and encapsulate the logic behind the verification process. It turned out that three distinct steps were enough to close a verification job for a trivial program (a multiplication of two 32-bits unsigned integers). 

This basic [arithmetic example](https://github.com/project-oak/rust-verification-tools/blob/b179e90daa9ec77c2a81b903ff832aaca4f87b5b/demos/simple/klee/src/main.rs) taken from the RVT project let us discover the primitives of klee functions implemented by RVT maintainers for rust programs to be verified. It also prevented us from wandering off in too many directions associated with the complexity of the tools involved ([LLVM](https://llvm.org/) and [KLEE](http://klee.github.io/), being both two important pieces of complex technologies required by this project, which saved us tremendous amount of time and headaches thanks to the incredible work and deep documentation efforts provided by the [RVT project authors](https://github.com/project-oak/rust-verification-tools/graphs/contributors)).

### Phase 2 - Scope reduction and simplification

Based on what we have learnt in Phase 1, we've realized from the feedback we've received (especially thanks to [Dyne](https://www.dyne.org/)'s feedback while accompanying us all along the way) that 
 - there were two many steps involved in the verification process
 - the web-based UI was costly for large programs (without further optimization of the editor)
 - the verification process was quite fragile since it depended on intermediate representation obtained from a rust program with LLVM linker and bitcode generation
 - the most recent programs would not be well supported as the KLEE version we could rely upon was not compiled against the most up-to-date version of LLVM (available for `rustc` compiler available out there).  
As a result the rust compiler version, we used to leverage Rust Verification Tools would not be most of the time compatible with the targeted programs, which were in essence alway quite edgy given the rapid pace of evolution in the field of blockchain smart contract implementation. 


All these concerns led us to making the following decisions

 - 🎯 To reduce the number of steps down to the very strict minimum  

From **3 steps** at the beginning of the project, we simplified the verification process down to **1 step** at the end by combining all of them from the backend component and optimizing intermediate operations like project dependencies download and caching

 - 🎯 To part away from the web interface by considering the implementation of command-line interface (CLI). The web app was great for prototyping and collecting feedback without having to install the whole suite of tools, which would take at best 20 min to set up. However and as it was stated before, large programs made the UI sluggish and would have required further optimization, new libraries selection. 

As a consequence, the HTTP API exposed by the backend inherited two additional steps (program verification and source restoration), whereas all previous routes except the one listing the available steps have been deprecated: 
   - POST `/program-verification/{ project_id }`  
   to run a smart contract verification
   - GET `/program-verification/{{ project_id }}/report`  
   to get a report for some program verification 
   - GET `/program-verification/{{ project_id }}/progress`  
   to get the completion status of a verification
   - POST `/source-restoration/{ project_id }`  
   to restore a previously uploaded source
   - GET `/source-restoration/{{ project_id }}/report`  
   to get a report for some source restoration 
   - GET `/source-restoration/{{ project_id }}/progress`  
   to get the completion status of a source restoration

![SafePKT Command-Line Interface](./img/program-verification-in-cli.png?raw=true)

Optimizing the construction of the RVT-based toolset itself was a subtask described in this [public issue](https://github.com/project-oak/rust-verification-tools/pull/149). No official Docker image could be attached to project-oak/rvt project but we eventually managed to publish our own set of images and tags to ease the backend component set up from the official Docker registry, with the latest tag being worth of about 2Gb of compressed image layers available from [https://hub.docker.com/repository/docker/safepkt/rvt](https://hub.docker.com/repository/docker/safepkt/rvt)
 
In the end, here is a screenshot showing some of the differences between the first iteration result and the latest UI release:
 - A more significant program (real-world case based on `ink!`)
 against a trivial multiplication example
 - The reduction of steps down to a single-step program verification (responsible for source upload, with LLVM bitcode generation and symbolic execution with KLEE being abstracted away by the backend).

![Transition between Phase 1 and Phase 2](./img/latest-mvp-ui-revamp.png?raw=true)

### Phase 3 - VS Code Extension implementation

Since the CLI application was working fine by the time when our second internal deadline has been hit (See Initial Mentoring Plan to learn out more about the overall chronology and what plan has been proposed at the beginning of the project), we have decided to follow up with the VS Code extension implementation, that has been anticipated to be deployed if we were to be on schedule with regards the previous critical steps (the verification of smart contracts itself and the report presentation to fellow users, developers and researchers).

As SafePKT verifier has been designed and implemented since the beginning as a set of loosely coupled components, it was fairly easy (all things considered **AND after** having cleared up how to best rely on rust verification  tools) for us  
 - to reduce the [number of steps](https://github.com/LedgerProject/safepkt_backend/blob/a6d757c20958df480e97805f9f7e5f0d879fe243/src/infrastructure/verification.rs#L14-L16) for the overall verification process (from the backend or/and the frontend by considering deployment for both components or one of them only)
 - to add new steps to the verification pipeline matching a new route of the HTTP API exposed by backend 
 - to remove deprecated steps once everything was working as expected from the frontend
 - to introduce the SafePKT CLI command communicating internally with the internal backend API.
The [SafePKT library](https://github.com/LedgerProject/safepkt_backend/blob/a6d757c20958df480e97805f9f7e5f0d879fe243/src/lib.rs) is consumed by two separate entrypoints:
   - the [CLI entrypoint](https://github.com/LedgerProject/safepkt_backend/blob/a6d757c20958df480e97805f9f7e5f0d879fe243/src/cli.rs)
   - the [HTTP entrypoint](https://github.com/LedgerProject/safepkt_backend/blob/a6d757c20958df480e97805f9f7e5f0d879fe243/src/http.rs) serving appropriate for each of the compliant HTTP requests
 - to port the [logic implemented](https://github.com/LedgerProject/safepkt_frontend/blob/f41c1a91c838355ed7c66379abee96dee91db95e/mixins/step/program-verification.ts#L73-L82) from the frontend when reaching out to the API exposed by the backend to a [VS Code extension](https://github.com/LedgerProject/safepkt_vscode-plugin/blob/e64a47ff5f0d3e76236565e7d0db51a31bed7a79/src/verifier.ts#L101-L143)

![SafePKT Verifier VS Code Extension](./img/program-verification-with-vscode.png?raw=true)

## Bug fixing and improvements

Here are some of the learnings that we could have gathered all along the project:
 - The use of [type-safe languages](https://en.wikipedia.org/wiki/Type_safety) like Rust and TypeScript for both backend, frontend, CLI application and VS Code extension was very helful for our frequent refactoring operations (text editors and IDEs can make our lives so much better thanks to the robustness of modification signaling wrong-doing against more or less explicitely declared types)
 - The use of a [memory-safe language like Rust](https://en.wikipedia.org/wiki/Memory_safety) was also of course critical in gaining confidence while implementing our initial design and its continual refinement series over the course of those 4 months  
 - [Writing tests for the backend](https://github.com/LedgerProject/safepkt_backend/runs/4046111273?check_suite_focus=true) also helped us to better understand how to separate the backend responsibilities when it came down to standardize 
   - a Rust-based project scaffolding from a library or a program source code and a template manifest with a specific set of dependencies mandatory for the execution of RVT based on specific version of LLVM, KLEE and rustc nightly flavors    
   - the execution of arbitrary commands in Docker containers used as controlled environments where all the tools which would need could be set up and tear down at will  
   - the collection of reports and job completion status

### False positives and panic hints

When a test calls a function, which should panic (annotated with [#[should_panic]](https://github.com/paritytech/ink/blob/cca31543d338dcd69c7ac922988b91ebf170edb2/examples/multisig_plain/lib.rs#L695))  
KLEE runs the intermediate representation for this function in the background,  
and since KLEE is not yet made aware at this point of expected failures from panicking program,  
there are false positives raised in these cases.

In order to prevent such false positives from ruining the development experience,  
it is now possible to add a conventional suffix to the end of test function names  
e.g. adding `_fails` to the end of `zero_requirement_construction` would hint the backend component  
about the that a failing test is expected to be equivalent to a passing test.

### Trade-offs

Discarding the use of [web UI](https://safepkt.weaving-the-web.org) at the end let us focus on the researcher / developer experience when it would come to relying on verification results provided by KLEE.

Downloading VS Code text editor and installing [SafePKT verifier](https://marketplace.visualstudio.com/items?itemName=CJDNS.safepkt-verifier) extension is a matter of a couple of minutes, whereas running the single-page application could take longer at the moment because of the embedded text editor limitations (VS Code being an actual optimized text editor and our first online version being very far from perfect in supporting medium to large program when it comes to activating basic options like syntax coloring or symbols navigation).

However, we could imagine replacing in the future the current editor component with something more production-ready like [Monaco Editor](https://github.com/microsoft/monaco-editor) if it would make sense to keep offering such a solution as alternative to editing program from a developer tool like VS Code.

### Security concerns

Since program execution is required for analysis, there is still the open question of how to securely execute the programs so that it doesn't do anything malicious. This question has not been solved yet and we're not quite sure that it could as the attack surface is so large. For now, we consider that isolating program execution within unprivileged containers as a very first step.  

From a very naive perspective, there would be a need for limiting drastically i/o and networking operation along with CPU and memory allocation. All of those resources could be made available or reduced with options activated or deactivated by relying on the Docker engine. We've also been thinking about using [Firecracker](https://firecracker-microvm.github.io/) to further isolate the verification process and for now, we've considered that interested parties would be able to run verification pipelines by using their own internal infrastructure while offering a basic hard-coded example test project verification demo to begin with from one of our dedicated server. 

### Improvements

A list of possible improvements could be as long as a Christmas wishlist so let us make it as short as possible instead by focusing on the essential part:
 - Addition of single-test run by providing a RegExp pattern
 - Parallelization of test-based verification by the backend 
 - Upgrade / Fix of rust dependencies (such as [`ink!` eDSL](https://github.com/paritytech/ink)) mandatory for running
   - compilation with rustc nightly emitting LLVM bitcode
   with compatibility fo one of most recent version of LLVM
   - symbolic execution with KLEE to be made compatible with latest version of LLVM  

See this issue from project-oak/rvt about [`cargo veriy` being incompatible with LLVM 11](https://github.com/project-oak/rust-verification-tools/issues/146#issuecomment-915474999)

 - Port of the verifier for continuous delivery with [GitHub Actions](https://docs.github.com/en/actions) pipelines  
 - Port of the verifier as an extension for [Jetbrains products](https://plugins.jetbrains.com/docs/intellij/getting-started.html)  
 - Port of the verifier as a [Sonarqube plugin](https://docs.sonarqube.org/latest/extend/developing-plugin/)  

## System stability, maintainability

### Ballpark performance

As of today, the verification process takes about 90s when executed from our dedicated server for a suite of about 30 tests without fuzzing. 

Provided that such verification involves 
 - program compilation emitting LLVM bitcode,
 - KLEE symbolic execution of a test suite and
 - the report extraction from a tool writing on the standard output of a container running for each verification request (an actual HTTP request being sent out to a remote backend for the whole testing suite on which the software verification is based on)  

We consider that further optimization would indeed be mandatory in order to decrease the current latency in a way, which would be significant enough for a daily industry-grade feedback loop to be considered satisfying enough.

### VS Code Extension and backend maintenance and deployment

The upside is that the packaging and publication of new versions of the extension is now pretty much semi-automated with [VS Code Extension Manager](https://github.com/microsoft/vscode-vsce).

The backend deployment remains to be fully automated even though the binaries pre-built with GitHub Actions workflow saves us some time (no more manual compilation needed and a nice history of all previously available versions for both backend and CLI applications can be found from the [backend project releases](https://github.com/LedgerProject/safepkt_backend/releases) page)  

The overall project is maintainable and contributions are very welcomed by cloning the [https://github.com/LedgerProject/safepkt](https://github.com/LedgerProject/safepkt) repository before following instructions from its [README](https://github.com/LedgerProject/safepkt/tree/fe7cddd23032ed3624dc26575a04f8a24f61dba0#readme) documentation.   

This repository carries pointers to all other repositories of the project by leveraging [git submodules](https://git-scm.com/docs/git-submodule). 

### Frontend improvements

If we were to develop further a web-frontend, we would only need to make sure that our backend would scale properly since the frontend is also continuously delivered when pushing on the frontend main branch and the projects builds successfully with [vercel.com](https://vercel.com) allowing us to try variations of our app upfront pretty easily thanks to [out of the box nuxt.js airtight integration with Vercel](https://nuxtjs.org/deployments/vercel/). 

### Backend configuration

Since our backend component is responsible for all the heavy lifting, we have opted for relying on a plain description of web and job-oriented services involved in the verification process: [SafePKT Web service description following Compose API reference](https://github.com/LedgerProject/safepkt_backend/tree/main/provisioning/web-server). Please see also [Compose v3 API reference](https://docs.docker.com/compose/compose-file/compose-file-v3/).

As a result, we don't need anymore to build the verifier Docker image run by the backend for each verification job when the backend component needs to be installed before first being deployed on a dedicated server or among other collocated services, but only to download it once from the official Docker registry by running the required Docker command to pull the image needed ([safepkt/rvt:verifier](https://hub.docker.com/layers/171573281/safepkt/rvt/verifier/images/sha256-04f54e4236e5a2c0fc8ec0c6a1fd4dac110d348e80ee620c85a967f2cbb7678c?context=repo)).   

Relying on a ready-for-use container image is now a matter of configuring the backend by [setting an environment variable](https://github.com/LedgerProject/safepkt_backend/blob/main/.env.dist#L9) holding the name and tag of the expected image to be pulled from the registry. 

## Links

 - The [main SafePKT project repository](https://github.com/LedgerProject/safepkt) is made of [a documentation](https://github.com/LedgerProject/safepkt/tree/8056fc5aabfa6a82f158c5f98de32c8e9055e742#readme) and git submodules pointing to  
   - [a research paper "On the Termination of Borrow Checking for Rust"](https://github.com/LedgerProject/safepkt_paper)
   - [a single-page application as frontend component](https://github.com/LedgerProject/safepkt_frontend)   
   - [a backend component and a command-line interface](https://github.com/LedgerProject/safepkt_backend)   
   - [SafePKT verifier as an extension for VS Code text editor](https://github.com/LedgerProject/safepkt_vscode-plugin) and
   - [a ready-for-verification smart-contract project example](https://github.com/LedgerProject/safepkt_smart-contract-example)

# Acknowledgment

We're very grateful towards the following organizations, projects and people:
 - the Project Oak maintainers for making [Rust Verifications Tools](https://project-oak.github.io/rust-verification-tools/), a dual-licensed open-source project (MIT / Apache).
 The RVT tools allowed us to integrate with industrial-grade verification tools in a very effective way.
 - the KLEE Symbolic Execution Engine maintainers
 - the Rust community at large
 - the JavaScript and NuxtJS community at large
 - The University of Reunion Island and the University of Verona
 - All members of the NGI-Ledger Consortium for accompanying us
 [![Blumorpho](./img/blumorpho-logo.png?raw=true)](https://www.blumorpho.com/) [![Dyne](./img/dyne-logo.png?raw=true)](https://www.dyne.org/ledger/)
 [![FundingBox](./img/funding-box-logo.png?raw=true)](https://fundingbox.com/) [![NGI LEDGER](./img/ledger-eu-logo.png?raw=true)](https://ledgerproject.eu/)
 [![European Commission](./img/european-commission-logo.png?raw=true)](https://ec.europa.eu/programmes/horizon2020/en/home)

## Contact

### GitHub

 - [Caleb James de Lisle](https://github.com/cjdelisle)
 - [Étienne Payet](https://github.com/etiennepayet)
 - [David Pearce](https://github.com/DavePearce)
 - [Fausto Spoto](https://github.com/spoto)
 - [Thierry Marianne](https://twitter.com/thierrymarianne)

### LinkedIn

 - [David Pearce](https://www.linkedin.com/in/david-pearce-8592647/)
 - [Fausto Spoto](https://www.linkedin.com/in/fausto-spoto-65171/)
 - [Thierry Marianne](https://twitter.com/thierrymarianne)
 - [CJDNS SASU](https://www.linkedin.com/company/cjdns/)

### Twitter

 - [Caleb James de Lisle](https://twitter.com/cjdelisle)
 - [David Pearce](https://twitter.com/WhileyDave)
 - [Thierry Marianne](https://twitter.com/thierrymarianne)
 - [Université de La Réunion](https://twitter.com/univ_reunion)
 - [Università di Verona](https://twitter.com/univerona)

