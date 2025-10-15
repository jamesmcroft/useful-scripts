# James's Really Useful .NET Scripts

A collection of scripts useful when working with .NET projects and applications.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Entity Framework](#entity-framework)
  - [Add-DbMigration](#add-dbmigration)

---

## Entity Framework

### [Add-DbMigration](./Add-DbMigration.psm1)

Adds a new Entity Framework migration to the current project. This script simplifies the process of creating migrations by allowing you to specify the migration name, context name, and output directory.

```powershell
Add-DbMigration -MigrationName "InitialCreate" -ContextName "MyDbContext" -OutputDir "Data/Migrations"
```
