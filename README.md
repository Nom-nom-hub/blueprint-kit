<div align="center">
    <img src="./media/logo.png"/>
    <h1>🏗️ Blueprint Kit</h1>
    <h3><em>Build high-quality software faster with Blueprint-Driven Development.</em></h3>
</div>

<p align="center">
    <strong>An effort to allow organizations to focus on product scenarios rather than writing undifferentiated code with the help of Blueprint-Driven Development.</strong>
</p>

<p align="center">
    <em>Inspired by the concepts and methodology from <a href="https://github.com/github/spec-kit">Spec-Kit</a>.</em>
</p>

<p align="center">
    <a href="#"><img src="https://img.shields.io/badge/docs-GitHub_Pages-blue" alt="Documentation"/></a>
    <a href="#"><img src="https://img.shields.io/badge/license-MIT-blue" alt="License"/></a>
</p>

---

## Table of Contents

- [🤔 What is Blueprint-Driven Development?](#-what-is-blueprint-driven-development)
- [⚡ Get Started](#-get-started)
- [🤖 Supported AI Agents](#-supported-ai-agents)
- [🔧 Blueprint CLI Reference](#-blueprint-cli-reference)
- [📚 Core Philosophy](#-core-philosophy)
- [🎯 Experimental Goals](#-experimental-goals)
- [🔧 Prerequisites](#-prerequisites)
- [📖 Learn More](#-learn-more)
- [📋 Detailed Process](#-detailed-process)
- [🔍 Troubleshooting](#-troubleshooting)
- [👥 Maintainers](#-maintainers)
- [📄 License](#-license)

## 🤔 What is Blueprint-Driven Development?

Blueprint-Driven Development **flips the script** on traditional software development. For decades, code has been king — specifications were just scaffolding we built and discarded once the "real work" of coding began. Blueprint-Driven Development changes this: **specifications, goals, and architectural blueprints become executable**, directly generating working implementations rather than just guiding them.

This methodology is a synthesis of specification-driven, goal-driven, and blueprint-driven approaches that amplifies human capability by automating mechanical translation. It creates a tight feedback loop where specifications, goals, blueprints, research, and code evolve together, each iteration bringing deeper understanding and better alignment between intent, measurable outcomes, and implementation.

## ⚡ Get Started

### 1. Install Blueprint

Choose your preferred installation method:

#### Option 1: Persistent Installation (Recommended)

Install once and use everywhere:

```bash
uv tool install blueprint-cli --from git+https://github.com/nom-nom-hub/blueprint-kit.git
```

Then use the tool directly:

```bash
blueprint init <PROJECT_NAME>
blueprint check
```

To upgrade blueprint run:

```bash
uv tool install blueprint-cli --force --from git+https://github.com/nom-nom-hub/blueprint-kit.git
```

#### Option 2: One-time Usage

Run directly without installing:

```bash
uvx --from git+https://github.com/nom-nom-hub/blueprint-kit.git blueprint init <PROJECT_NAME>
```

**Benefits of persistent installation:**

- Tool stays installed and available in PATH
- No need to create shell aliases
- Better tool management with `uv tool list`, `uv tool upgrade`, `uv tool uninstall`
- Cleaner shell configuration

### 2. Establish project principles

Use the **`/bluprint.constitution`** command to create your project's governing principles and development guidelines that will guide all subsequent development.

```bash
/bluprint.constitution Create principles focused on code quality, testing standards, user experience consistency, performance requirements, and architectural integrity
```

### 3. Create the specification

Use the **`/bluprint.specify`** command to describe what you want to build. Focus on the **what** and **why**, not the tech stack.

```bash
/bluprint.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

### 4. Define measurable goals

Use the **`/bluprint.goal`** command to define measurable outcomes that the development should achieve.

```bash
/bluprint.goal Define measurable goals: 99.9% uptime, <100ms page load, 10K concurrent users, 95% test coverage
```

### 5. Create architectural blueprint

Use the **`/bluprint.blueprint`** command to generate architectural patterns and system design.

```bash
/bluprint.blueprint Create architectural blueprint: microservices with API gateway, service mesh, event-driven architecture, and containerized deployment
```

### 6. Create a technical implementation plan

Use the **`/bluprint.plan`** command to provide your tech stack and architecture choices.

```bash
/bluprint.plan The application uses React with TypeScript for frontend, Node.js with Express for API, and PostgreSQL for data storage. Use Docker for containerization and Kubernetes for orchestration.
```

### 7. Break down into tasks

Use **`/bluprint.tasks`** to create an actionable task list from your implementation plan.

```bash
/bluprint.tasks
```

### 8. Execute implementation

Use **`/bluprint.implement`** to execute all tasks and build your feature according to the plan.

```bash
/bluprint.implement
```

For detailed step-by-step instructions, see our [comprehensive guide](./blueprint-driven.md).

## 🤖 Supported AI Agents

| Agent                                                     | Support | Notes                                             |
|-----------------------------------------------------------|---------|---------------------------------------------------|
| [Claude Code](https://www.anthropic.com/claude-code)      | ✅ |                                                   |
| [GitHub Copilot](https://code.visualstudio.com/)          | ✅ |                                                   |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | ✅ |                                                   |
| [Cursor](https://cursor.sh/)                              | ✅ |                                                   |
| [Qwen Code](https://github.com/QwenLM/qwen-code)          | ✅ |                                                   |
| [opencode](https://opencode.ai/)                          | ✅ |                                                   |
| [Codex CLI](https://github.com/openai/codex)              | ✅ |                                                   |
| [Windsurf](https://windsurf.com/)                         | ✅ |                                                   |
| [Kilo Code](https://github.com/Kilo-Org/kilocode)         | ✅ |                                                   |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview)   | ✅ |                                                   |
| [CodeBuddy](https://www.codebuddy.ai/)                    | ✅ |                                                   |
| [Roo Code](https://roocode.com/)                          | ✅ |                                                   |

## 🔧 Blueprint CLI Reference

The `blueprint` command supports the following options:

### Commands

| Command     | Description                                                    |
|-------------|----------------------------------------------------------------|
| `init`      | Initialize a new Blueprint project from the latest template      |
| `check`     | Check for installed tools (`git`, `claude`, `gemini`, `code`/`code-insiders`, `cursor-agent`, `windsurf`, `qwen`, `opencode`, `codex`) |

### `blueprint init` Arguments & Options

| Argument/Option        | Type     | Description                                                                  |
|------------------------|----------|------------------------------------------------------------------------------|
| `<project-name>`       | Argument | Name for your new project directory (optional if using `--here`, or use `.` for current directory) |
| `--ai`                 | Option   | AI assistant to use: `claude`, `gemini`, `copilot`, `cursor-agent`, `qwen`, `opencode`, `codex`, `windsurf`, `kilocode`, `auggie`, `roo`, `codebuddy`, or `q` |
| `--script`             | Option   | Script variant to use: `sh` (bash/zsh) or `ps` (PowerShell)                 |
| `--ignore-agent-tools` | Flag     | Skip checks for AI agent tools like Claude Code                             |
| `--no-git`             | Flag     | Skip git repository initialization                                          |
| `--here`               | Flag     | Initialize project in the current directory instead of creating a new one   |
| `--force`              | Flag     | Force merge/overwrite when initializing in current directory (skip confirmation) |
| `--skip-tls`           | Flag     | Skip SSL/TLS verification (not recommended)                                 |
| `--debug`              | Flag     | Enable detailed debug output for troubleshooting                            |
| `--github-token`       | Option   | GitHub token for API requests (or set GH_TOKEN/GITHUB_TOKEN env variable)  |

### Examples

```bash
# Basic project initialization
blueprint init my-project

# Initialize with specific AI assistant
blueprint init my-project --ai claude

# Initialize with Cursor support
blueprint init my-project --ai cursor-agent

# Initialize with PowerShell scripts (Windows/cross-platform)
blueprint init my-project --ai copilot --script ps

# Initialize in current directory
blueprint init . --ai copilot
# or use the --here flag
blueprint init --here --ai copilot

# Force merge into current (non-empty) directory without confirmation
blueprint init . --force --ai copilot
# or 
blueprint init --here --force --ai copilot

# Skip git initialization
blueprint init my-project --ai gemini --no-git

# Enable debug output for troubleshooting
blueprint init my-project --ai claude --debug

# Use GitHub token for API requests (helpful for corporate environments)
blueprint init my-project --ai claude --github-token ghp_your_token_here

# Check system requirements
blueprint check
```

### Available Slash Commands

After running `blueprint init`, your AI coding agent will have access to these slash commands for structured development:

#### Core Commands

Essential commands for the Blueprint-Driven Development workflow:

| Command                  | Description                                                           |
|--------------------------|-----------------------------------------------------------------------|
| `/bluprint.constitution`  | Create or update project governing principles and development guidelines |
| `/bluprint.specify`       | Define what you want to build (requirements and user stories)        |
| `/bluprint.goal`          | Define measurable goals and success metrics                         |
| `/bluprint.blueprint`     | Create architectural blueprints and system design                   |
| `/bluprint.plan`          | Create technical implementation plans with your chosen tech stack     |
| `/bluprint.tasks`         | Generate actionable task lists for implementation                     |
| `/bluprint.implement`     | Execute all tasks to build the feature according to the plan         |

#### Optional Commands

Additional commands for enhanced quality and validation:

| Command              | Description                                                           |
|----------------------|-----------------------------------------------------------------------|
| `/bluprint.clarify`   | Clarify underspecified areas (recommended before `/bluprint.plan`; formerly `/quizme`) |
| `/bluprint.analyze`   | Cross-artifact consistency & coverage analysis (run after `/bluprint.tasks`, before `/bluprint.implement`) |
| `/bluprint.checklist` | Generate custom quality checklists that validate requirements completeness, clarity, and consistency (like "unit tests for English") |

### Environment Variables

| Variable         | Description                                                                                    |
|------------------|------------------------------------------------------------------------------------------------|
| `BLUEPRINT_FEATURE` | Override feature detection for non-Git repositories. Set to the feature directory name (e.g., `001-photo-albums`) to work on a specific feature when not using Git branches.<br/>**Must be set in the context of the agent you're working with prior to using `/bluprint.plan` or follow-up commands. |

## 📚 Core Philosophy

Blueprint-Driven Development is a structured process that emphasizes:

- **Intent-driven development** where specifications define the "_what_" before the "_how_"
- **Measurable goals** that drive development outcomes
- **Architectural blueprints** that guide system design
- **Rich specification creation** using guardrails and organizational principles
- **Multi-step refinement** rather than one-shot code generation from prompts
- **Heavy reliance** on advanced AI model capabilities for specification interpretation

## 🎯 Experimental Goals

Our research and experimentation focus on:

### Technology independence

- Create applications using diverse technology stacks
- Validate the hypothesis that Blueprint-Driven Development is a process not tied to specific technologies, programming languages, or frameworks

### Enterprise constraints

- Demonstrate mission-critical application development
- Incorporate organizational constraints (cloud providers, tech stacks, engineering practices)
- Support enterprise design systems and compliance requirements

### User-centric development

- Build applications for different user cohorts and preferences
- Support various development approaches (from vibe-coding to AI-native development)

### Creative & iterative processes

- Validate the concept of parallel implementation exploration
- Provide robust iterative feature development workflows
- Extend processes to handle upgrades and modernization tasks

## 🔧 Prerequisites

- **Linux/macOS/Windows**
- [Supported](#-supported-ai-agents) AI coding agent.
- [uv](https://docs.astral.sh/uv/) for package management
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

If you encounter issues with an agent, please open an issue so we can refine the integration.

## 📖 Learn More

- **[Complete Blueprint-Driven Development Methodology](./blueprint-driven.md)** - Deep dive into the full process

---

## 📋 Detailed Process

<details>
<summary>Click to expand the detailed step-by-step walkthrough</summary>

You can use the Blueprint CLI to bootstrap your project, which will bring in the required artifacts in your environment. Run:

```bash
blueprint init <project_name>
```

Or initialize in the current directory:

```bash
blueprint init .
# or use the --here flag
blueprint init --here
# Skip confirmation when the directory already has files
blueprint init . --force
# or
blueprint init --here --force
```

You will be prompted to select the AI agent you are using. You can also proactively specify it directly in the terminal:

```bash
blueprint init <project_name> --ai claude
blueprint init <project_name> --ai gemini
blueprint init <project_name> --ai copilot

# Or in current directory:
blueprint init . --ai claude
blueprint init . --ai codex

# or use --here flag
blueprint init --here --ai claude
blueprint init --here --ai codex

# Force merge into a non-empty current directory
blueprint init . --force --ai claude

# or
blueprint init --here --force --ai claude
```

The CLI will check if you have Claude Code, Gemini CLI, Cursor CLI, Qwen CLI, opencode, Codex CLI, or other agent CLIs installed. If you do not, or you prefer to get the templates without checking for the right tools, use `--ignore-agent-tools` with your command:

```bash
blueprint init <project_name> --ai claude --ignore-agent-tools
```

### **STEP 1:** Establish project principles

Go to the project folder and run your AI agent. In our example, we're using `claude`.

You will know that things are configured correctly if you see the `/bluprint.constitution`, `/bluprint.specify`, `/bluprint.goal`, `/bluprint.blueprint`, `/bluprint.plan`, `/bluprint.tasks`, and `/bluprint.implement` commands available.

The first step should be establishing your project's governing principles using the `/bluprint.constitution` command. This helps ensure consistent decision-making throughout all subsequent development phases:

```text
/bluprint.constitution Create principles focused on code quality, testing standards, user experience consistency, performance requirements, and architectural integrity. Include governance for how these principles should guide technical decisions and implementation choices.
```

This step creates or updates the `.blueprint/memory/constitution.md` file with your project's foundational guidelines that the AI agent will reference during specification, goal-setting, blueprint creation, planning, and implementation phases.

### **STEP 2:** Create project specifications

With your project principles established, you can now create the functional specifications. Use the `/bluprint.specify` command and then provide the concrete requirements for the project you want to develop.

> [!IMPORTANT]
> Be as explicit as possible about _what_ you are trying to build and _why_. **Do not focus on the tech stack at this point**.

An example prompt:

```text
Develop Taskify, a team productivity platform. It should allow users to create projects, add team members,
assign tasks, comment and move tasks between boards in Kanban style. In this initial phase for this feature,
let's call it "Create Taskify," let's have multiple users but the users will be declared ahead of time, predefined.
I want five users in two different categories, one product manager and four engineers. Let's create three
different sample projects. Let's have the standard Kanban columns for the status of each task, such as "To Do,"
"In Progress," "In Review," and "Done." There will be no login for this application as this is just the very
first testing thing to ensure that our basic features are set up. For each task in the UI for a task card,
you should be able to change the current status of the task between the different columns in the Kanban work board.
You should be able to leave an unlimited number of comments for a particular card. You should be able to, from that task
card, assign one of the valid users. When you first launch Taskify, it's going to give you a list of the five users to pick
from. There will be no password required. When you click on a user, you go into the main view, which displays the list of
projects. When you click on a project, you open the Kanban board for that project. You're going to see the columns.
You'll be able to drag and drop cards back and forth between different columns. You will see any cards that are
assigned to you, the currently logged in user, in a different color from all the other ones, so you can quickly
see yours. You can edit any comments that you make, but you can't edit comments that other people made. You can
delete any comments that you made, but you can't delete comments anybody else made.
```

After this prompt is entered, you should see your AI agent kick off the planning and spec drafting process. The agent will also trigger some of the built-in scripts to set up the repository.

Once this step is completed, you should have a new branch created (e.g., `001-create-taskify`), as well as a new specification in the `specs/001-create-taskify` directory.

The produced specification should contain a set of user stories and functional requirements, as defined in the template.

At this stage, your project folder contents should resemble the following:

```text
└── .blueprint
    ├── memory
    │    └── constitution.md
    ├── scripts
    │    ├── check-prerequisites.sh
    │    ├── common.sh
    │    ├── create-new-feature.sh
    │    ├── setup-plan.sh
    │    └── update-claude-md.sh
    ├── specs
    │    └── 001-create-taskify
    │        └── spec.md
    └── templates
        ├── plan-template.md
        ├── spec-template.md
        └── tasks-template.md
```

### **STEP 3:** Functional specification clarification (required before planning)

With the baseline specification created, you can go ahead and clarify any of the requirements that were not captured properly within the first shot attempt.

You should run the structured clarification workflow **before** creating a technical plan to reduce rework downstream.

Preferred order:
1. Use `/bluprint.clarify` (structured) – sequential, coverage-based questioning that records answers in a Clarifications section.
2. Optionally follow up with ad-hoc free-form refinement if something still feels vague.

If you intentionally want to skip clarification (e.g., spike or exploratory prototype), explicitly state that so the agent doesn't block on missing clarifications.

Example free-form refinement prompt (after `/bluprint.clarify` if still needed):

```text
For each sample project or project that you create there should be a variable number of tasks between 5 and 15
tasks for each one randomly distributed into different states of completion. Make sure that there's at least
one task in each stage of completion.
```

You should also ask your AI agent to validate the **Review & Acceptance Checklist**, checking off the things that are validated/pass the requirements, and leave the ones that are not unchecked. The following prompt can be used:

```text
Read the review and acceptance checklist, and check off each item in the checklist if the feature spec meets the criteria. Leave it empty if it does not.
```

It's important to use the interaction with your AI agent as an opportunity to clarify and ask questions around the specification - **do not treat its first attempt as final**.

### **STEP 4:** Define measurable goals

With the specification in place, you can now define clear, measurable goals that the development should achieve. Use the `/bluprint.goal` command with specific, measurable outcomes:

```text
/bluprint.goal Define the measurable goals for Taskify: 99.9% uptime, <100ms page load times, support 10K concurrent users, achieve 95% test coverage, maintain 90% user satisfaction scores.
```

The output of this step will enhance your project directory with goal definitions:

```text
.
├── CLAUDE.md
├── memory
│    └── constitution.md
├── scripts
│    ├── check-prerequisites.sh
│    ├── common.sh
│    ├── create-new-feature.sh
│    ├── setup-plan.sh
│    └── update-claude-md.sh
├── specs
│    └── 001-create-taskify
│        ├── goals.md
│        └── spec.md
└── templates
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

### **STEP 5:** Generate architectural blueprints

With goals defined, create the architectural blueprints using `/bluprint.blueprint` that will guide the system design:

```text
/bluprint.blueprint Create architectural blueprints for Taskify: microservices architecture with API gateway, service mesh for communication, event-driven patterns for task updates, containerized deployment with Docker and Kubernetes, database per service pattern with PostgreSQL for user data and Redis for sessions.
```

This step adds architectural blueprints to your project structure:

```text
.
├── CLAUDE.md
├── memory
│    └── constitution.md
├── scripts
├── specs
│    └── 001-create-taskify
│        ├── blueprint.md
│        ├── goals.md
│        └── spec.md
└── templates
```

### **STEP 6:** Generate a plan

You can now be specific about the tech stack and other technical requirements. You can use the `/bluprint.plan` command that is built into the project template with a prompt like this:

```text
We are going to generate this using .NET Aspire, using Postgres as the database. The frontend should use
Blazor server with drag-and-drop task boards, real-time updates. There should be a REST API created with a projects API,
tasks API, and a notifications API.
```

The output of this step will include a number of implementation detail documents, with your directory tree resembling this:

```text
.
├── CLAUDE.md
├── memory
│    └── constitution.md
├── scripts
│    ├── check-prerequisites.sh
│    ├── common.sh
│    ├── create-new-feature.sh
│    ├── setup-plan.sh
│    └── update-claude-md.sh
├── specs
│    └── 001-create-taskify
│        ├── contracts
│        │    ├── api-spec.json
│        │    └── signalr-spec.md
│        ├── data-model.md
│        ├── plan.md
│        ├── quickstart.md
│        ├── research.md
│        ├── blueprint.md
│        ├── goals.md
│        └── spec.md
└── templates
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

Check the `research.md` document to ensure that the right tech stack is used, based on your instructions. You can ask your AI agent to refine it if any of the components stand out, or even have it check the locally-installed version of the platform/framework you want to use (e.g., .NET).

Additionally, you might want to ask your AI agent to research details about the chosen tech stack if it's something that is rapidly changing (e.g., .NET Aspire, JS frameworks), with a prompt like this:

```text
I want you to go through the implementation plan and implementation details, looking for areas that could
benefit from additional research as .NET Aspire is a rapidly changing library. For those areas that you identify that
require further research, I want you to update the research document with additional details about the specific
versions that we are going to be using in this Taskify application and spawn parallel research tasks to clarify
any details using research from the web.
```

>[!NOTE]
>Your AI agent might be over-eager and add components that you did not ask for. Ask it to clarify the rationale and the source of the change.

### **STEP 7:** Have your AI agent validate the plan

With the plan in place, you should have your AI agent run through it to make sure that there are no missing pieces. You can use a prompt like this:

```text
Now I want you to go and audit the implementation plan, goals, and architectural blueprints.
Read through it with an eye on determining whether or not there is a sequence of tasks that you need
to be doing that are obvious from reading this. Because I don't know if there's enough here. For example,
when I look at the core implementation, it would be useful to reference the appropriate places in the implementation
details where it can find the information as it walks through each step in the core implementation or in the refinement.
```

This helps refine the implementation plan and helps you avoid potential blind spots that your AI agent missed in its planning cycle. Once the initial refinement pass is complete, ask your AI agent to go through the checklist once more before you can get to the implementation.

You can also ask your AI agent (if you have the [GitHub CLI](https://docs.github.com/en/github-cli/github-cli) installed) to go ahead and create a pull request from your current branch to `main` with a detailed description, to make sure that the effort is properly tracked.

>[!NOTE]
>Before you have the agent implement it, it's also worth prompting your AI agent to cross-check the details to see if there are any over-engineered pieces (remember - it can be over-eager). If over-engineered components or decisions exist, you can ask your AI agent to resolve them. Ensure that your AI agent follows the [constitution](base/memory/constitution.md) as the foundational piece that it must adhere to when establishing the plan.

### **STEP 8:** Generate task breakdown with /bluprint.tasks

With the implementation plan, goals, and blueprints validated, you can now break down the plan into specific, actionable tasks that can be executed in the correct order. Use the `/bluprint.tasks` command to automatically generate a detailed task breakdown from your implementation plan:

```text
/bluprint.tasks
```

This step creates a `tasks.md` file in your feature specification directory that contains:

- **Task breakdown organized by user story** - Each user story becomes a separate implementation phase with its own set of tasks
- **Dependency management** - Tasks are ordered to respect dependencies between components (e.g., models before services, services before endpoints)
- **Parallel execution markers** - Tasks that can run in parallel are marked with `[P]` to optimize development workflow
- **File path specifications** - Each task includes the exact file paths where implementation should occur
- **Test-driven development structure** - If tests are requested, test tasks are included and ordered to be written before implementation
- **Checkpoint validation** - Each user story phase includes checkpoints to validate independent functionality

The generated tasks.md provides a clear roadmap for the `/bluprint.implement` command, ensuring systematic implementation that maintains code quality and allows for incremental delivery of user stories.

### **STEP 9:** Implementation

Once ready, use the `/bluprint.implement` command to execute your implementation plan:

```text
/bluprint.implement
```

The `/bluprint.implement` command will:
- Validate that all prerequisites are in place (constitution, spec, goals, blueprint, plan, and tasks)
- Parse the task breakdown from `tasks.md`
- Execute tasks in the correct order, respecting dependencies and parallel execution markers
- Follow the TDD approach defined in your task plan
- Provide progress updates and handle errors appropriately

>[!IMPORTANT]
>The AI agent will execute local CLI commands (such as `dotnet`, `npm`, etc.) - make sure you have the required tools installed on your machine.

Once the implementation is complete, test the application and resolve any runtime errors that may not be visible in CLI logs (e.g., browser console errors). You can copy and paste such errors back to your AI agent for resolution.

</details>

---

## 🔍 Troubleshooting

### Git Credential Manager on Linux

If you're having issues with Git authentication on Linux, you can install Git Credential Manager:

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```

## 👥 Maintainers

- Blueprint Kit Team

## 📄 License

This project is licensed under the terms of the MIT open source license. Please refer to the [LICENSE](./LICENSE) file for the full terms.

## ℹ️ TOML File Compatibility Fix

This project now includes a fix for an issue where TOML files were being created with backslashes (`\`) instead of forward slashes (`/`) on Windows systems, which was preventing AI agents from recognizing them properly. The issue has been resolved at the source - any backslashes in content that would be placed in TOML files are now automatically converted to forward slashes when generating agent command files.