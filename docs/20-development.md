# Development

This section requires having followed the [installation instructions](./00-install.md).

As the frontend depends on the backend,  
running the frontend development server compiles the backend binary,  
before executing it to serve request from [http://localhost:3001](http://localhost:3001) by default. 

The SafePKT web application will then be available from [http://localhost:3000](http://localhost:3000).

```shell
make run-frontend
```

## Health check

A simple health check command can be executed for the backend:

```shell
curl http://127.0.0.1:3001/steps
```

which should output

```
{
  "steps": [
    "llvm_bitcode_generation",
    "symbolic_execution"
  ]
}
```

There are also logs available from `./backend/logs` directory

```shell
tail -fn100 ./backend/log/backend.log
```

## Table of contents

[README](../README.md) | [Section 00 - Preview](./00-preview.md) | [Section 10 - Installation](./10-installation.md) | [Section 20 - Development](./20-development.md)
