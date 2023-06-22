function Draw-Menu {
    param ($menuItems, $menuPosition, $menuTitle)
    $foregroundColor = $host.UI.RawUI.ForegroundColor
    $backgroundColor = $host.UI.RawUI.BackgroundColor
    $l = $menuItems.length
    Clear-Host
    $menuTitle | Boxy-Prompt -BoxWidth 40

    for ($i = 0; $i -le $l; $i++) {
        Write-Host "`t" -NoNewLine
        if ($i -eq $menuPosition) {
            Write-Host "$($menuItems[$i])" -ForegroundColor $backgroundColor -BackgroundColor $foregroundColor
        } else {
            Write-Host "$($menuItems[$i])" -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
        }
    }
}

function Menu {
    param ([array]$menuItems, $menuTitle = "MENU")
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