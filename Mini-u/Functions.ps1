function Rename-Directory() {
    param (
        [Parameter()]
        [string]
        $Directory
    )

    BoxyPrompt("Input new directory name")
    $NewName = Read-Host -Prompt " " ; Clear-Host
    Rename-Item $env:USERPROFILE\$Directory -NewName $NewName
    Write-Host "Directory $env:USERPROFILE\$Directory has been renamed to $env:USERPROFILE\$NewName!" -ForegroundColor DarkMagenta
    Start-Sleep 2
}

function  Remove-Directory() {
    param (
        [Parameter()]
        [string]
        $Directory
    )

    Remove-Item $env:USERPROFILE\$Directory
    Write-Host "Directory $env:USERPROFILE\$Directory has been deleted!" -ForegroundColor DarkMagenta
    Start-Sleep 2
}

function Create-Directory() {
    param (
        [Parameter()]
        [string]
        $Directory
    )

    New-Item $env:USERPROFILE\$Directory -ItemType Directory
    Write-Host "Directory $env:USERPROFILE\$Directory has been created!" -ForegroundColor DarkMagenta
    Start-Sleep 2
}