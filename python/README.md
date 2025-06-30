# James's Really Useful Python Scripts

A collection of scripts useful when working with Python projects and applications.

## Table of Contents

- [James's Really Useful Python Scripts](#jamess-really-useful-python-scripts)
  - [Table of Contents](#table-of-contents)
  - [New-PythonEnvironment](#new-pythonenvironment)
  - [Restart-PythonEnvironment](#restart-pythonenvironment)

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
