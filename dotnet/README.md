# James's Really Useful .NET Scripts

A collection of scripts useful when working with .NET projects and applications.

## Table of Contents

- [James's Really Useful .NET Scripts](#jamess-really-useful-net-scripts)
  - [Table of Contents](#table-of-contents)
  - [Entity Framework](#entity-framework)
    - [Add-DbMigration](#add-dbmigration)
  - [NuGet](#nuget)
    - [Inspect-NuGetPackage](#inspect-nugetpackage)

---

## Entity Framework

### [Add-DbMigration](./Add-DbMigration.psm1)

Adds a new Entity Framework migration to the current project. This script simplifies the process of creating migrations by allowing you to specify the migration name, context name, and output directory.

```powershell
Add-DbMigration -MigrationName "InitialCreate" -ContextName "MyDbContext" -OutputDir "Data/Migrations"
```

## NuGet

### [Inspect-NuGetPackage](./Inspect-NuGetPackage.psm1)

Inspects a NuGet package and lists its contents, highlighting architecture-specific folders and runtime identifiers. Useful for validating package assets across RIDs.

```powershell
Inspect-NuGetPackage -PackageName System.Text.Json -Filter "arm64|x64"
```
