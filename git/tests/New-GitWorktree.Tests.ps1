BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..\New-GitWorktree.psm1') -Force

    function Invoke-TestGit {
        param([string[]]$Arguments)

        $output = & git @Arguments 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "git $($Arguments -join ' ') failed: $($output -join [Environment]::NewLine)"
        }
        return $output
    }

    $fixtureRoot = Join-Path $TestDrive 'worktree fixtures'
    $null = New-Item -ItemType Directory -Path $fixtureRoot
    $remotePath = Join-Path $fixtureRoot 'remote.git'
    $seedPath = Join-Path $fixtureRoot 'seed'
    $repoPath = Join-Path $fixtureRoot 'new-project'
    $worktreeParent = Join-Path $fixtureRoot 'new-project-worktrees'

    Invoke-TestGit -Arguments @('init', '--bare', '--initial-branch=main', $remotePath) | Out-Null
    Invoke-TestGit -Arguments @('init', '--initial-branch=main', $seedPath) | Out-Null
    Invoke-TestGit -Arguments @('-C', $seedPath, 'config', 'user.name', 'Worktree Tests') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seedPath, 'config', 'user.email', 'worktree-tests@example.invalid') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seedPath, 'config', 'commit.gpgSign', 'false') | Out-Null
    Set-Content -LiteralPath (Join-Path $seedPath 'tracked.txt') -Value 'Initial contents'
    Invoke-TestGit -Arguments @('-C', $seedPath, 'add', 'tracked.txt') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seedPath, 'commit', '-m', 'Initial main') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seedPath, 'remote', 'add', 'origin', $remotePath) | Out-Null
    Invoke-TestGit -Arguments @('-C', $seedPath, 'push', 'origin', 'main') | Out-Null
    Invoke-TestGit -Arguments @('clone', $remotePath, $repoPath) | Out-Null
    $initialCommit = Invoke-TestGit -Arguments @('-C', $repoPath, 'rev-parse', 'HEAD')

    Invoke-TestGit -Arguments @('-C', $seedPath, 'commit', '--allow-empty', '-m', 'Latest remote main') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seedPath, 'push', 'origin', 'main') | Out-Null
    $latestCommit = Invoke-TestGit -Arguments @('-C', $seedPath, 'rev-parse', 'HEAD')

    $null = New-Item -ItemType Directory -Path (Join-Path $repoPath 'nested')
    Set-Content -LiteralPath (Join-Path $repoPath 'tracked.txt') -Value 'Uncommitted tracked changes'
    Set-Content -LiteralPath (Join-Path $repoPath 'uncommitted.txt') -Value 'Leave this alone'
}

AfterAll {
    # Git objects are read-only on Windows; allow Pester to remove its fixture.
    if ($fixtureRoot -and (Test-Path -LiteralPath $fixtureRoot)) {
        Get-ChildItem -LiteralPath $fixtureRoot -Recurse -Force -File -ErrorAction Stop | ForEach-Object {
            $_.IsReadOnly = $false
        }
    }
}

