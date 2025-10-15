---
description: Create technical implementation plans with your chosen tech stack and architecture.
scripts:
  sh: scripts/bash/setup-plan.sh --json "{ARGS}"
  ps: scripts/powershell/setup-plan.ps1 -Json "{ARGS}"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/blueprintkit.plan` in the triggering message **is** the implementation planning directive. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that implementation planning directive, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for FEATURE_DIR. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.

2. Load `.blueprintkit/memory/constitution.md` to understand project principles.

3. Load `templates/plan-template.md` to understand required sections.

4. Load `specs/[FEATURE_DIR]/spec.md` to understand feature requirements.

5. Load `specs/[FEATURE_DIR]/goals.md` to understand measurable outcomes.

6. Load `specs/[FEATURE_DIR]/blueprint.md` to understand architectural approach.

7. Validate alignment between spec, goals, blueprint, and plan:
   - [ ] Implementation plan aligns with feature specification
   - [ ] Implementation approach supports measurable goals
   - [ ] Tech stack matches architectural blueprint
   - [ ] No contradictions between artifacts

8. Follow this execution flow:

    1. Parse user description from Input
       If empty: ERROR "No implementation planning directive provided"
    2. Extract key technical concepts from description
       Identify: frameworks, languages, libraries, infrastructure
    3. For unclear aspects:
       - Make informed guesses based on context and industry standards
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts implementation approach
         - Multiple reasonable technical approaches exist with different implications
         - No reasonable default exists
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: architecture > performance > maintainability
    4. Map requirements to technical components
       If no clear mapping: ERROR "Cannot map requirements to technical approach"
    5. Create detailed implementation approach
       Each component must align with architectural blueprint
       Use reasonable defaults for unspecified details (document assumptions in Assumptions section)
    6. Define implementation phases
       Create logical, achievable phases that build toward goals
       Each phase must support measurable outcomes from goals
    7. Define testing strategy
       Each test type must validate requirements, goals, or architecture
    8. Return: SUCCESS (plan ready for task breakdown)

9. Write the implementation plan to `specs/[FEATURE_DIR]/plan.md` using the template structure, replacing placeholders with concrete details derived from the implementation planning directive (arguments) while preserving section order and headings.

10. **Plan Quality Validation**: After writing the initial plan, validate it against quality criteria:

   a. **Create Plan Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/plan.md` using the checklist template structure with these validation items:
   
      ```markdown
      # Plan Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate plan completeness and quality before proceeding to tasks
      **Created**: [DATE]
      **Feature**: [Link to plan.md]
      **Related Artifacts**:
      - Specification: [Link to spec.md]
      - Goals: [Link to goals.md]
      - Blueprint: [Link to blueprint.md]
      
      ## Content Quality
      
      - [ ] Plan aligns with feature specification
      - [ ] Implementation approach supports defined goals
      - [ ] Technical decisions match architectural blueprint
      - [ ] Technology choices are justified
      - [ ] All mandatory sections completed
      
      ## Plan Completeness
      
      - [ ] No [NEEDS CLARIFICATION] markers remain
      - [ ] Implementation approach is clearly defined
      - [ ] Phases are well-structured with clear deliverables
      - [ ] File creation order follows best practices
      - [ ] Testing strategy is comprehensive
      - [ ] Deployment considerations are addressed
      - [ ] Success criteria are defined
      - [ ] Risks are identified and mitigated
      
      ## Plan Alignment
      
      - [ ] Plan supports all functional requirements
      - [ ] Plan enables achievement of measurable goals
      - [ ] Plan follows architectural blueprint
      - [ ] All pre-implementation gates are addressed
      
      ## Notes
      
      - Items marked incomplete require plan updates before `/blueprintkit.tasks`
      ```
   
   b. **Run Validation Check**: Review the plan against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant plan sections)
   
   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 11
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the plan to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
      
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the plan
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by implementation/architecture impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:
        
           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant plan section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the implementation] |
           | B      | [Second suggested answer] | [What this means for the implementation] |
           | C      | [Third suggested answer] | [What this means for the implementation] |
           | Custom | Provide your own answer | [Explain how to provide custom input] |
           
           **Your choice**: _[Wait for user response]_
           ```
        
        4. **CRITICAL - Table Formatting**: Ensure markdown tables are properly formatted:
           - Use consistent spacing with pipes aligned
           - Each cell should have spaces around content: `| Content |` not `|Content|`
           - Header separator must have at least 3 dashes: `|--------|`
           - Test that the table renders correctly in markdown preview
        5. Number questions sequentially (Q1, Q2, Q3 - max 3 total)
        6. Present all questions together before waiting for responses
        7. Wait for user to respond with their choices for all questions (e.g., "Q1: A, Q2: Custom - [details], Q3: B")
        8. Update the plan by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved
   
   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

11. Generate supporting implementation documents:
   - Create `specs/[FEATURE_DIR]/contracts/` directory if not exists
   - For each API endpoint identified in plan, create contract in `contracts/` directory
   - Create `specs/[FEATURE_DIR]/data-model.md` with all data models identified in plan
   - Create `specs/[FEATURE_DIR]/research.md` with detailed research for complex technical decisions
   - Create `specs/[FEATURE_DIR]/quickstart.md` with validation scenarios for key functionality

12. Report completion with plan file path, checklist results, and readiness for the next phase (`/blueprintkit.tasks`).

**NOTE:** The script creates the feature directory structure and validates prerequisites before writing the plan.

## General Guidelines

## Quick Guidelines

- Focus on **HOW** to implement while staying aligned with spec, goals, and blueprint.
- Technology choices must support measurable goals from goals.md
- Architecture decisions must match blueprint.md
- Written for developers and technical stakeholders.
- DO NOT create any checklists that are embedded in the plan. That will be a separate command.

### Section Requirements

- **Mandatory sections**: Must be completed for every implementation plan
- **Optional sections**: Include only when relevant to the implementation approach
- When a section doesn't apply, remove it entirely (don't leave as "N/A")

### For AI Generation

When creating this plan from a user prompt:

1. **Validate alignment**: Ensure all technical decisions align with spec, goals, and blueprint
2. **Make informed guesses**: Use context, industry standards, and best practices to fill gaps
3. **Document assumptions**: Record reasonable defaults in the Assumptions section
4. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact implementation approach or success
   - Have multiple reasonable technical approaches with different implications
   - Lack any reasonable default
5. **Prioritize clarifications**: architecture alignment > implementation approach > technical details
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Technology stack choices (when multiple valid options exist)
   - Architecture implementation details (when blueprint is high-level)
   - Performance requirements (when specific targets needed)

**Examples of reasonable defaults** (don't ask about these):

- Database connection pooling: Standard configuration for the chosen platform
- API rate limiting: Industry standard values (e.g., 1000 requests/hour per client)
- Logging levels: Appropriate for the application type
- Error handling patterns: Standard approaches for the platform/technology
- Security headers: Standard security configuration for the platform

### Implementation Planning Guidelines

Implementation plans must include:

1. **Clear Architecture Alignment**: How the implementation matches the architectural blueprint
2. **Technology Justification**: Reason for choosing specific technologies
3. **Phase Structure**: Logical progression of implementation phases
4. **Testing Strategy**: How requirements, goals, and architecture will be validated
5. **Risk Management**: How implementation risks will be mitigated
6. **Success Criteria**: How to validate plan completion