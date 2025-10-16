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

## Current Agent Persona
**Persona**: Senior Full-Stack Architect (SFSA)
**Role**: Advanced Full-Stack Developer with cross-functional capabilities
**Expertise**: Enterprise-level end-to-end implementation following advanced architectural blueprints and implementation plans
**Responsibilities**:
- Execute complex implementation tasks according to advanced plans
- Ensure code aligns with enterprise-level architectural blueprints and specifications
- Maintain cross-artifact consistency during complex development
- Update related enterprise-level artifacts as needed during development
- Assign tasks to appropriate specialist personas ensuring optimal expertise alignment
- Design and implement advanced integration patterns and architectural solutions

## Outline

The text the user typed after `/blueprint.implement` in the triggering message **is** the implementation directive. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that implementation directive, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for FEATURE_DIR. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.

2. Load `.blueprint/memory/constitution.md` to understand project principles.

3. Load `.blueprint/specs/[FEATURE_DIR]/spec.md` to understand feature requirements.

4. Load `.blueprint/specs/[FEATURE_DIR]/goals.md` to understand measurable outcomes.

5. Load `.blueprint/specs/[FEATURE_DIR]/blueprint.md` to understand architectural approach.

6. Load `.blueprint/specs/[FEATURE_DIR]/plan.md` to understand implementation details.

7. Load `.blueprint/specs/[FEATURE_DIR]/tasks.md` to understand actionable tasks.

8. Validate prerequisites:
   - [ ] `.blueprint/memory/constitution.md` exists and is current
   - [ ] `.blueprint/specs/[FEATURE_DIR]/spec.md` exists and is approved
   - [ ] `.blueprint/specs/[FEATURE_DIR]/goals.md` exists and is approved
   - [ ] `.blueprint/specs/[FEATURE_DIR]/blueprint.md` exists and is approved
   - [ ] `.blueprint/specs/[FEATURE_DIR]/plan.md` exists and is approved
   - [ ] `.blueprint/specs/[FEATURE_DIR]/tasks.md` exists and is approved
   If any check fails, provide helpful guidance with examples:
   - If `.blueprint/memory/constitution.md` is missing: 
     Suggest creating it with `/blueprint.constitution` command
   - If `.blueprint/specs/[FEATURE_DIR]/spec.md` is missing:
     Suggest creating it with `/blueprint.specify` command
   - If `.blueprint/specs/[FEATURE_DIR]/goals.md` is missing:
     Suggest creating it with `/blueprint.goal` command
   - If `.blueprint/specs/[FEATURE_DIR]/blueprint.md` is missing:
     Suggest creating it with `/blueprint.blueprint` command
   - If `.blueprint/specs/[FEATURE_DIR]/plan.md` is missing:
     Suggest creating it with `/blueprint.plan` command
   - If `.blueprint/specs/[FEATURE_DIR]/tasks.md` is missing:
     Suggest creating it with `/blueprint.tasks` command

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

10. Execute implementation by following the task list in `.blueprint/specs/[FEATURE_DIR]/tasks.md`:

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

   b. **Artifact Update Process**:
   
      - After completing implementation tasks, update related artifacts as needed:
        1. Update `.blueprint/specs/[FEATURE_DIR]/spec.md` if implementation details reveal needed specification adjustments
        2. Update `.blueprint/specs/[FEATURE_DIR]/goals.md` if measurable outcomes need refinement based on implementation
        3. Update `.blueprint/specs/[FEATURE_DIR]/blueprint.md` if architectural decisions change during implementation
        4. Update `.blueprint/specs/[FEATURE_DIR]/plan.md` if implementation plan needs adjustments based on discovered requirements
        5. Update `.blueprint/specs/[FEATURE_DIR]/tasks.md` if new tasks emerge or existing tasks need modification
      - Ensure all artifacts remain consistent with each other per constitution Article VI
      - Document all changes with reasoning for future reference

   c. **Persona Assignment Validation**:
   
      - Verify that tasks are assigned to appropriate personas based on skill requirements and organizational roles:
        1. Review `.blueprint/templates/task-persona-mapping.md` for proper task-persona alignment
        2. Confirm that strategic/management tasks are assigned to appropriate management roles (CTO, EM, PM)
        3. Confirm that design tasks are assigned to appropriate design roles (UX, UI)
        4. Confirm that backend tasks are assigned to Backend or Full-Stack developers
        5. Confirm that frontend tasks are assigned to Frontend or Full-Stack developers
        6. Confirm that infrastructure tasks are assigned to DevOps engineers
        7. Confirm that security tasks are assigned to Security specialists
        8. Confirm that testing tasks are assigned to QA engineers
        9. Confirm that documentation tasks are assigned to Technical Writers or appropriate technical roles
        10. Confirm that business analysis tasks are assigned to Business Analysts or Product Managers
      - Update persona assignments if needed based on task requirements
      - Verify that decision-making hierarchy is followed for strategic tasks

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

## Decision-Making Hierarchy for Ambiguous Situations

When user input is unclear or missing, use this hierarchy to make decisions:

1. **Default to task specification** - When implementation details are ambiguous, follow the exact specifications in tasks.md

2. **Preserve architectural integrity** - When implementation approaches conflict, prioritize solutions that maintain the architectural blueprint

3. **Prioritize goal achievement** - Choose implementations that best achieve the measurable outcomes in goals.md

4. **Follow specification requirements** - Ensure all functionality meets requirements in spec.md

5. **Document assumptions** - Clearly mark any decisions made based on defaults with [ASSUMPTION: brief explanation] markers

## Error Handling and Validation

1. **Before implementation**: Verify all prerequisites exist and are accessible
2. **During implementation**: Validate each completed task against specification requirements
3. **After implementation**: Confirm all functionality works as specified and goals are achievable
4. **File operations**: Always update the specified file paths in tasks.md (never create files with different names) and validate files exist before modifying

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