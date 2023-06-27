function Draw-Menu {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String[]]
        $menuItems,
        [Parameter()]
        [int32]
        $menuPosition,
        [Parameter()]
        [String]
        $menuTitle
    )
    $foregroundColor = $host.UI.RawUI.ForegroundColor
    $backgroundColor = $host.UI.RawUI.BackgroundColor
    $l = $menuItems.length
    $description = (Get-Content ".\menus\$($curItem).json" | ConvertFrom-Json).Description
    $consoleWidth = $host.ui.RawUI.WindowSize.Width
    $leftPadding = ($consoleWidth - $menuTitle.Length) / 2
    $paddingString = ' ' * ([Math]::Max(0, $leftPadding))
    Clear-Host
    Write-Host $('-' * $consoleWidth -join '')
    Write-Host ($paddingString)($menuTitle)
    Write-Host $('-' * $consoleWidth -join '')

    for ($i = 0; $i -le $l; $i++) {
        Write-Host "`t" -NoNewLine
        if ($i -eq $menuPosition) {
            Write-Host "$($menuItems[$i])" -ForegroundColor $backgroundColor -BackgroundColor $foregroundColor
            $curItem = $menuItems[$i]
        } else {
            Write-Host "$($menuItems[$i])" -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
        }
    }
    Write-Host $('-' * $consoleWidth -join '')
    Write-Host ($paddingString)('Description')
    Write-Host $('-' * $consoleWidth -join '')
    Write-Host (Get-Content ".\menus\$($curItem).json" | ConvertFrom-Json).Description

}

function Menu {
    #param ([array]$menuItems, $menuTitle = "MENU")
    [CmdletBinding()]
    param (
        [Parameter()]
        [String[]]
        $menuItems,
        [Parameter()]
        [String]
        $menuTitle = "Menu"
    )
    $keycode = 0
    $pos = 0
    Draw-Menu $menuItems $pos $menuTitle
    while ($keycode -ne 13) {
        $press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
        $keycode = $press.virtualkeycode
        Write-host "$($press.character)" -NoNewLine
        if ($keycode -eq 38) {$pos--}
        if ($keycode -eq 40) {$pos++}
        if ($pos -lt 0) {$pos = ($menuItems.length - 1)}
        if ($pos -ge $menuItems.length) {$pos = 0}
        Draw-Menu $menuItems $pos $menuTitle
    }
    return $($menuItems[$pos])
}