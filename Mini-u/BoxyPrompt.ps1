function BoxyPrompt {
<#
.SYNOPSIS
	Draw a box around a string!
.DESCRIPTION
    Given a string, BoxyPrompt draws a box around it to simply make it
    prettier. This only works for single line strings.
.NOTES
    Version:    v1.0 -- 7 Dec 2022
	Author:     Lucas McGlamery
.EXAMPLE
	PS> BoxyPrompt 'Potato!'
.EXAMPLE
    PS> $string | BoxyPrompt
#>
    param (
        [Parameter(ValueFromPipeline)]
        [string]$prompt
    )
    $boxWidth = $prompt.Length + 10
    $boxHeight = 5
    
    $promptStart = ([math]::round($boxWidth / 2) - [math]::round((($prompt.Length) / 2) - 1))
    $promptEnd = $promptStart + $prompt.Length - 1
    
    1..$boxHeight | ForEach-Object {
        if ($_ -eq 1 -or $_ -eq $boxHeight) {
            1..$boxWidth | ForEach-Object {
                if ($_ -lt $boxWidth) {
                    Write-Host -NoNewline "#"
                } else {
                    Write-Host "#"
                }
            }
        }
        elseif ($_ -eq 2 -or $_ -eq 4) {
            1..$boxWidth | ForEach-Object {
                if ($_ -eq 1) {
                    Write-Host -NoNewline "#"
                } elseif ($_ -ne 1 -and $_ -ne $boxWidth) {
                    Write-Host -NoNewline " "
                } else {
                    Write-Host "#"
                }
            }
        }
        elseif ($_ -eq 3) {
            1..$boxWidth | ForEach-Object {
                if ($_ -eq 1) {
                    Write-Host -NoNewline "#"
                } elseif ($_ -eq $promptStart) {
                    Write-Host -NoNewline $prompt
                } elseif ($_ -gt 1 -and $_ -lt $boxWidth -and $promptStart..$promptEnd -notcontains $_) {
                    Write-Host -NoNewline " "
                } elseif ($_ -eq $boxWidth) {
                    Write-Host "#"
                } 
            }
        }
    }
}