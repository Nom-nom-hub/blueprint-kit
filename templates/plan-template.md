# Implementation Plan for [FEATURE NAME]

## Feature: [FEATURE NAME]
**Spec**: [Link to feature spec file]

## Phase -1: Pre-Implementation Gates
#### Simplicity Gate (Article VII)
- [ ] Using ≤3 projects?
- [ ] No future-proofing?

#### Anti-Abstraction Gate (Article VIII)
- [ ] Using framework directly?
- [ ] Single model representation?

#### Integration-First Gate (Article IX)
- [ ] Contracts defined?
- [ ] Contract tests written?

### Gate Status
- [ ] All gates passed OR complexity documented in "Complexity Tracking" below

### Complexity Tracking (if any gates failed)
- [If any gates failed, document the justification for added complexity here]

---

## Implementation Approach
**Primary Architecture**: [Architecture pattern to be implemented]

**Tech Stack**: [Specific technologies to be used]

**Key Patterns**: [Important design patterns to implement]

## Implementation Phases
### Phase 1: [Phase Name]
**Scope**: [What will be accomplished in this phase]
**Deliverables**:
- [Deliverable 1]
- [Deliverable 2]

### Phase 2: [Phase Name]
**Scope**: [What will be accomplished in this phase]
**Deliverables**:
- [Deliverable 1]
- [Deliverable 2]

### Phase 3: [Phase Name]
**Scope**: [What will be accomplished in this phase]
**Deliverables**:
- [Deliverable 1]
- [Deliverable 2]

## File Creation Order
1. Create `contracts/` with API specifications
2. Create test files in order: contract → integration → e2e → unit
3. Create source files to make tests pass

## Core Implementation
### [Component/Module 1]
- [Description of what needs to be implemented]
- [Files to create/update]
- [Key considerations]

### [Component/Module 2]
- [Description of what needs to be implemented]
- [Files to create/update]
- [Key considerations]

### [Component/Module 3]
- [Description of what needs to be implemented]
- [Files to create/update]
- [Key considerations]

## Testing Strategy
### Test Coverage
- [What needs to be tested at each level]
- [Test data requirements]

### Test Scenarios
- [Specific test cases that need to be implemented]
- [Edge cases that need to be covered]

## Deployment Considerations
- [Any deployment-specific requirements]
- [Configuration needs]
- [Environment requirements]

## Success Criteria
- [How will we know the implementation is successful?]
- [Metrics to validate completion]

## Risks & Mitigations
- [Potential risks during implementation]
- [How they will be mitigated]

## Assumptions
- [Any assumptions made about external dependencies or environment]

## Artifact Synchronization
### When to Update Related Artifacts
- [ ] Update `spec.md` if implementation reveals specification gaps or needed changes
- [ ] Update `goals.md` if measurable outcomes need adjustment based on implementation realities
- [ ] Update `blueprint.md` if architectural decisions change during implementation
- [ ] Update `tasks.md` if new tasks emerge or existing tasks need modification

### Implementation Feedback Loop
- [How will implementation discoveries be fed back into other artifacts?]
- [Process for maintaining cross-artifact consistency during implementation]

## Implementation Details
**IMPORTANT**: This implementation plan should remain high-level and readable.
Any code samples, detailed algorithms, or extensive technical specifications
must be placed in the appropriate `implementation-details/` file.

---

## Review Checklist
- [ ] Implementation approach aligns with architectural blueprint
- [ ] Phases are well-defined with clear deliverables
- [ ] File creation order follows best practices
- [ ] Testing strategy is comprehensive
- [ ] Deployment considerations are addressed
- [ ] Success criteria are defined
- [ ] Risks are identified and mitigated
- [ ] All pre-implementation gates are addressed