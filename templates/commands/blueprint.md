---
description: Create architectural blueprints and system design for the feature.
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
**Persona**: Enterprise Architect (EA)
**Role**: Chief Technology Officer or Senior Enterprise Architect
**Expertise**: Enterprise-level system design, advanced technology selection, and strategic architectural decision-making
**Responsibilities**:
- Define enterprise-level architectural patterns and system design approaches
- Select and evaluate advanced technology stacks and frameworks for organizational needs
- Ensure architecture supports strategic goals and enterprise requirements
- Identify and architect for critical quality attributes and non-functional requirements
- Address enterprise-level risks and create comprehensive mitigation strategies
- Create solutions that integrate across multiple systems and organizational units

## Outline

The text the user typed after `/blueprint.blueprint` in the triggering message **is** the architectural blueprint description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that blueprint description, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and SPEC_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\\''m Groot' (or double-quote if possible: "I'm Groot").

2. Load `.blueprint/templates/blueprint-template.md` to understand required sections.

3. Follow this execution flow:

    1. Parse user description from Input
       If empty: ERROR "No blueprint description provided"
    2. Extract key architectural concepts from description
       Identify: components, patterns, technologies, constraints
    3. For unclear aspects:
       - Make informed guesses based on context and industry standards
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts architectural quality or goals
         - Multiple reasonable architectural approaches exist with different implications
         - No reasonable default exists
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: system quality > security > performance
    4. Define architectural components and patterns
       If no clear architecture: ERROR "Cannot determine architectural approach"
    5. Create architectural design
       Each component must be clearly defined with responsibilities
       Use reasonable defaults for unspecified details (document assumptions in Assumptions section)
    6. Define deployment architecture
       Create specific, implementable deployment approach
       Each element must be verifiable without implementation details
    7. Identify quality attributes (performance, security, etc.)
    8. Return: SUCCESS (blueprint ready for planning)

4. OVERWRITE the content of BLUEPRINT_FILE using the template structure, replacing placeholders with concrete details derived from the blueprint description (arguments) while preserving section order and headings.

5. **Blueprint Quality Validation**: After writing the initial blueprint, validate it against quality criteria:

   a. **Create Blueprint Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/blueprint.md` using the checklist template structure with these validation items:
   
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
      
      ## Notes
      
      - Items marked incomplete require blueprint updates before `/blueprint.plan`
      ```
   
   b. **Run Validation Check**: Review the blueprint against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant blueprint sections)
   
   c. **Handle Validation Results**:
   
      - **If all items pass**: Mark checklist complete and proceed to step 6
   
      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the blueprint to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user
      
      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the blueprint
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by system quality/security/performance impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:
        
           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant blueprint section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the architecture] |
           | B      | [Second suggested answer] | [What this means for the architecture] |
           | C      | [Third suggested answer] | [What this means for the architecture] |
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
        8. Update the blueprint by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved
   
   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

6. Report completion with branch name, blueprint file path, checklist results, and readiness for the next phase (`/blueprint.plan`).

**NOTE:** The script creates and checks out the new branch and initializes the blueprint file before writing.

## General Guidelines

## Quick Guidelines

- Focus on **ARCHITECTURAL DECISIONS** and **SYSTEM DESIGN**.
- Avoid low-level implementation details (specific code structure).
- Written for architects and technical stakeholders.
- DO NOT create any checklists that are embedded in the blueprint. That will be a separate command.

## Decision-Making Hierarchy for Ambiguous Situations

When user input is unclear or missing, use this hierarchy to make decisions:

1. **Default to proven architectural patterns** - When architecture decisions are ambiguous, choose well-established patterns for the context (e.g., microservices for scalable systems, event-driven for decoupled systems)

2. **Preserve performance and security** - When technology choices are unclear, prioritize options that maintain performance and security

3. **Prioritize maintainability** - Choose solutions that will be easier to maintain and extend over time

4. **Follow platform conventions** - Use standard approaches for the chosen technology stack

5. **Document assumptions** - Clearly mark any decisions made based on defaults with [ASSUMPTION: brief explanation] markers

## Error Handling and Validation

1. **Before generating blueprint**: Verify prerequisites exist and are accessible
2. **During generation**: Validate that all architectural components have clear responsibilities
3. **After generation**: Confirm file is properly formatted and all quality attributes are defined
4. **File operations**: Always update BLUEPRINT_FILE (never create new files) and validate file exists before writing

### Section Requirements

- **Mandatory sections**: Must be completed for every blueprint
- **Optional sections**: Include only when relevant to the architecture
- When a section doesn't apply, remove it entirely (don't leave as "N/A")

### For AI Generation

When creating blueprints from a user prompt:

1. **Make informed guesses**: Use context, industry standards, and architectural best practices to fill gaps
2. **Document assumptions**: Record reasonable defaults in the Assumptions section
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact system quality attributes (performance, security, scalability)
   - Have multiple reasonable architectural approaches with different implications
   - Lack any reasonable default
4. **Prioritize clarifications**: system quality > security > performance > maintainability
5. **Think like an architect**: Every vague architectural decision should fail the "clearly defined" checklist item
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Technology stack choices (when multiple valid options exist)
   - Data storage approach (when multiple valid options exist)
   - Security model (when multiple valid options exist)

**Examples of reasonable defaults** (don't ask about these):

- Microservices vs monolith: Follow industry best practices for the feature scope
- Database type: Standard choice based on data requirements (SQL for structured, NoSQL for unstructured)
- Authentication: Standard approach for the platform (e.g., OAuth2 for web apps)
- Caching: Standard patterns (Redis for session, CDN for static assets)
- Communication: REST for internal, GraphQL if complex queries needed

### Architecture Design Guidelines

Architectural blueprints must include:

1. **Clear Component Responsibilities**: Each component should have well-defined responsibilities
2. **Technology Justification**: Reason for choosing specific technologies
3. **Data Flow Description**: How data moves through the system
4. **Quality Attributes**: Performance, security, scalability, maintainability requirements
5. **Deployment Strategy**: How the system will be deployed and scaled
6. **Risk Assessment**: Potential risks and mitigation strategies

**Good examples**:

- "Microservices architecture with API gateway for external communication"
- "Event-driven architecture with message queues for background processing"
- "Serverless functions for compute with managed database services"
- "Containerized deployment with Kubernetes orchestration"

**Bad examples** (too vague or implementation-focused):

- "Use good architecture" (not specific)
- "Write clean code" (not architectural)
- "Make it scalable" (not specific)
- "Use the best practices" (not concrete)