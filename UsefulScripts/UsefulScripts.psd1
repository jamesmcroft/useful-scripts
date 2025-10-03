@{
    RootModule        = 'UsefulScripts.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'b3c2d5e9-0f9d-4c4a-9d2d-b2f0a0c4a9c1'
    Author            = 'James Croft'
    CompanyName       = 'James Croft'
    Copyright         = "(c) 2025 James Croft. All rights reserved."
    Description       = 'Aggregates all helper script modules (azure, git, docker, build, dotnet, python, json, etc.) into a single autoloadable meta module.'
    PowerShellVersion = '5.1'

    FunctionsToExport = '*'
    AliasesToExport   = '*'
    CmdletsToExport   = @()
    VariablesToExport = @()

    PrivateData       = @{
        PSData = @{
            Tags         = @('utility', 'devops', 'git', 'azure', 'docker', 'dotnet', 'python', 'json')
            LicenseUri   = 'https://raw.githubusercontent.com/jamesmcroft/useful-scripts/main/LICENSE'
            ProjectUri   = 'https://github.com/jamesmcroft/useful-scripts'
            ReleaseNotes = 'Initial manifest for meta module.'
        }
    }
}
