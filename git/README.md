# James's Really Useful Git Scripts

A collection of scripts useful when working with Git repositories.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Get-AllGitRepos](#get-allgitrepos)
- [Sync-AllGitRepos](#sync-allgitrepos)
- [Update-GitIndex](#update-gitindex)
- [New-GitBranch](#new-gitbranch)
- [New-GitWorktree](#new-gitworktree)
- [Merge-GitBranch](#merge-gitbranch)
- [Merge-GitMain](#merge-gitmain)
- [Undo-GitCommit](#undo-gitcommit)
- [Remove-GitBranches](#remove-gitbranches)

---

## [Get-AllGitRepos](./Get-AllGitRepos.psm1)

Performs a fetch of all Git repositories in the current directory and its subdirectories. This is useful if you are working with multiple Git repositories in a single project (e.g., a repo-per-microservice setup) and want to ensure all repositories are up-to-date.

```powershell
Get-AllGitRepos
```

Alternatively, you can use the alias `gitget`:

```powershell
gitget
```

## [Sync-AllGitRepos](./Sync-AllGitRepos.psm1)

Fetches and pulls all Git repositories in the current directory and its subdirectories. This script is useful for synchronizing multiple repositories with their remote counterparts, ensuring that all local branches are up-to-date.

```powershell
Sync-AllGitRepos
```

Alternatively, you can use the alias `gitsync`:

```powershell
gitsync
```

## [Update-GitIndex](./Update-GitIndex.psm1)

Updates the Git index for all repositories in the current directory and its subdirectories. This script is useful for ensuring that the index is up-to-date with the latest changes in the working directory, especially after making changes to files or directories.

```powershell
Update-GitIndex
```

## [New-GitBranch](./New-GitBranch.psm1)

Creates a new Git branch based on the main branch. This script simplifies the process of creating a new branch from main by allowing you to specify the branch name, ensuring the main branch is up-to-date, and creating and swapping to the new branch in one command.

```powershell
New-GitBranch -Branch "feature/new-feature"
```

## [New-GitWorktree](./New-GitWorktree.psm1)

Creates a new local branch and worktree from the latest `main` on `origin`, fetching it first. Run it anywhere inside a repository, or specify the repository with `-Path`:

```powershell
New-GitWorktree -Branch "u/jamescroft/refactor-this-thing" -Path "C:\src\new-project"
```

For this example, the worktree is created at `C:\src\new-project-worktrees\u-jamescroft-refactor-this-thing`. Worktrees always sit in a sibling `<repo>-worktrees` directory, with `/` in branch names replaced by `-`. Running the command from an existing linked worktree still uses the original repository's sibling directory.

Alternatively, use the alias `gitworktree` from inside the repository:

```powershell
gitworktree "u/jamescroft/refactor-this-thing"
```

Use `-MainBranch` and `-Remote` when the base branch or remote differs:

```powershell
New-GitWorktree -Branch "feature/new-feature" -MainBranch "master" -Remote "upstream"
```

The command returns the absolute worktree path. Your current location, branch, local `main`, and uncommitted changes remain unchanged. To enter the worktree immediately:

```powershell
Set-Location (gitworktree "u/jamescroft/refactor-this-thing")
```

For safety, existing local branches and destination paths are rejected rather than reused or overwritten, including collisions between branch names such as `feature/example` and `feature-example`. Invalid branch names and folder names are rejected. A failed fetch stops creation instead of using a stale local branch. Git arguments are passed directly, not evaluated as shell commands. Nothing is pushed, and the new branch does not track the base branch; publish it explicitly when ready:

```powershell
git push -u origin HEAD
```

## [Merge-GitBranch](./Merge-GitBranch.psm1)

Merges the specified branch into the current branch. This script simplifies the process of merging branches by allowing you to specify the branch name and whether to perform a fast-forward merge.

```powershell
Merge-GitBranch -Branch "feature-branch"
```

## [Merge-GitMain](./Merge-GitBranch.psm1)

Merges the current branch with the `main` branch. This script is useful for keeping your feature branches up-to-date with the latest changes from the main branch.

```powershell
Merge-GitMain
```

Alternatively, you can use the alias `gitupdate`:

```powershell
gitupdate
```

## [Undo-GitCommit](./Undo-GitCommit.psm1)

Performs a hard reset to the previous commit, effectively undoing the last commit. This script is useful when you need to quickly revert a commit without affecting the working directory.

> [!WARNING] This will discard all changes made in the last commit, so use it with caution.

```powershell
Undo-GitCommit
```

Alternatively, you can use the alias `gitundo`:

```powershell
gitundo
```

## [Remove-GitBranches](./Remove-GitBranches.psm1)

Prunes local branches that have already been merged into your base branch (defaults to `main`), skipping protected branches and the one you are currently on.

```powershell
Remove-GitBranches
```

Alternatively, you can use the alias `gitprune`:

```powershell
gitprune
```
