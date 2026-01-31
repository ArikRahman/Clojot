# AGENTS.md

## Project Overview

**Clojot** (also known as godot-clojure) is a project aimed at integrating Clojure with the Godot game engine using GDExtension. This allows developers to write Godot game logic in Clojure.

The core mechanism involves compiling a shared library (`entry.so`) that links against the JVM, allowing Godot to invoke Clojure code.

## Directory Structure

- `src/`: Source code for the integration.
    - `entry.c`: C entry point for the GDExtension shared library.
    - `godot_clojure/`: Clojure source files.
- `bin/`: Utility scripts for development (nREPL, testing).
- `godot-headers/`: GDExtension headers.
- `test/`: Tests.

## Development Environment Setup

### Prerequisites

- **Java:** OpenJDK 11 is required (`openjdk-11-jdk`). The `Makefile` currently hardcodes the `JAVA_HOME` path to `/usr/lib/jvm/java-1.11.0-openjdk-amd64`, so ensure this matches your environment or update the Makefile.
- **Clang:** Used for processing `gdextension_interface.h`.
- **GCC:** Used for compiling the C entry point.
- **Clojure Tools:** `clj`, `bb` (Babashka) likely needed based on `bb.edn`.

### Building

To build the shared library `entry.so`, run:

```bash
make
```

This compiles `src/entry.c` and links it against the JVM.

## Running Tests & Linting

- **Linting:**
  ```bash
  clj-kondo --lint src/
  ```

- **Non-Godot Tests:**
  ```bash
  bin/kaocha --skip godot
  ```

- **Godot Integration Tests:**
  ```bash
  bin/test-godot
  ```
  *Note:* These tests launch the Godot runtime. Currently, the process may not exit automatically after testing.

## Development Workflow

- **REPL:** You can start an nREPL session with a Godot handle using:
  ```bash
  bin/nrepl
  ```

## Key Files to Watch

- `src/entry.c`: The bridge between GDExtension C API and the JVM/Clojure runtime.
- `src/godot_clojure/core.clj`: Core Clojure logic for the integration.
- `Makefile`: Controls the build process for the shared library.