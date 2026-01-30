# James's Really Useful Python Scripts

A collection of scripts useful when working with Python projects and applications.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [New-PythonEnvironment](#new-pythonenvironment)
- [Restart-PythonEnvironment](#restart-pythonenvironment)
- [Find-PythonDependencyIssues](#find-pythondependencyissues)
- [Update-PythonEnvironmentPackages](#update-pythonenvironmentpackages)

---

## [New-PythonEnvironment](./New-PythonEnvironment.psm1)

Creates a new Python virtual environment in the current directory. This script simplifies the process of setting up a new Python environment `.venv`, automatically activating it, installing any required packages from a `requirements.txt` file if it exists.

> [!NOTE]
> If the `.venv` already exists, the script will not overwrite it. Instead, it will activate the existing environment.

```powershell
New-PythonEnvironment
```

Alternatively, you can use the alias `pyenv`:

```powershell
pyenv
```

## [Restart-PythonEnvironment](./Restart-PythonEnvironment.psm1)

Restarts the current Python virtual environment by deactivating it and then activating it again. This is useful for refreshing the environment after making changes to the `requirements.txt` file or other configuration files.

```powershell
Restart-PythonEnvironment
```

Alternatively, you can use the alias `pyrestart`:

```powershell
pyrestart
```

## [Find-PythonDependencyIssues](./Find-PythonDependencyIssues.psm1)

Checks the active environment for dependency conflicts and lists outdated packages so you can keep the project healthy.

```powershell
Find-PythonDependencyIssues
```

Alternatively, you can use the alias `pydeps`:

```powershell
pydeps
```

## [Update-PythonEnvironmentPackages](./Update-PythonEnvironmentPackages.psm1)

Installs dependencies from `requirements.txt` and optionally removes packages not declared there, keeping the environment aligned with the lock file.

```powershell
Update-PythonEnvironmentPackages -RemoveExtras
```

Alternatively, you can use the alias `pyreconcile`:

```powershell
pyreconcile -RemoveExtras
```
