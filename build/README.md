# James's Really Useful Build Scripts

A collection of scripts useful when building applications/projects in a continuous integration (CI) environment.

## Table of Contents

- [James's Really Useful Build Scripts](#jamess-really-useful-build-scripts)
  - [Table of Contents](#table-of-contents)
  - [Versioning](#versioning)
    - [Get-BuildVersion](#get-buildversion)

---

## Versioning

### [Get-BuildVersion](./Get-BuildVersion.psm1)

Gets a semantically versioned build number from a provided string value. This is useful when you want to version your applications based on a Git tag or branch name containing the expected version number. Supports pre-release versions with a `-` format after the version number.

```powershell
# Gets the build version from the current Git branch name
Get-BuildVersion -VersionString $Env:GITHUB_REF
```
