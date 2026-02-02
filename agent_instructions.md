# AI Agent Instructions for get_goin Flutter App

## Reference
For app features, requirements, and design, see [app_design.md](app_design.md).

## Testing
- All new features and bug fixes must include unit tests.
- Use the `test` package for Dart unit testing.
- Aim for high code coverage, especially for core logic.
- Write widget tests for UI components in the `test/` directory.

## Code Structure & Principles
- Follow Object-Oriented Programming (OOP) principles:
  - Use classes to encapsulate related data and behavior.
  - Prefer composition over inheritance where possible.
  - Use interfaces (abstract classes) for shared contracts.
- Adhere to CLEAN code principles:
  - Write readable, self-explanatory code and comments.
  - Use meaningful names for variables, classes, and methods.
  - Keep functions and classes small and focused.
  - Avoid code duplication; extract reusable logic.
  - Separate concerns: UI, business logic, and data should be decoupled.
  - Use dependency injection for managing dependencies.
  - Handle errors gracefully and log exceptions.

## Additional Recommendations
- Use Flutter best practices for state management (e.g., Provider, Riverpod, Bloc).
- Organize code into logical folders: `lib/`, `test/`, `assets/`, etc.
- Document public APIs and complex logic with DartDoc comments.
- Use const constructors and widgets where possible for performance.
- Keep third-party dependencies up to date and minimal.
- Ensure accessibility and responsiveness in UI design.
- Use version control (Git) for all changes.

---
These instructions are intended for all contributors and AI agents working on this codebase. Please update this file as new standards or practices are adopted.
