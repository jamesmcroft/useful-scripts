# James' Really Useful Scripts

Just a collection of really useful scripts that I use on a regular basis, mainly written in PowerShell, aimed at making me more efficient in my day-to-day tasks.

## Table of Contents

- [James' Really Useful Scripts](#james-really-useful-scripts)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [About the Scripts](#about-the-scripts)
  - [Installing PowerShell Modules](#installing-powershell-modules)
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

To install all the modules in this repository, run the following command in PowerShell:

```powershell
Add-UsefulScriptModules.ps1
```

This command will automatically install all the PowerShell modules found in this repository, making them available for use in your PowerShell environment.

> [!NOTE]
> You can also run `Remove-UsefulScriptModules.ps1` to remove all Useful Script modules.

## Contributing

_This repository is primarily for my personal use, but contributions are welcome! For pull requests more complicated than typos, it is often best to submit an issue first._

If you have any questions or feedback, please reach out to me!

### Support & Reuse Expectations

Please understand that this repository is for my personal use, and while I focus on ensuring the scripts are functional, I cannot guarantee that they will work as intended for your specific use cases. I encourage you to review the scripts and adapt them as needed for your own requirements.

**I am not responsible for any issues that may arise from your use of these scripts.** Liability for any problems or damages resulting from the use of these scripts rests solely with you. By using these scripts, you agree to take full responsibility for their use and any consequences that may arise.

## License

This repository is licensed under the [MIT License](./LICENSE). You are free to use, modify, and distribute the scripts as long as you include the original license and copyright notice in any copies or substantial portions of the software.
