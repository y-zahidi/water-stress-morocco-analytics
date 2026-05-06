# Contributing

Thanks for your interest in contributing! This document explains how to help
improve this project.

## Ways to contribute

- **Report bugs** by opening an issue with the `bug` template.
- **Suggest features** by opening an issue with the `feature` template.
- **Improve documentation** — typos, clarifications, examples.
- **Submit code changes** via a pull request (see workflow below).

## Development workflow

1. **Fork** the repository and clone your fork locally.
   ```bash
   git clone https://github.com/<your-username>/<repo>.git
   cd <repo>
   ```

2. **Create a branch** with a descriptive name.
   ```bash
   git checkout -b feat/short-description
   # or fix/short-description, docs/short-description, refactor/short-description
   ```

3. **Make your changes**. Keep commits small and focused. Each commit should
   leave the project in a working state.

4. **Test your changes** locally. If the project has a test suite, run it
   before pushing.

5. **Push your branch** to your fork and **open a pull request** against
   `main`. Fill in the PR template — it helps reviewers.

## Commit message convention

Use [Conventional Commits](https://www.conventionalcommits.org/) for clarity:

```
<type>(<optional scope>): <short description>

<optional longer body>
```

Common types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`.

Examples:
- `feat(auth): add password-reset endpoint`
- `fix(parser): handle empty input gracefully`
- `docs(readme): document install on macOS`

## Code style

- Follow the existing style of the codebase.
- Keep changes minimal and focused — avoid drive-by refactors in the same PR.
- Write self-explanatory names; comment only when intent isn't obvious from
  the code.

## Pull request checklist

Before requesting review:

- [ ] Branch is up to date with `main`
- [ ] Tests (if any) pass locally
- [ ] No unrelated files committed (build artifacts, IDE configs, etc.)
- [ ] Commits are squashed/cleaned up if needed
- [ ] PR description explains **what** changed and **why**

## Code of conduct

Be respectful, constructive, and patient. We're all here to learn and build.
Harassment or discrimination of any kind is not tolerated.

## Questions?

Open a discussion or reach out via email at **yassirzahidi8@gmail.com** —
happy to help.
