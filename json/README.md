# James's Really Useful JSON Scripts

A collection of scripts useful when manipulating JSON data in PowerShell.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Convert-JSONL2CSV](#convert-jsonl2csv)

---

## [Convert-JSONL2CSV](./Convert-JSONL2CSV.psm1)

Converts a JSON Lines (JSONL) file to a CSV file. This script is useful for transforming structured JSON data into a tabular format that can be easily analyzed or imported into spreadsheet applications.

```powershell
Convert-JSONL2CSV -Path "data.jsonl" -OutputPath "data.csv"
```
