# James' Really Useful Scripts

Just a collection of really useful scripts that I use on a regular basis, mainly written in PowerShell, aimed at making me more efficient in my day-to-day tasks.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Overview](#overview)
- [About the Scripts](#about-the-scripts)
- [Installing PowerShell Modules](#installing-powershell-modules)
  - [Option 1: Temporary (from a cloned repo)](#option-1-temporary-from-a-cloned-repo)
  - [Option 2: Global / Autoload (recommended)](#option-2-global--autoload-recommended)
  - [Load from your PowerShell profile](#load-from-your-powershell-profile)
- [Contributing](#contributing)
  - [Support \& Reuse Expectations](#support--reuse-expectations)
- [License](#license)

---

## Overview

As an engineer who works on a variety of different daily tasks, I often find myself writing small helper scripts to automate repetitive tasks or to simplify complex workflows. This can include tying multiple Azure CLI commands together, automating Git operations, or setting up development environments. By automating these tasks with scripts, I can save time and reduce the risk of human error, leading to more consistent and efficient outcomes.

This repository aims to become an evolving collection of these tiny scripts that I find useful in my daily work. The scripts are primarily written in PowerShell, but may also include other languages such as Python or Bash, depending on the task at hand. They are intended for my personal use, but they're here to be shared, modified, and provide inspiration for others who may find them useful.

## About the Scripts

Please use the list below to find more details about each of the scripts available in this repository. The structure of the repository is organized by category, with each script contained in its own file. Each script is designed to be self-contained and can be run independently. Some may also contain registered aliases for easier access.

- [Azure](./azure/README.md): Scripts for managing Azure resources by tapping into the Azure CLI.
- [Build](./build/README.md): Scripts for managing CI/CD processes.
- [.NET](./dotnet/README.md): Scripts for managing .NET projects and applications.
- [Git](./git/README.md): Scripts for managing Git repositories and operations.
- [JSON](./json/README.md): Scripts for converting and manipulating JSON data.
- [Python](./python/README.md): Scripts for managing Python projects and applications.

## Installing PowerShell Modules

Instead of manually importing each script, you can now use the meta module `UsefulScripts` which automatically aggregates all functions and aliases defined across this repository.

### Option 1: Temporary (from a cloned repo)

```powershell
Import-Module '<path-to-clone>\UsefulScripts\UsefulScripts.psd1' -Force
```

### Option 2: Global / Autoload (recommended)

Copy or symlink the `UsefulScripts` folder (the folder that contains `UsefulScripts.psd1` and `UsefulScripts.psm1`) into a location on `$env:PSModulePath`, e.g.:

Windows PowerShell / PowerShell (Windows):

```powershell
$target = "$HOME/OneDrive/Documents/PowerShell/Modules/UsefulScripts"
# or: "$HOME/Documents/PowerShell/Modules/UsefulScripts"
Copy-Item -Recurse '<path-to-clone>\UsefulScripts' $target
```

macOS / Linux:

```powershell
$target = "$HOME/.local/share/powershell/Modules/UsefulScripts"
Copy-Item -Recurse '<path-to-clone>/UsefulScripts' $target
```

Once placed, any call to an exported function or alias (e.g. `gitget`, `Set-AzureSubscription`, `Reset-Docker`) will automatically autoload the module.

You can list the imported functions and aliases with:

```powershell
Get-UsefulScriptInfo | Format-List
```

### Load from your PowerShell profile

If you regularly update this repository in-place, add the snippet below to your PowerShell profile (`$PROFILE`) so the module is loaded on every session and your repo is appended to `$env:PSModulePath` automatically.

```powershell
$repoRoot   = 'C:\src\useful-scripts'
$modulePath = Join-Path $repoRoot 'UsefulScripts\UsefulScripts.psd1'

if (-not (Test-Path $modulePath)) {
    Write-Warning "Module manifest not found at $modulePath"
} else {
    if ($env:PSModulePath -notmatch [regex]::Escape($repoRoot)) {
        $env:PSModulePath = $repoRoot + [IO.Path]::PathSeparator + $env:PSModulePath
    }

    try {
        Import-Module $modulePath -Force -Global -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to import UsefulScripts: $_"
    }
}
```

Reload your profile (`. $PROFILE`) or open a new terminal session to start using the exported commands right away.

## Contributing

_This repository is primarily for my personal use, but contributions are welcome! For pull requests more complicated than typos, it is often best to submit an issue first._

If you have any questions or feedback, please reach out to me!

### Support & Reuse Expectations

Please understand that this repository is for my personal use, and while I focus on ensuring the scripts are functional, I cannot guarantee that they will work as intended for your specific use cases. I encourage you to review the scripts and adapt them as needed for your own requirements.

**I am not responsible for any issues that may arise from your use of these scripts.** Liability for any problems or damages resulting from the use of these scripts rests solely with you. By using these scripts, you agree to take full responsibility for their use and any consequences that may arise.

## License

This repository is licensed under the [MIT License](./LICENSE). You are free to use, modify, and distribute the scripts as long as you include the original license and copyright notice in any copies or substantial portions of the software.
