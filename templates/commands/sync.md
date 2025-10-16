---
description: Synchronize all related artifacts to maintain consistency during development.
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

## Current Agent Persona
**Persona**: Senior Engineering Manager (SEM)
**Role**: Advanced Cross-functional Coordination and Enterprise Process Management
**Expertise**: Maintaining enterprise-level artifact consistency, advanced cross-team coordination, and strategic process management
**Responsibilities**:
- Ensure enterprise-level consistency across all project artifacts
- Coordinate complex updates between different development components
- Maintain advanced traceability and synchronization between related documents
- Validate that enterprise-level changes in one area are properly reflected in others
- Optimize organizational processes and efficiency across teams

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/blueprint.sync` in the triggering message **is** the synchronization directive. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that synchronization directive, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for FEATURE_DIR. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.

2. Load `.blueprint/memory/constitution.md` to understand project principles.

3. Load `.blueprint/specs/[FEATURE_DIR]/spec.md` to understand feature requirements.

4. Load `.blueprint/specs/[FEATURE_DIR]/goals.md` to understand measurable outcomes.

5. Load `.blueprint/specs/[FEATURE_DIR]/blueprint.md` to understand architectural approach.

6. Load `.blueprint/specs/[FEATURE_DIR]/plan.md` to understand implementation details.

7. Load `.blueprint/specs/[FEATURE_DIR]/tasks.md` to understand actionable tasks.

8. If any required file is missing, ERROR with specific file name that's missing.

9. Follow this execution flow:

    1. Parse user description from Input
       If empty: Use default synchronization approach
    2. Analyze current state of all artifacts:
       - Check for inconsistencies between spec, goals, blueprint, plan, and tasks
       - Identify any documents that may be out of sync
       - Find any changes that need to be propagated to other artifacts
    3. Apply synchronization process based on the sync-template.md
    4. Validate consistency after synchronization
    5. Return: SUCCESS (artifacts synchronized and consistent)

10. Perform synchronization according to the Artifact Synchronization Guide:

   a. **Identify Changes**:
      - Review recent modifications in all artifacts
      - Identify changes that may affect other documents
      - Flag areas where consistency may be compromised

   b. **Update Process**:
      - Update all artifacts that need changes based on recent development
      - Follow the bidirectional update principle
      - Document rationales for changes
      - Maintain traceability between related elements

   c. **Validation**:
      - Verify consistency between all artifacts
      - Check that implementation, specification, goals, and architecture align
      - Validate using the checklist in sync-template.md

11. Generate synchronization report in this structure:

   ```markdown
   # Artifact Synchronization Report: [FEATURE NAME]
   
   **Synchronization Date**: [DATE]
   **Feature**: [FEATURE_DIR]
   **Synchronizer**: [AI Model/Version]
   
   ## Executive Summary
   [Brief overview of synchronization activities and key findings]
   
   ## Changes Made
   
   ### Spec Updates
   - [List of updates made to spec.md]
   - [Rationale for each update]
   
   ### Goal Updates  
   - [List of updates made to goals.md]
   - [Rationale for each update]
   
   ### Blueprint Updates
   - [List of updates made to blueprint.md]
   - [Rationale for each update]
   
   ### Plan Updates
   - [List of updates made to plan.md]
   - [Rationale for each update]
   
   ### Tasks Updates
   - [List of updates made to tasks.md]
   - [Rationale for each update]
   
   ## Consistency Validation
   - [Result of consistency validation checks]
   - [Any issues identified and resolved]
   
   ## Recommendations
   - [Any additional recommendations for maintaining synchronization]
   
   ## Next Synchronization
   - [When next synchronization should occur]
   ```

12. Ensure all updates follow the principles in constitution.md, particularly Article VI (Cross-Artifact Consistency).

13. Report synchronization results with:
   - CREATE OR OVERWRITE complete synchronization report at `.blueprint/specs/[FEATURE_DIR]/synchronization.md`
   - Summary of key changes made
   - Confirmation of consistency between all artifacts
   - Recommendations for maintaining synchronization going forward

**NOTE**: The script performs comprehensive synchronization across all artifacts to maintain consistency during development.

## General Guidelines

## Quick Guidelines

- **IDENTIFY** inconsistencies between artifacts.
- **UPDATE** related documents when changes occur.
- **VALIDATE** consistency after updates.
- **DOCUMENT** rationales for all changes.
- **TRACE** relationships between related elements.
- Written for maintaining cross-artifact consistency during development.

## Decision-Making Hierarchy for Ambiguous Situations

When synchronization decisions are unclear, use this hierarchy to make decisions:

1. **Default to constitution principles** - When conflicts exist between artifacts, prioritize adherence to the project constitution.md

2. **Preserve latest intentional changes** - When artifacts conflict, favor the most recent intentional change over older content

3. **Prioritize goal achievement** - When conflicts exist, choose updates that better support measurable goals

4. **Maintain architectural integrity** - Favor changes that preserve the architectural blueprint integrity

5. **Document assumptions** - Clearly mark any synchronization decisions made based on defaults with [ASSUMPTION: brief explanation] markers

## Error Handling and Validation

1. **Before synchronization**: Verify all required artifacts exist and are accessible
2. **During synchronization**: Validate that updates maintain cross-artifact consistency
3. **After synchronization**: Confirm all artifacts remain properly formatted and aligned
4. **File operations**: Always update the specified artifact files (never create new files) and validate files exist before updating

### Synchronization Requirements

- **Comprehensive Coverage**: Review all artifacts for needed updates
- **Bidirectional Updates**: Propagate changes in both directions as needed
- **Rationale Documentation**: Record reasons for all changes
- **Consistency Validation**: Verify all artifacts remain aligned
- **Constitution Compliance**: Follow project principles during synchronization

### For AI Generation

When performing artifact synchronization:

1. **Systematic Review**: Examine all artifacts for inconsistencies or needed updates
2. **Change Propagation**: Apply necessary updates to maintain consistency
3. **Validation**: Confirm all artifacts remain aligned after updates
4. **Documentation**: Record all changes with rationales
5. **Traceability**: Maintain links between related elements in different artifacts
6. **Principle Adherence**: Ensure updates align with constitution.md principles

**Synchronization Best Practices**:

- Perform synchronization regularly during development, not just at the end
- Address inconsistencies immediately when discovered
- Document the reasoning behind all changes
- Maintain clear links between related elements across documents
- Validate consistency before and after synchronization