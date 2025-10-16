---
description: Generate custom quality checklists to validate requirements completeness, clarity, and consistency.
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

The text the user typed after `/blueprint.checklist` in the triggering message **is** the checklist generation directive. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that checklist generation directive, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for FEATURE_DIR. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.

2. Load `.blueprint/memory/constitution.md` to understand project principles.

3. Load `.blueprint/specs/[FEATURE_DIR]/spec.md` to understand feature requirements.

4. Load `.blueprint/specs/[FEATURE_DIR]/goals.md` to understand measurable outcomes.

5. Load `.blueprint/specs/[FEATURE_DIR]/blueprint.md` to understand architectural approach.

6. Load `.blueprint/specs/[FEATURE_DIR]/plan.md` to understand implementation details.

7. If any required file is missing, ERROR with specific file name that's missing.

8. Follow this execution flow:

    1. Parse user description from Input
       If empty: Use default checklist approach
    2. Analyze requirements in spec.md for completeness and clarity
    3. Analyze goals in goals.md for measurability and achievability
    4. Analyze architecture in blueprint.md for soundness and feasibility
    5. Analyze implementation plan in plan.md for feasibility and completeness
    6. Generate quality checklists based on analysis
    7. Apply constitution.md principles as quality criteria
    8. Return: SUCCESS (checklists generated)

