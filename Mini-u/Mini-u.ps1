if (!(Get-Module -Name BoxyPrompt)) {
    Import-Module $PSScriptRoot\BoxyPrompt\BoxyPrompt.ps1
}


function mini-u {
<#
.SYNOPSIS
	This function serves as an example of how I implement dynamic
    command line interface menus in PowerShell. To use this, run
    'Import-Module .\Mini-u.ps1' from within this project's directory.
.DESCRIPTION
    The main menu is a representation of the names of JSON files within
    the 'menus' directory with numbers respective to the amount of JSON
    files in this directory i.e., an array is dynamically created based
    on the .Count of the the items in 'menus'. When a selection is made
    from the main menu, a new menu is presented. This submenu is the
    contents of the selected JSON file, which is another menu. The logic
    is repeated for the submenu choice selection.

    BoxyPrompt.ps1 draws a box around a string to simply make it
    prettier. This only works for single line strings.
.NOTES
    Version:    v1.0 -- 7 Dec 2022
	Author:     Lucas McGlamery
.EXAMPLE
	PS> mini-u
#>
    $MainMenu = (Get-Item $PSScriptRoot\menus\*).BaseName

    Clear-Host
    "Select a submenu by number" | Boxy-Prompt -BoxWidth 40
    1..$MainMenu.Count | ForEach-Object {
        Write-Host $_ $MainMenu[$_ - 1] | Format-List
    }
    $SubMenuSelection = Read-Host -Prompt " " ; Clear-Host

    $MenuOptions = Get-Content -Path $PSScriptRoot\menus\$($MainMenu[$SubMenuSelection - 1])".json" | ConvertFrom-Json
    "Select a menu option" | Boxy-Prompt -BoxWidth 40
    1..$MenuOptions.Count | ForEach-Object {
        Write-Host $_ $MenuOptions[$_ - 1].Name
    } | Format-List
    $MenuOptionSelection = Read-Host -Prompt " " ; Clear-Host
}