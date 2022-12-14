if (!(Get-Module -Name BoxyPrompt)) {
    Import-Module .\BoxyPrompt.ps1
}
if (!(Get-Module -Name Functions)) {
    Import-Module .\Functions.ps1
}

function mini-u {
<#
.SYNOPSIS
	This function serves as an example of how I implement dynamic
    command line interface menus in PowerShell. To use this, run
    'Import-Module .\Mini-u.ps1' from within this project's directory.
.DESCRIPTION
    This little app is an answer to a question from Reddit user
    Subject_Chemistry269, although it seems to have taken a bit of
    a detour... I hope this helps you out!

    BoxyPrompt.ps1 draws a box around a string to simply make it
    prettier. This only works for single line strings.
.NOTES
    Version:    v1.0 -- 14 Dec 2022
	Author:     Lucas McGlamery
.EXAMPLE
	PS> mini-u
#>
    $MainMenu = Get-Content .\menus\TechnicalMenu.json | ConvertFrom-Json
    $Directories = (Get-Content .\menus\Directories.json | ConvertFrom-Json).Directories

    do{
        Clear-Host
        BoxyPrompt("Select a task")
        1..$MainMenu.Count | ForEach-Object {
            Write-Host $_ ($MainMenu[$_ - 1]).Name | Format-List
        }
        $TechnicalMenuSelection = Read-Host -Prompt " " ; Clear-Host
    
        $MenuObject = $($MainMenu[$TechnicalMenuSelection - 1])
        if ($MenuObject.Name -eq 'Quit') {
            break
        }
        BoxyPrompt("Select a directory")
        1..$Directories.Count | ForEach-Object {
            Write-Host $_ $Directories[$_ - 1]
        } | Format-List
        $DirectorySelection = Read-Host -Prompt " " ; Clear-Host
        $Directory = $Directories[$DirectorySelection - 1]
    
        # need to check if new directory name is needed
        if ($Directory -eq 'Other/Create new directory') {
            BoxyPrompt("Input directory name")
            $Directory = Read-Host -Prompt " " ; Clear-Host
        }
    
        # update the selected menu object's directory name
        $MenuObject.Params.Directory = $Directory
    
        # generate script text to reflect desired function against target
        # directory with all named parameters
        $ScriptText = $MenuObject.ScriptText
        $MenuObject.Params | Get-Member -Type Properties | ForEach-Object Name | ForEach-Object {
            $ScriptText = $ScriptText + ' -' + $_ + ' $' + $_
        }
    
        Invoke-Expression $ScriptText
    } until ($MenuObject.Name -eq 'Quit')
}