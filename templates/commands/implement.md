---
description: Execute all tasks and implement the feature according to the plan, goals, and blueprint.
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/blueprintkit.implement` in the triggering message **is** the implementation directive. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that implementation directive, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for FEATURE_DIR. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.

2. Load `.blueprintkit/memory/constitution.md` to understand project principles.

3. Load `specs/[FEATURE_DIR]/spec.md` to understand feature requirements.

4. Load `specs/[FEATURE_DIR]/goals.md` to understand measurable outcomes.

5. Load `specs/[FEATURE_DIR]/blueprint.md` to understand architectural approach.

6. Load `specs/[FEATURE_DIR]/plan.md` to understand implementation details.

7. Load `specs/[FEATURE_DIR]/tasks.md` to understand actionable tasks.

8. Validate prerequisites:
   - [ ] `.blueprintkit/memory/constitution.md` exists and is current
   - [ ] `specs/[FEATURE_DIR]/spec.md` exists and is approved
   - [ ] `specs/[FEATURE_DIR]/goals.md` exists and is approved
   - [ ] `specs/[FEATURE_DIR]/blueprint.md` exists and is approved
   - [ ] `specs/[FEATURE_DIR]/plan.md` exists and is approved
   - [ ] `specs/[FEATURE_DIR]/tasks.md` exists and is approved
   If any check fails, ERROR with specific prerequisite that's missing.

9. Follow this execution flow:

    1. Parse user description from Input
       If empty: Use default implementation approach
    2. Parse tasks from tasks.md
       - Extract all tasks with their file paths
       - Identify parallel tasks marked with [P] flag
       - Create execution order based on dependencies
    3. Execute tasks in appropriate order:
       - Execute parallel tasks concurrently where possible
       - Execute dependent tasks sequentially after dependencies
       - Validate each completed task if validation criteria specified
    4. For each task execution:
       - Create or update specified file path
       - Implement functionality according to plan.md
       - Ensure implementation aligns with blueprint.md
       - Verify contribution toward goals.md outcomes
    5. Validate implementation against spec.md requirements
    6. Return: SUCCESS (implementation complete and validated)

10. Execute implementation by following the task list in `specs/[FEATURE_DIR]/tasks.md`:

   a. **Implementation Process**:
   
      - For each task in the correct order:
        1. Create or update the specified file path
        2. Implement the functionality as described in the task
        3. Follow the implementation approach from plan.md
        4. Align with architectural blueprint from blueprint.md
        5. Validate against requirements in spec.md
        6. Verify contribution to goals in goals.md
      - Execute parallel tasks [P] concurrently when possible
      - Validate completed user stories as they are finished
      - Perform integration validation as components come together

   b. **Quality Assurance**:
   
      - Adhere to principles in constitution.md
      - Follow test-first approach where specified in plan.md
      - Ensure code quality and maintainability
      - Verify all functionality works as specified in spec.md
      - Confirm measurable outcomes from goals.md are achievable
      - Validate architectural compliance with blueprint.md

   c. **Validation Process**:
   
      - After completing each user story, validate functionality
      - Run any tests specified in plan.md or tasks.md
      - Verify that implementation meets success criteria from spec.md
      - Confirm progress toward goals from goals.md
      - Validate architectural components from blueprint.md

11. Report completion status with:
   - Summary of implemented functionality
   - Validation results against spec, goals, and blueprint
   - Remaining work if any tasks could not be completed
   - Readiness for the next phase (testing, deployment, etc.)

**NOTE:** The script validates all prerequisites before starting implementation and executes tasks according to the defined order and parallelization.

## General Guidelines

## Quick Guidelines

- Execute tasks as specified in tasks.md with specific file paths.
- Ensure implementation aligns with plan.md, goals.md, and blueprint.md.
- Follow principles in constitution.md.
- Implement with test-first approach where specified.
- Written for developers executing the implementation.
- DO NOT skip validation steps - ensure implementation meets all requirements.

### Implementation Requirements

- **Constitution Compliance**: All implementation must follow constitution.md principles
- **Specification Alignment**: All functionality must meet spec.md requirements
- **Goal Achievement**: Implementation must enable goals.md outcomes
- **Architectural Compliance**: Implementation must follow blueprint.md architecture
- **Plan Adherence**: Implementation steps must match plan.md approach

### For AI Generation

When implementing from the artifacts:

1. **Follow tasks precisely**: Execute each task as specified with correct file paths
2. **Validate continuously**: Check that implementation aligns with all artifacts
3. **Maintain quality**: Follow best practices and principles from constitution.md
4. **Consider dependencies**: Execute tasks in the correct order
5. **Enable parallel work**: Execute [P] tasks concurrently when possible
6. **Verify functionality**: Ensure implemented features work as specified
7. **Achieve goals**: Confirm progress toward measurable outcomes in goals.md

**Implementation Best Practices**:

- Follow test-driven development where specified in the plan
- Maintain clean, readable code that aligns with architectural blueprint
- Implement error handling as specified in the plan
- Follow security practices outlined in the blueprint
- Ensure performance requirements from goals are met
- Validate data integrity according to specification requirements

### Validation Guidelines

Implementation validation must include:

1. **Functional Validation**: Features work as specified in spec.md
2. **Goal Validation**: Progress toward measurable outcomes in goals.md
3. **Architectural Validation**: Implementation follows blueprint.md 
4. **Quality Validation**: Code follows constitution.md principles
5. **Integration Validation**: Components work together properly