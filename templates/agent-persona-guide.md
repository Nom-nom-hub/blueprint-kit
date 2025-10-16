# Agent Guide: Matching Advanced Company Personas to Tasks

## Purpose
This guide provides agents with the knowledge needed to properly match advanced company personas to implementation tasks based on skill requirements, organizational roles, and project context. Each persona represents an expert in their field with deep technical or organizational knowledge.

## Core Principles

### 1. Expert-Level Matching
- Match tasks to personas based on their advanced skills and specialized expertise
- Consider the complexity and strategic importance of the task
- Factor in the persona's depth of expertise and organizational authority
- Ensure the assigned persona can handle enterprise-level challenges

### 2. Context-Aware Assignment
- Take into account the architectural blueprint when assigning tasks
- Consider dependencies between tasks and their impact on persona assignments
- Account for cross-functional requirements that might affect assignments
- Respect organizational hierarchy for decision-making
- Ensure the task complexity matches the expertise level of the assigned persona

### 3. Workload Balancing
- Distribute tasks appropriately across available expert personas
- Avoid overloading specialized roles (e.g., security specialists, executives)
- Consider the availability and capacity of each expert persona
- Balance technical tasks with management and strategic responsibilities
- Prioritize critical tasks for the most qualified experts

## Step-by-Step Persona Assignment Process

### Step 1: Analyze Task Complexity & Requirements
1. Examine the specific task description and requirements
2. Identify required technologies, frameworks, or tools
3. Determine the domain knowledge needed (technical, business, design, etc.)
4. Assess enterprise-level complexity and strategic risk factors
5. Evaluate if the task requires strategic decision-making or just implementation
6. Determine the level of expertise required for successful completion

### Step 2: Map to Advanced Persona Capabilities
1. Refer to `.blueprint/templates/personas.md` for detailed advanced persona capabilities
2. Consult `.blueprint/templates/task-persona-mapping.md` for guidelines
3. Match task requirements to persona specializations and organizational roles
4. Consider the advanced expertise level required for the task
5. Consider secondary advanced skills when appropriate

### Step 3: Validate Assignment
1. Ensure the assigned persona has the required advanced skills and authority
2. Check that the task complexity aligns with the persona's expert-level experience
3. Consider if any additional expert resources or collaboration might be needed
4. Verify the assignment aligns with project architecture and organizational structure
5. Ensure the assignment follows the proper decision-making hierarchy
6. Confirm the persona can handle enterprise-level challenges for this task

## Common Assignment Scenarios

### Strategic & Architecture Tasks
**Assigned to**: Chief Technology Officer (CTO), Engineering Manager (EM)
- Define long-term technology strategy aligned with business objectives
- Evaluate and approve complex architectural decisions
- Drive technical innovation and emerging technology adoption
- Assess and mitigate enterprise-level technical risks
- Establish enterprise technical standards and frameworks

### Advanced Project Management Tasks
**Assigned to**: Engineering Manager (EM), Project Manager (PJ)
- Lead complex programs and portfolios of projects
- Manage strategic stakeholder relationships and executive engagement
- Develop and execute advanced risk management strategies
- Drive organizational change and process improvement
- Plan strategic team development and career advancement

### Advanced Product Management Tasks
**Assigned to**: Product Manager (PM)
- Define and execute advanced product strategy and roadmap
- Analyze market data and competitive landscape to inform product decisions
- Drive strategic stakeholder alignment and executive buy-in
- Establish key product metrics and success indicators
- Coordinate complex product initiatives across multiple teams

### Advanced UX Design Tasks
**Assigned to**: UX Designer (UX), Product Manager (PM)
- Conduct advanced user research and behavioral analysis
- Design complex system architectures and interaction patterns
- Create advanced prototypes and conduct usability testing
- Develop comprehensive user journey maps and experience strategies
- Establish design principles and interaction guidelines

### Advanced UI Design Tasks
**Assigned to**: UI Designer (UI), UX Designer (UX)
- Create advanced visual design systems and brand implementations
- Develop and maintain comprehensive design systems
- Establish and maintain visual design standards and guidelines
- Create advanced interactive prototypes and animations
- Ensure accessibility and inclusive design compliance

### Advanced Backend Development Tasks
**Assigned to**: Backend Developer (BE) or Full-Stack Developer (FS)
- Design and implement advanced server architectures and distributed systems
- Create optimized database schemas and complex data models
- Architect scalable API systems and microservices
- Implement advanced authentication and authorization systems
- Implement complex business logic and algorithms

### Advanced Frontend Development Tasks
**Assigned to**: Frontend Developer (FE) or Full-Stack Developer (FS)
- Architect and implement complex frontend systems and state management
- Optimize performance and user experience across all devices
- Implement advanced UI components and design systems
- Handle complex client-side business logic and data flows
- Ensure accessibility and security compliance

### Infrastructure & Operations Tasks
**Assigned to**: DevOps Engineer (DO), Engineering Manager (EM)
- Design and implement enterprise-scale cloud infrastructure
- Create advanced CI/CD pipelines and deployment automation
- Implement comprehensive monitoring and observability systems
- Establish security and compliance frameworks
- Optimize performance and capacity planning