9. Generate quality checklists for each artifact:

   a. **Specification Quality Checklist** (`.blueprint/specs/[FEATURE_DIR]/checklists/spec.md`):
   
      ```markdown
      # Specification Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate specification completeness and quality before proceeding to planning
      **Created**: [DATE]
      **Feature**: [Link to spec.md]
      
      ## Content Quality
      
      - [ ] No implementation details (languages, frameworks, APIs)
      - [ ] Focused on user value and business needs
      - [ ] Written for non-technical stakeholders
      - [ ] All mandatory sections completed
      
      ## Requirement Completeness
      
      - [ ] No [NEEDS CLARIFICATION] markers remain
      - [ ] Requirements are testable and unambiguous
      - [ ] Success criteria are measurable
      - [ ] Success criteria are technology-agnostic (no implementation details)
      - [ ] All acceptance scenarios are defined
      - [ ] Edge cases are identified
      - [ ] Scope is clearly bounded
      - [ ] Dependencies and assumptions identified
      
      ## Feature Readiness
      
      - [ ] All functional requirements have clear acceptance criteria
      - [ ] User scenarios cover primary flows
      - [ ] Feature meets measurable outcomes defined in Success Criteria
      - [ ] No implementation details leak into specification
      
      ## Constitution Alignment
      
      - [ ] Specification follows intent-driven development principle
      - [ ] Requirements support test-first imperative
      - [ ] Specification enables blueprint integration
      - [ ] Approach aligns with simplicity and minimalism
      
      ## Notes
      
      - Items marked incomplete require spec updates before `/blueprint.plan`
      ```
   
   b. **Goals Quality Checklist** (`.blueprint/specs/[FEATURE_DIR]/checklists/goals.md`):
   
      ```markdown
      # Goals Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate goal completeness and quality before proceeding to blueprint
      **Created**: [DATE]
      **Feature**: [Link to goals.md]
      
      ## Content Quality
      
      - [ ] Goals are specific and clearly defined
      - [ ] All goals are measurable with specific metrics
      - [ ] Goals are achievable and realistic
      - [ ] Goals are time-bound with clear timelines
      - [ ] All mandatory sections completed
      
      ## Goal Completeness
      
      - [ ] No [NEEDS CLARIFICATION] markers remain
      - [ ] Success criteria are specific and measurable
      - [ ] Success metrics are defined and quantifiable
      - [ ] Stakeholders are identified
      - [ ] Timeline is realistic and clear
      - [ ] Constraints and assumptions are documented
      
      ## Goal Alignment
      
      - [ ] Goals align with feature specifications
      - [ ] Goals support business objectives
      - [ ] Goals are consistent with architectural approach
      - [ ] Measurement approach is clearly defined
      
      ## Constitution Alignment
      
      - [ ] Goals support intent-driven development principle
      - [ ] Goals enable test-first validation
      - [ ] Goals align with blueprint integration approach
      - [ ] Goals follow simplicity and minimalism principles
      
      ## Notes
      
      - Items marked incomplete require goal updates before `/blueprint.blueprint`
      ```
   
   c. **Blueprint Quality Checklist** (`.blueprint/specs/[FEATURE_DIR]/checklists/blueprint.md`):
   
      ```markdown
      # Blueprint Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate blueprint completeness and quality before proceeding to planning
      **Created**: [DATE]
      **Feature**: [Link to blueprint.md]
      
      ## Content Quality
      
      - [ ] Architecture addresses the feature specifications
      - [ ] Technology choices are appropriate for the requirements
      - [ ] Data flow is clearly defined
      - [ ] Security considerations are addressed
      - [ ] All mandatory sections completed
      
      ## Blueprint Completeness
      
      - [ ] No [NEEDS CLARIFICATION] markers remain
      - [ ] Core components are defined with clear responsibilities
      - [ ] Architecture pattern is appropriate and documented
      - [ ] Data flow is clearly described
      - [ ] API design is specified
      - [ ] External dependencies are identified
      - [ ] Deployment approach is feasible
      - [ ] Quality attributes are defined
      - [ ] Risks are identified and mitigated
      
      ## Blueprint Alignment
      
      - [ ] Blueprint aligns with feature specifications
      - [ ] Blueprint supports defined goals and success metrics
      - [ ] Blueprint is consistent with project constitution
      - [ ] Architectural decisions are justified
      
      ## Constitution Alignment
      
      - [ ] Architecture follows library-first principle
      - [ ] Design includes CLI interface mandate
      - [ ] Approach supports test-first imperative
      - [ ] Architecture embodies simplicity and minimalism
      - [ ] Design follows anti-abstraction principle
      - [ ] Architecture supports integration-first testing
      
      ## Notes
      
      - Items marked incomplete require blueprint updates before `/blueprint.plan`
      ```
   
   d. **Plan Quality Checklist** (`.blueprint/specs/[FEATURE_DIR]/checklists/plan.md`):
   
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
      
      ## Constitution Alignment
      
      - [ ] Plan follows library-first principle
      - [ ] Implementation includes CLI interface mandate
      - [ ] Approach follows test-first imperative
      - [ ] Plan embodies simplicity and minimalism
      - [ ] Design follows anti-abstraction principle
      - [ ] Plan supports integration-first testing
      
      ## Notes
      
      - Items marked incomplete require plan updates before `/blueprint.tasks`
      ```
   
   e. **Overall Integration Checklist** (`.blueprint/specs/[FEATURE_DIR]/checklists/integration.md`):
   
      ```markdown
      # Cross-Artifact Integration Checklist: [FEATURE NAME]
      
      **Purpose**: Validate consistency and alignment across all artifacts
      **Created**: [DATE]
      **Feature**: [FEATURE_DIR]
      **Related Artifacts**:
      - Specification: [Link to spec.md]
      - Goals: [Link to goals.md]
      - Blueprint: [Link to blueprint.md]
      - Plan: [Link to plan.md]
      
      ## Cross-Artifact Consistency
      
      - [ ] All artifacts consistently describe the feature scope
      - [ ] Requirements in spec align with goals
      - [ ] Architectural blueprint supports all requirements
      - [ ] Implementation plan follows architectural blueprint
      - [ ] All artifacts use consistent terminology
      - [ ] No contradictions exist between artifacts
      
      ## Completeness Check
      
      - [ ] All functional requirements have architectural components
      - [ ] All architectural components have implementation tasks (will be verified with tasks.md)
      - [ ] All goals have supporting requirements in spec
      - [ ] All measurable outcomes are achievable with proposed architecture
      - [ ] Implementation approach can achieve stated goals
      
      ## Quality Validation
      
      - [ ] All artifacts meet individual quality standards (see individual checklists)
      - [ ] Cross-artifact alignment has been verified
      - [ ] No gaps exist between specification, goals, blueprint, and plan
      - [ ] Implementation path from spec to code is clear
      
      ## Constitution Compliance
      
      - [ ] All artifacts follow project principles
      - [ ] Intent-driven development is maintained across artifacts
      - [ ] Blueprint integration approach is consistent
      - [ ] Cross-artifact consistency principle is upheld
      
      ## Readiness for Task Generation
      
      - [ ] Specification is approved and complete
      - [ ] Goals are approved and measurable
      - [ ] Blueprint is approved and detailed
      - [ ] Plan is approved and actionable
      - [ ] All cross-artifact issues are resolved
      
      ## Notes
      
      - Items marked incomplete require updates before `/blueprint.tasks`
      ```

10. Apply constitution.md principles as quality criteria across all checklists:

   - Library-First Principle: Verify components are designed as reusable libraries
   - CLI Interface Mandate: Ensure all functionality has text-based interfaces
   - Test-First Imperative: Confirm testing is planned before implementation
   - Intent-Driven Development: Validate all artifacts serve clear intentions
   - Blueprint Integration: Ensure architectural alignment across artifacts
   - Cross-Artifact Consistency: Verify alignment between all artifacts
   - Simplicity and Minimalism: Confirm approaches are appropriately simple
   - Anti-Abstraction Principle: Verify unnecessary abstractions are avoided
   - Integration-First Testing: Ensure real-world testing is prioritized

11. CREATE OR OVERWRITE all checklists in the `.blueprint/specs/[FEATURE_DIR]/checklists/` directory.

12. Report completion with:
   - Paths to all generated checklists
   - Summary of quality criteria applied
   - Readiness assessment for next phase

**NOTE:** The script generates comprehensive checklists that apply both general quality standards and constitution-specific principles to ensure high-quality artifacts.

## General Guidelines

## Quick Guidelines

- Generate **COMPREHENSIVE QUALITY CHECKLISTS** for each artifact.
- Apply **CONSTITUTION PRINCIPLES** as quality criteria.
- Focus on **CROSS-ARTIFACT CONSISTENCY**.
- Include **MEASURABLE QUALITY STANDARDS**.
- Written for quality assurance and validation purposes.
- Enable **SYSTEMATIC VALIDATION** before proceeding to next phases.

## Decision-Making Hierarchy for Ambiguous Situations

When quality criteria are unclear, use this hierarchy to make decisions:

1. **Default to constitution principles** - When quality standards are ambiguous, prioritize adherence to the project constitution.md principles

2. **Preserve requirement satisfaction** - When checklist items are unclear, focus on ensuring requirements can be met

3. **Prioritize critical validation** - Include checks for items that would block successful implementation or achievement of goals

4. **Follow industry standards** - When specific quality measures are ambiguous, apply common industry quality standards

5. **Document assumptions** - Clearly mark any assessment criteria made based on defaults with [ASSUMPTION: brief explanation] markers

## Error Handling and Validation

1. **Before generating checklists**: Verify all required artifacts exist and are accessible
2. **During generation**: Validate that checklist items are specific and measurable
3. **After generation**: Confirm all checklists are properly formatted and actionable
4. **File operations**: Always create or overwrite checklist files at specified paths (never create in alternative locations) and validate files exist after creation

### Checklist Requirements

- **Artifact-Specific Checklists**: Generate checklists tailored to each artifact type
- **Constitution Alignment**: Apply constitution principles as quality criteria
- **Cross-Artifact Consistency**: Verify alignment between all artifacts
- **Measurable Standards**: Include specific, verifiable quality criteria
- **Actionable Items**: Ensure each checklist item can be objectively evaluated

### For AI Generation

When generating quality checklists:

1. **Template-Based**: Use the provided templates as starting points
2. **Constitution Integration**: Include constitution principles as quality criteria
3. **Artifact-Specific**: Tailor checklists to the unique aspects of each artifact
4. **Verifiable**: Ensure each checklist item can be objectively verified
5. **Prioritized**: Order checklist items by importance and risk
6. **Comprehensive**: Cover all major quality aspects of each artifact
7. **Actionable**: Include notes sections for corrective actions

**Checklist Generation Best Practices**:

- Include constitution principles in all checklists
- Focus on measurable, objective criteria
- Ensure cross-artifact consistency requirements
- Prioritize high-risk quality issues
- Provide clear guidance for each checklist item
- Include notes sections for tracking resolution of issues