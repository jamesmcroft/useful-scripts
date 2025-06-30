# James's Really Useful Git Scripts

A collection of scripts useful when working with Git repositories.

## Table of Contents

- [James's Really Useful Git Scripts](#jamess-really-useful-git-scripts)
  - [Table of Contents](#table-of-contents)
  - [Get-AllGitRepos](#get-allgitrepos)
  - [Sync-AllGitRepos](#sync-allgitrepos)
  - [Update-GitIndex](#update-gitindex)
  - [New-GitBranch](#new-gitbranch)
  - [Merge-GitBranch](#merge-gitbranch)
  - [Merge-WithGitMain](#merge-withgitmain)
  - [Undo-GitCommit](#undo-gitcommit)

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

## [Merge-GitBranch](./Merge-GitBranch.psm1)

Merges the specified branch into the current branch. This script simplifies the process of merging branches by allowing you to specify the branch name and whether to perform a fast-forward merge.

```powershell
Merge-GitBranch -Branch "feature-branch"
```

## [Merge-WithGitMain](./Merge-WithGitMain.psm1)

Merges the current branch with the `main` branch. This script is useful for keeping your feature branches up-to-date with the latest changes from the main branch.

```powershell
Merge-WithGitMain
```

Alternatively, you can use the alias `gitupdate`:

```powershell
gitupdate
```

## [Undo-GitCommit](./Undo-GitCommit.psm1)

Performs a hard reset to the previous commit, effectively undoing the last commit. This script is useful when you need to quickly revert a commit without affecting the working directory.

> [!WARNING]
> This will discard all changes made in the last commit, so use it with caution.

```powershell
Undo-GitCommit
```

Alternatively, you can use the alias `gitundo`:

```powershell
gitundo
```
