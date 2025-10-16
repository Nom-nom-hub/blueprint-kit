# Artifact Synchronization Guide

## Purpose
This guide ensures that all project artifacts remain consistent and up-to-date throughout the development lifecycle. It provides a framework for maintaining synchronization between specifications, goals, blueprints, plans, and tasks.

## Synchronization Principles

### 1. Bidirectional Updates
- When changes occur in one artifact, related artifacts must be reviewed and updated as needed
- Information flows both from high-level documents (spec, goals) to lower-level ones (tasks, code) and vice versa
- Implementation discoveries must be reflected back in planning documents

### 2. Consistency Validation
- All artifacts must maintain logical consistency with each other
- Contradictions between documents should be identified and resolved immediately
- Regular cross-validation should be performed during development

### 3. Change Propagation
- Document the rationale for any changes that affect multiple artifacts
- Ensure stakeholders are aware of important updates to related documents
- Maintain traceability between related elements across artifacts

## Synchronization Process

### During Implementation
1. **Monitor for changes**: As implementation proceeds, watch for discoveries that may require updates to other artifacts
2. **Validate consistency**: Regularly check that implementation aligns with all related artifacts
3. **Update as needed**: Make necessary updates to related artifacts when implementation reveals issues or changes
4. **Document changes**: Record the reasons for any updates to maintain traceability

### Change Detection Triggers
You should consider updating related artifacts when you encounter:
- Implementation challenges that reveal specification gaps
- Architectural decisions that affect requirements or goals
- Performance or scalability issues that require goal adjustments
- New requirements discovered during development
- Technical constraints that affect the original plan
- Success criteria that need refinement based on implementation reality

### Update Workflow
1. **Identify impacted artifacts**: Determine which documents need updates based on the change
2. **Make primary update**: Update the artifact that initially required change
3. **Review related artifacts**: Examine related documents for consistency
4. **Update related artifacts**: Make necessary adjustments to maintain consistency
5. **Validate alignment**: Ensure all artifacts still work together properly
6. **Document changes**: Record the changes and rationale in all affected documents

## Specific Synchronization Patterns

### Spec ↔ Goals
- When requirements in the spec change, review whether goals still align
- When measurable outcomes in goals change, verify they still support spec requirements
- Update both if new user scenarios or acceptance criteria emerge

### Spec ↔ Blueprint
- When architectural constraints are identified, check if they affect spec requirements
- When requirements change, verify the architecture still supports them
- Update both if technical feasibility affects user scenarios

### Goals ↔ Blueprint
- When architectural decisions affect measurability of goals, update accordingly
- When goals change, verify the architecture still enables achievement
- Ensure quality attributes support measurable outcomes

### Plan ↔ All Other Artifacts
- Implementation plans should always reflect current state of spec, goals, and blueprint
- Updates to any other artifact likely require plan updates
- Task breakdown should always align with current implementation approach

## Validation Checklist
Before marking any implementation task as complete, verify:
- [ ] The implemented code aligns with the specification
- [ ] The implemented code moves toward stated goals
- [ ] The implementation follows the architectural blueprint
- [ ] The plan remains accurate and up-to-date
- [ ] The tasks document reflects any changes to the approach
- [ ] All artifacts remain consistent with each other
- [ ] Any changes have been documented with rationale
- [ ] Cross-artifact dependencies are still valid

## Tools and Commands
- Use `/blueprint.analyze` regularly to check for consistency between artifacts
- Review all related artifacts before making significant changes
- Keep all documents open during implementation to reference and update as needed

## Best Practices
- Update related artifacts immediately when changes occur, rather than batching updates
- Use consistent terminology across all artifacts
- Document decision rationales in all affected documents
- Review changes with stakeholders when they affect goals or requirements
- Maintain traceability links between related elements in different artifacts