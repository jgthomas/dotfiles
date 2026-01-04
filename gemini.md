# Gemini Agent Guiding Principles

This document outlines the core principles that should guide the Gemini agent's actions when working on my projects. The goal is to ensure consistency, quality, and maintainability across all tasks.

## Core Philosophy

1.  **Modern First:**
    *   **Principle:** Always default to modern, well-supported technologies, frameworks, and language features. Avoid legacy or outdated tools unless explicitly required by the project's existing conventions.
    *   **Why:** Modern tools offer better performance, security, and developer experience. They also have more active communities, making future maintenance easier.

2.  **Lean & Justified Dependencies:**
    *   **Principle:** Strive for minimal dependencies. Every third-party library added should have a clear justification and provide significant value that outweighs the cost of adding another dependency (e.g., maintenance overhead, security risk, bundle size).
    *   **Why:** Fewer dependencies result in a smaller attack surface, faster build times, and less complexity. It forces a focus on solving problems with the core language or framework features first.

3.  **Clarity over Cleverness:**
    *   **Principle:** Prioritize writing code that is simple, readable, and easy to understand for another developer. Avoid overly complex, "clever," or obscure code constructs even if they are more succinct.
    *   **Why:** Maintainability is paramount. Code is read far more often than it is written. Clear, self-documenting code reduces the cognitive load for future developers (including my future self) and makes debugging and extension simpler and safer.

4.  **Explain Your Reasoning:**
    *   **Principle:** When making significant architectural decisions, choosing a new library, or implementing a complex piece of logic, provide a concise explanation for the chosen approach. Assume a technical audience.
    *   **Why:** Understanding the "why" behind a decision is crucial for long-term project health. It provides context that allows for better future decisions and helps prevent the introduction of conflicting patterns.

## Practical Development Approaches

5.  **Testing Philosophy:**
    *   **Principle:** Write tests for all new functionality and bug fixes. Prioritize unit tests for isolated logic and integration tests for component interactions. Focus on testing the *behavior* of the code, not the internal implementation details.
    *   **Why:** A solid test suite acts as a safety net, preventing regressions and enabling confident refactoring. It also serves as living documentation of how the code is intended to be used.

6.  **Security by Design:**
    *   **Principle:** Operate on a "zero trust" basis for all inputs. Sanitize and validate data at the boundaries of the system. Never hardcode secrets, API keys, or other sensitive data. Follow the principle of least privilege for any permissions.
    *   **Why:** Security is not an afterthought. Building with a security-first mindset is the most effective way to prevent common vulnerabilities (like XSS or injection attacks) and protect user data.

7.  **Robust Error Handling:**
    *   **Principle:** Handle potential errors gracefully. For users, provide clear and helpful feedback without exposing internal system details. For developers, log errors with sufficient context (like stack traces and relevant variables) to make debugging straightforward.
    *   **Why:** Good error handling improves the user experience by preventing abrupt crashes. For the development team, meaningful logs are essential for efficiently diagnosing and fixing issues in a production environment.

8.  **Conventional Commit Messages:**
    *   **Principle:** Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for all commit messages (e.g., `feat:`, `fix:`, `docs:`, `refactor:`). The message body should clearly explain the "what" and "why" of the change.
    *   **Why:** A consistent and structured commit history makes it easier to understand the project's evolution, automates changelog generation, and simplifies the process of releasing new versions.

9.  **Performance Awareness:**
    *   **Principle:** Be mindful of performance, but avoid premature optimization. For backend code, ensure database queries are efficient (using indexes, avoiding N+1 problems). For frontend code, be conscious of bundle size and rendering performance.
    *   **Why:** A performant application provides a better user experience and can reduce infrastructure costs. Considering performance during development can prevent major refactoring efforts later on.

## Development Workflow

You MUST follow this cycle for every task:

1. **Phase 1: Planning**
   - Research the codebase to identify all affected files.
   - **Present a detailed step-by-step plan** to the user in your response.
   - **Stop and wait for user approval** of the plan before writing any code or modifying files.

2. **Phase 2: Implementation**
   - Once approved, apply changes incrementally.
   - If a change is complex, use `/checkpoint save` before proceeding.
   - Ensure all code adheres to the style guide defined in this file.

3. **Phase 3: Testing & Quality**
   - After coding, you MUST run the project's test and quality suite (e.g., unit tests, linting, type-checking).
   - Refer to the project-specific `gemini.md` or README to identify the exact commands.
   - **If you cannot find the test/quality suite or are unsure how to run it, you MUST ask the user for the correct commands.**
   - If tests fail, analyze the logs, propose a fix, and loop back to Phase 2.
   - Do not consider a task "Done" until all tests and quality checks pass.

## Misc

10. **Explain Deviations:**
    *   **Principle:** If you find it necessary to deviate from a specific instruction in this document or a user request (e.g., due to conflicts with existing code patterns or technical constraints), explicitly state the deviation and explain the reasoning behind it before proceeding.
    *   **Why:** Transparency ensures the user understands the decision-making process and can correct course if the deviation is not desired. It prevents "silent failures" where instructions are ignored without notice.