### Advanced Security Tasks
**Assigned to**: Security Specialist (SEC) or Backend Developer (BE)
- Design and implement enterprise security architectures
- Conduct advanced vulnerability assessments and penetration testing
- Implement comprehensive authentication and authorization systems
- Design and implement advanced data protection and encryption
- Ensure compliance with security standards and regulations

### Advanced Quality Assurance Tasks
**Assigned to**: QA Engineer (QA) or Full-Stack Developer (FS)
- Design and implement comprehensive test strategies
- Create advanced automated test frameworks and suites
- Perform complex performance and load testing
- Analyze and report on quality metrics and trends
- Manage complex test environments and data

### Advanced Documentation Tasks
**Assigned to**: Technical Writer (TW), Full-Stack Developer (FS), UX Designer (UX)
- Design and implement comprehensive documentation strategies
- Architect complex documentation systems and information flows
- Create advanced API and developer documentation
- Manage knowledge management and content systems
- Ensure content accessibility and localization

### Advanced Business Analysis Tasks
**Assigned to**: Business Analyst (BA), Product Manager (PM)
- Conduct advanced business analysis and requirements engineering
- Design complex process models and optimization strategies
- Validate business solutions against strategic objectives
- Create and maintain business intelligence and reporting
- Manage stakeholder relationships and change initiatives

## Special Considerations

### Cross-Functional Tasks
For tasks that span multiple domains:
1. Identify the primary organizational role needed based on task complexity
2. Assign to the most relevant senior persona
3. Plan for collaboration with other specialists as needed
4. Consider forming cross-functional teams for complex enterprise tasks

### Strategic Decision Tasks
For tasks requiring strategic decisions:
1. Identify if the task involves organizational strategy
2. Assign to the appropriate management-level persona
3. Consider if executive approval is needed (CTO, etc.)
4. Plan for appropriate stakeholder engagement

### Enterprise-Level Complex Tasks
For enterprise-level complex or high-risk tasks:
1. Assign to advanced specialists with appropriate expertise
2. Plan for additional validation and review steps
3. Factor in extra time for these advanced tasks in scheduling
4. Pair with other expert team members when needed

### Emerging Technologies & Innovation
When tasks involve emerging technologies or innovation:
1. Assign to the persona with advanced knowledge in relevant areas
2. Allow time for research and experimentation
3. Plan for knowledge transfer to other team members
4. Consider external expertise or partnerships if needed

## Decision-Making Hierarchy
For tasks involving strategic decisions, follow this hierarchy:
- Individual contributor implementation → Developers
- Technical architecture decisions → Senior Developers, Architects
- Cross-team technical decisions → Engineering Manager, DevOps
- Strategic technical decisions → CTO, Engineering Manager
- Business and product decisions → Product Manager, Business Analyst
- Enterprise-level decisions → CTO, Engineering Manager, Project Manager
- Organizational strategy → CTO, Engineering Manager

## Validation Checklist
Before finalizing persona assignments, ensure:
- [ ] The assigned persona has the required advanced skills and authority
- [ ] The task complexity matches the persona's expert-level experience
- [ ] The assignment aligns with the project architecture
- [ ] Dependencies are considered in the assignment
- [ ] Workload is balanced across the expert team
- [ ] Specialized tasks go to appropriate advanced specialists
- [ ] Strategic tasks go to appropriate management personas
- [ ] Cross-functional requirements are addressed by senior experts
- [ ] The assignment supports project timeline requirements
- [ ] Proper organizational hierarchy is followed
- [ ] The persona can handle enterprise-level challenges for this task

## Examples of Proper Matching

### Example 1: Creating a Scalable Authentication System
- Task: Design and implement enterprise-level authentication with complex authorization
- Required skills: Advanced backend development, security architecture, distributed systems
- Best match: Backend Developer (BE) with input from Security Specialist (SEC)
- Note: Requires expert-level knowledge, not basic implementation

### Example 2: Designing Enterprise UI Architecture
- Task: Create comprehensive design system for enterprise application
- Required skills: Advanced visual design, brand strategy, system architecture
- Best match: UI Designer (UI) with collaboration from UX Designer (UX)
- Note: Requires advanced design system knowledge, not basic UI implementation

### Example 3: Defining Enterprise Technology Strategy
- Task: Determine long-term technology strategy for the organization
- Required skills: Advanced technology strategy, market analysis, business alignment
- Best match: Chief Technology Officer (CTO) with input from Engineering Manager (EM)
- Note: This requires executive-level expertise and authority

### Example 4: Creating Advanced Data Pipeline Architecture
- Task: Design and implement real-time data processing for enterprise analytics
- Required skills: Advanced data architecture, big data platforms, streaming systems
- Best match: Data Engineer (DE) with collaboration from Backend Developer (BE)
- Note: Requires expert-level knowledge in data systems, not basic database operations

## References
- `.blueprint/templates/personas.md` - Detailed advanced persona definitions
- `.blueprint/templates/task-persona-mapping.md` - Task-to-advanced-persona mapping guidelines
- `.blueprint/specsprint/specs/[FEATURE_DIR]/blueprint.md` - Architecture requirements that may affect assignments
- `.blueprint/specsprint/specs/[FEATURE_DIR]/plan.md` - Implementation approach details