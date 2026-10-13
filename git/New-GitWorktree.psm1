Function New-GitWorktree {
    <#
    .SYNOPSIS
    Creates a new branch and worktree from the latest remote main branch.
    .DESCRIPTION
    Places worktrees in a sibling <repo>-worktrees directory, replacing branch
    name slashes with hyphens. Leaves the current checkout and location unchanged.
    .PARAMETER Branch
    The new branch name. Existing local branches are not overwritten.
    .PARAMETER Path
    A directory inside the repository or one of its worktrees. Defaults to ".".
    .PARAMETER MainBranch
    The remote base branch. Defaults to "main".
    .PARAMETER Remote
    The remote to fetch the base branch from. Defaults to "origin".
    .OUTPUTS
    System.String. The absolute path of the created worktree.
    .EXAMPLE
    New-GitWorktree -Branch "u/jamescroft/refactor-this-thing" -Path "C:\src\new-project"
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch,
        [ValidateNotNullOrEmpty()]
        [string]$Path = ".",
        [ValidateNotNullOrEmpty()]
        [string]$MainBranch = "main",
        [ValidateNotNullOrEmpty()]
        [string]$Remote = "origin"
    )

    # Check native exit codes explicitly, including the expected missing-ref result.
    $PSNativeCommandUseErrorActionPreference = $false
    $repoPath = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).ProviderPath
    $repoRoot = git -C $repoPath rev-parse --show-toplevel
    if ($LASTEXITCODE -ne 0) {
        throw "Path '$Path' must be inside a non-bare Git repository."
    }

    $validatedBranch = git -C $repoRoot check-ref-format --branch $Branch
    if ($LASTEXITCODE -ne 0 -or $validatedBranch -cne $Branch) {
        throw "Invalid new branch name '$Branch'. Specify a literal branch name."
    }

    git check-ref-format "refs/heads/$MainBranch"
    if ($LASTEXITCODE -ne 0) {
        throw "Invalid main branch name '$MainBranch'."
    }

    $folderName = $Branch.Replace("/", "-")
    if ($folderName.IndexOfAny([IO.Path]::GetInvalidFileNameChars()) -ge 0 -or
        $folderName -match '^(?i:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\.|$)') {
        throw "Branch '$Branch' cannot be used as a worktree folder name."
    }

    # The first listed worktree is the original checkout, even from a linked worktree.
    $worktrees = @(git -C $repoRoot -c core.quotePath=false worktree list --porcelain)
    if ($LASTEXITCODE -ne 0 -or $worktrees.Count -eq 0 -or
        -not $worktrees[0].StartsWith("worktree ")) {
        throw "Could not determine the original checkout for '$repoRoot'."
    }

    $primaryRoot = $worktrees[0].Substring("worktree ".Length)
    $worktreeParent = Join-Path (Split-Path -Parent $primaryRoot) "$(Split-Path -Leaf $primaryRoot)-worktrees"
    $worktreePath = Join-Path $worktreeParent $folderName
    if (Test-Path -LiteralPath $worktreePath) {
        throw "Worktree path '$worktreePath' already exists. Nothing was overwritten."
    }

    git -C $repoRoot show-ref --verify --quiet "refs/heads/$Branch"
    if ($LASTEXITCODE -eq 0) {
        throw "Local branch '$Branch' already exists. Choose a new branch name."
    }
    if ($LASTEXITCODE -ne 1) {
        throw "Could not check whether local branch '$Branch' exists."
    }

    git -C $repoRoot remote get-url -- $Remote | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Could not find remote '$Remote' in '$repoRoot'."
    }

    Write-Verbose "Fetching '$MainBranch' from '$Remote'."
    git -C $repoRoot fetch -- $Remote "refs/heads/$MainBranch" | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to fetch '$MainBranch' from '$Remote'. No worktree was created."
    }

    $baseCommit = git -C $repoRoot rev-parse --verify "FETCH_HEAD^{commit}"
    if ($LASTEXITCODE -ne 0) {
        throw "Could not resolve the fetched commit for '$MainBranch'. No worktree was created."
    }

    git -C $repoRoot worktree add --no-track -b $Branch -- $worktreePath $baseCommit | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create worktree '$worktreePath' for branch '$Branch'."
    }

    return $worktreePath
}

New-Alias -Name gitworktree -Value New-GitWorktree -Force
Export-ModuleMember -Function New-GitWorktree -Alias gitworktree
