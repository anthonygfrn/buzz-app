## Git Workflow and Commit Message Guide

This guide explains the Git workflow and commit message conventions used by Buzz. 

### Git Branching 

We use a structured branching strategy to maintain organized and efficient development. Below are the various branch types and their purposes:

#### 1. **Main Branch (main)**
   - **Purpose:** The stable branch containing production-ready code.
   - Any changes merged into this branch must be thoroughly tested and stable.

#### 2. **Development Branch (dev)**
   - **Purpose:** The primary branch for ongoing development. All new features and updates are integrated here after testing.
   - Day-to-day development occurs on this branch.

#### 3. **Feature Branches**
   - **Purpose:** Used for isolated feature development to avoid conflicts.
   - **Naming Convention:** `feature/feature-name`
     - Example: `feature/user-login`, `feature/refactor-ui`, `feature/login-logic`
   - Always create a feature branch from the `dev` branch.

#### 4. **Hotfix Branches**
   - **Purpose:** For urgent bug fixes that need to be applied directly to the `main` branch.
   - **Naming Convention:** `hotfix/issue-name`
     - Example: `hotfix/login-bug`, `hotfix/data-crash`
   - Once the fix is completed, merge the hotfix branch into both `main` and `dev` to keep them synchronized.

#### 5. **Bugfix Branches**
   - **Purpose:** For non-urgent bug fixes.
   - **Naming Convention:** `bugfix/issue-name`
     - Example: `bugfix/prompt-issue`, `bugfix/model-errors`
   - Branch off from `dev`.

#### 6. **Release Branches**
   - **Purpose:** Used for final preparation of a specific release.
   - **Naming Convention:** `release/version-number`
     - Example: `release/1.0.0`
   - Only minor bug fixes or tweaks are allowed on this branch. After final testing, merge the release branch into both `main` for the production release and `dev` to keep everything in sync.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Commit Message Conventions

To ensure clear and consistent commit messages, follow these guidelines:

1. **New Feature for the User (not a feature for build scripts):**
   - **Format:** `feat: <description>`
   - **Example:** `feat: Add alarm clock turn off feature`

2. **Bug Fix for the User (not a fix to build scripts):**
   - **Format:** `fix: <description>`
   - **Example:** `fix: Fix user login bug`

3. **Changes to Documentation:**
   - **Format:** `docs: <description>`
   - **Example:** `docs: Update API usage guide`

4. **Code Formatting (e.g., missing semicolons, indentation) with no production code changes:**
   - **Format:** `style: <description>`
   - **Example:** `style: Fix indentation issues`

5. **Refactoring Production Code (no feature addition or bug fix):**
   - **Format:** `refactor: <description>`
   - **Example:** `refactor: Rename variables for better clarity`

6. **Adding or Refactoring Tests (no production code change):**
   - **Format:** `test: <description>`
   - **Example:** `test: Add unit tests for login function`

7. **Changes to Build Process or Dependencies:**
   - **Format:** `chore: <description>`
   - **Example:** `chore: Update dependencies to latest versions`

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