Describe 'New-GitWorktree' {
    It 'creates the exact sibling path from fresh remote main without changing the original checkout' {
        $originalLocation = Get-Location
        Push-Location (Join-Path $repoPath 'nested')
        try {
            $locationBefore = (Get-Location).Path
            $result = @(gitworktree 'u/jamescroft/refactor-this-thing')
            $result.Count | Should -Be 1
            $result[0] | Should -Be (Join-Path $worktreeParent 'u-jamescroft-refactor-this-thing')
            (Get-Location).Path | Should -Be $locationBefore
        }
        finally {
            Pop-Location
        }

        (Get-Location).Path | Should -Be $originalLocation.Path
        Invoke-TestGit -Arguments @('-C', $result[0], 'rev-parse', 'HEAD') | Should -Be $latestCommit
        Invoke-TestGit -Arguments @('-C', $result[0], 'branch', '--show-current') | Should -Be 'u/jamescroft/refactor-this-thing'
        Invoke-TestGit -Arguments @('-C', $repoPath, 'rev-parse', 'main') | Should -Be $initialCommit
        Invoke-TestGit -Arguments @('-C', $repoPath, 'branch', '--show-current') | Should -Be 'main'
        Get-Content -LiteralPath (Join-Path $repoPath 'tracked.txt') | Should -Be 'Uncommitted tracked changes'
        Get-Content -LiteralPath (Join-Path $repoPath 'uncommitted.txt') | Should -Be 'Leave this alone'
        $status = Invoke-TestGit -Arguments @('-C', $repoPath, 'status', '--porcelain')
        $status.Count | Should -Be 2
        $status | Should -Contain ' M tracked.txt'
        $status | Should -Contain '?? uncommitted.txt'
        $upstream = Invoke-TestGit -Arguments @('-C', $repoPath, 'for-each-ref', '--format=%(upstream)', 'refs/heads/u/jamescroft/refactor-this-thing')
        [string]::IsNullOrWhiteSpace(($upstream -join '')) | Should -BeTrue
        Invoke-TestGit -Arguments @('--git-dir', $remotePath, 'for-each-ref', '--format=%(refname)', 'refs/heads') | Should -Be 'refs/heads/main'
    }

    It 'uses the original repository directory from an existing linked worktree' {
        $linkedPath = Join-Path $fixtureRoot 'elsewhere'
        Invoke-TestGit -Arguments @('-C', $repoPath, 'worktree', 'add', '-b', 'existing-worktree', $linkedPath, $initialCommit) | Out-Null
        $nestedPath = Join-Path $linkedPath 'nested'
        $null = New-Item -ItemType Directory -Path $nestedPath

        $result = New-GitWorktree -Branch 'feature/from-linked-worktree' -Path $nestedPath

        $result | Should -Be (Join-Path $worktreeParent 'feature-from-linked-worktree')
        Invoke-TestGit -Arguments @('-C', $result, 'rev-parse', 'HEAD') | Should -Be $latestCommit
        Invoke-TestGit -Arguments @('-C', $linkedPath, 'rev-parse', 'HEAD') | Should -Be $initialCommit
    }

    It 'supports another remote and base branch even with a narrow fetch configuration' {
        Invoke-TestGit -Arguments @('-C', $seedPath, 'branch', 'release', $initialCommit) | Out-Null
        Invoke-TestGit -Arguments @('-C', $seedPath, 'push', 'origin', 'release') | Out-Null
        Invoke-TestGit -Arguments @('-C', $repoPath, 'remote', 'add', '-t', 'main', 'upstream', $remotePath) | Out-Null

        $result = New-GitWorktree -Branch 'feature/custom-base' -Path $repoPath -Remote 'upstream' -MainBranch 'release'

        Invoke-TestGit -Arguments @('-C', $result, 'rev-parse', 'HEAD') | Should -Be $initialCommit
    }

    It 'rejects an existing branch without overwriting it' {
        Invoke-TestGit -Arguments @('-C', $repoPath, 'branch', 'already-exists', $initialCommit) | Out-Null

        { New-GitWorktree -Branch 'already-exists' -Path $repoPath } | Should -Throw '*already exists*'

        Invoke-TestGit -Arguments @('-C', $repoPath, 'rev-parse', 'already-exists') | Should -Be $initialCommit
        Test-Path -LiteralPath (Join-Path $worktreeParent 'already-exists') | Should -BeFalse
    }

    It 'rejects repeated creation, branch-name path collisions, and existing folders' {
        $result = New-GitWorktree -Branch 'feature/collision' -Path $repoPath
        { New-GitWorktree -Branch 'feature/collision' -Path $repoPath } | Should -Throw '*already exists*'
        { New-GitWorktree -Branch 'feature-collision' -Path $repoPath } | Should -Throw '*already exists*'
        Invoke-TestGit -Arguments @('-C', $result, 'branch', '--show-current') | Should -Be 'feature/collision'

        $occupiedPath = Join-Path $worktreeParent 'occupied'
        $null = New-Item -ItemType Directory -Path $occupiedPath
        Set-Content -LiteralPath (Join-Path $occupiedPath 'keep.txt') -Value 'Preserve this'
        { New-GitWorktree -Branch 'occupied' -Path $repoPath } | Should -Throw '*already exists*'
        Get-Content -LiteralPath (Join-Path $occupiedPath 'keep.txt') | Should -Be 'Preserve this'
        $branches = Invoke-TestGit -Arguments @('-C', $repoPath, 'for-each-ref', '--format=%(refname)', 'refs/heads')
        $branches | Should -Not -Contain 'refs/heads/feature-collision'
        $branches | Should -Not -Contain 'refs/heads/occupied'
    }

    It 'stops on a missing remote or remote main instead of using stale FETCH_HEAD' {
        { New-GitWorktree -Branch 'missing-remote' -Path $repoPath -Remote 'missing' 2>$null } | Should -Throw '*remote*'
        { New-GitWorktree -Branch 'missing-main' -Path $repoPath -MainBranch 'missing' 2>$null } | Should -Throw '*Failed to fetch*'

        Test-Path -LiteralPath (Join-Path $worktreeParent 'missing-remote') | Should -BeFalse
        Test-Path -LiteralPath (Join-Path $worktreeParent 'missing-main') | Should -BeFalse
        $branches = Invoke-TestGit -Arguments @('-C', $repoPath, 'for-each-ref', '--format=%(refname)', 'refs/heads')
        $branches | Should -Not -Contain 'refs/heads/missing-remote'
        $branches | Should -Not -Contain 'refs/heads/missing-main'
    }

    It 'rejects invalid Git names and Windows folder names before fetching' {
        foreach ($branch in @('invalid branch', '../escape', '-option', '@{-1}', 'invalid|folder', 'CON', 'NUL.txt')) {
            { New-GitWorktree -Branch $branch -Path $repoPath 2>$null } | Should -Throw
        }
        { New-GitWorktree -Branch 'invalid-base' -Path $repoPath -MainBranch '../escape' } | Should -Throw '*Invalid main branch*'
        Test-Path -LiteralPath (Join-Path $worktreeParent 'invalid-base') | Should -BeFalse
    }

    It 'rejects non-repositories, bare repositories, and nonexistent paths' {
        { New-GitWorktree -Branch 'not-a-repo' -Path $fixtureRoot 2>$null } | Should -Throw '*non-bare Git repository*'
        { New-GitWorktree -Branch 'bare-repo' -Path $remotePath 2>$null } | Should -Throw '*non-bare Git repository*'
        { New-GitWorktree -Branch 'missing-path' -Path (Join-Path $fixtureRoot 'missing') } | Should -Throw
    }

    It 'is automatically exported by the UsefulScripts meta module' {
        Import-Module (Join-Path $PSScriptRoot '..\..\UsefulScripts\UsefulScripts.psd1') -Force

        (Get-Command New-GitWorktree).ModuleName | Should -Be 'UsefulScripts'
        (Get-Alias gitworktree).Definition | Should -Be 'New-GitWorktree'
        (Get-Alias gitworktree).ModuleName | Should -Be 'UsefulScripts'
    }
}
