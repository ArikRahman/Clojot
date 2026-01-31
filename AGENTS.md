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


# Author notes:

On NixOS

## Development Environment Setup

### Prerequisites

- **Java:** OpenJDK 11 is required (`openjdk-11-jdk`). The `Makefile` currently hardcodes the `JAVA_HOME` path to `/usr/lib/jvm/java-1.11.0-openjdk-amd64`, so ensure this matches your environment or update the Makefile.
- **Clang:** Used for processing `gdextension_interface.h`.
<!--- **GCC:** Used for compiling the C entry point.--> Clang > GCC
- **Clojure Tools:** `clj`, `bb` (Babashka) needed based on `bb.edn`.

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


Agents workflow:

- mandatory to use Manus workflow, read below, use folder called manus for documentation for manus worfklow in task subfolder

Manus workflow - According to manus:
Why This Skill?

On December 29, 2025, Meta acquired Manus for $2 billion. In just 8 months, Manus went from launch to $100M+ revenue. Their secret? Context engineering.

This skill implements Manus's core workflow pattern:

    "Markdown is my 'working memory' on disk. Since I process information iteratively and my active context has limits, Markdown files serve as scratch pads for notes, checkpoints for progress, building blocks for final deliverables." — Manus AI

The Problem

Claude Code (and most AI agents) suffer from:

    Volatile memory — TodoWrite tool disappears on context reset
    Goal drift — After 50+ tool calls, original goals get forgotten
    Hidden errors — Failures aren't tracked, so the same mistakes repeat
    Context stuffing — Everything crammed into context instead of stored

The Solution: 3-File Pattern

For every complex task, create THREE files in a task subfolder:

task_plan.md      → Track phases and progress
notes.md          → Store research and findings, only in notes.md, not a separate findings file
[deliverable].md  → Final output

The Loop

1. Create task_plan.md with goal and phases
2. Research → save to notes.md → update task_plan.md
3. Read notes.md → create deliverable → update task_plan.md
4. Deliver final output
------------
Key insight: By reading task_plan.md before each decision, goals stay in the attention window. This is how Manus handles ~50 tool calls without losing track.
