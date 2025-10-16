---
description: Create or update the project's governing principles and development guidelines.
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

## Current Agent Persona
**Persona**: Chief Technology Officer (CTO)
**Role**: Executive Technology Leadership
**Expertise**: Advanced technology strategy, enterprise governance, and organizational principles
**Responsibilities**:
- Define enterprise-level project governing principles and development guidelines
- Establish advanced architectural and coding standards
- Ensure technology decisions align with strategic business objectives
- Set organizational technical culture and advanced practices
- Drive technological innovation and emerging technology adoption
- Assess and mitigate enterprise-level technical risks

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/blueprintkit.constitution` in the triggering message **is** the constitutional principles description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that description, do this:

1. Load the `.blueprintkit/memory/constitution.md` file if it exists, otherwise use the template below
2. Update the constitution with the new principles described by the user
3. Ensure all principles align with the Blueprint-Driven Development methodology
4. Focus on principles that guide architectural decisions, code quality, testing standards, and user experience consistency

## Constitutional Principles Template

Update the following sections with the user-provided principles:

### Article I: Library-First Principle
Every feature must begin as a standalone library—no exceptions. This forces modular design from the start:

```text
Every feature in Blueprint Kit MUST begin its existence as a standalone library.
No feature shall be implemented directly within application code without
first being abstracted into a reusable library component.
```

### Article II: CLI Interface Mandate
Every library must expose its functionality through a command-line interface:

```text
All CLI interfaces MUST:
- Accept text as input (via stdin, arguments, or files)
- Produce text as output (via stdout)
- Support JSON format for structured data exchange
```

### Article III: Test-First Imperative
The most transformative article—no code before tests:

```text
This is NON-NEGOTIABLE: All implementation MUST follow strict Test-Driven Development.
No implementation code shall be written before:
1. Unit tests are written
2. Tests are validated and approved by the user
3. Tests are confirmed to FAIL (Red phase)
```

### Article IV: Intent-Driven Development
Specifications, goals, and blueprints drive implementation:

```text
All implementation MUST be driven by the triple foundation of:
- Clear specifications that define WHAT the system should do
- Measurable goals that define SUCCESS metrics
- Architectural blueprints that define the technical approach
```

### Article V: Blueprint Integration
All technical decisions must align with architectural blueprints:

```text
Every technology choice and architectural decision MUST:
- Align with the defined architectural blueprint
- Support the stated goals and measurable outcomes
- Follow from the specifications and requirements
```

### Article VI: Cross-Artifact Consistency
Maintain consistency across specifications, goals, and blueprints:

```text
All artifacts MUST remain consistent:
- Specifications, goals, blueprints, and plans must align
- Changes to one artifact must propagate to others
- Contradictions between artifacts are not allowed
```

### Article VII: Simplicity and Minimalism
Prevent over-engineering:

```text
Section 7.1: Minimal Project Structure
- Maximum 3 projects for initial implementation
- Additional projects require documented justification

Section 7.2: Requirement Focus
- Implement only what's specified in the requirements
- No speculative features without explicit goals
```

### Article VIII: Anti-Abstraction Principle
Use framework features directly:

```text
Section 8.1: Framework Trust
- Use framework features directly rather than wrapping them
- Only create abstractions when solving specific, identified problems
```

### Article IX: Integration-First Testing
Prioritize real-world testing:

```text
Tests MUST use realistic environments:
- Prefer real databases over mocks
- Use actual service instances over stubs
- Contract tests mandatory before implementation
- Goal validation tests required for measurable outcomes
```

## Process

1. Read the current constitution if it exists
2. Incorporate the user's principles while maintaining the core Blueprint-Driven Development approach
3. Update the template sections as appropriate
4. Save to `.blueprintkit/memory/constitution.md`

## General Guidelines

- Focus on principles that guide technical decisions
- Ensure principles support the integration of specifications, goals, and blueprints
- Maintain the core Blueprint-Driven Development philosophy
- Document the rationale for each principle