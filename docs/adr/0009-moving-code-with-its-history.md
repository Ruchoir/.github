# 0009. Moving code with its history

- Status: accepted
- Date: 2026-11-06

## Context

The restructuring moves code from `Ruchoir/ruchoir` into the new repositories, and keeps the history
of the files it takes (ADR 0008). Two of the common rules get in the way:

- pull requests are squash-merged, which would fold the imported history into one commit;
- the `conventions` check refuses ticket references and subjects that are not Conventional Commits,
  and the old history has both.

## Decision

- **Extraction.** The files are extracted with `git filter-repo`, keeping only their own history,
  renamed to their new paths.
- **Messages.** In the imported commit messages, every line that names a ticket is dropped, and a
  subject that is not a Conventional Commit gets `chore: ` in front. Code, authors and dates are
  untouched.
- **Merging.** The pull request that brings the history in is merged with a merge commit. The option
  is enabled on the repository for that merge, then disabled again.
- **Licence.** Code that leaves an AGPL repository for a permissively licensed one (`core`) moves only
  when every commit of the files has the same single author, who agrees to the new licence. Otherwise
  it stays AGPL or waits for a decision.

## Consequences

- `git log` and `git blame` keep working in the new repositories.
- Every other pull request is still squash-merged.
- The common block says "squash-merged" without this exception: its next major version mentions it.
