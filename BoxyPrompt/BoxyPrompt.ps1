<# 
.SYNOPSIS
Draw a cool box around a prompt!
.DESCRIPTION
Draw a cool box around a prompt! Boxy-Prompt can do it all! Like draw a box!
Well, perhaps that's about all it can do... but it leverages Wrap-Text to
keep your really cool messages within a prescribed width. Oh! Padding! It
can adjust for prescribed padding. 
.NOTES
Author: Lucas McGlamery
Version:
1.0 1/12/23  Initial release
TODO:
- Make the character which the box is drawn customizable
- Account for really long character strings
- Perform better parameter input validation
.PARAMETER Prompt
An array object to hold text or multiple elements of text.
.PARAMETER BoxWidth
Specified width integer. Default is width of the terminal.
.PARAMETER SidePadding
Specified padding integer for space with text and sides of box. Default is 5.
.EXAMPLE
Boxy-Prompt
.EXAMPLE
Boxy-Prompt $string
.EXAMPLE
$string | Boxy-Prompt
.EXAMPLE
$string | Boxy-Prompt -BoxWidth 420 -SidePadding 69
#>
. .\WrapText.ps1
function Boxy-Prompt {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [Object[]]$Prompt,
        [Parameter()]
        [int]$BoxWidth = $Host.UI.RawUI.BufferSize.Width,
        [Parameter()]
        [int]$SidePadding = 5
    )
    if ($BoxWidth -gt $Host.UI.RawUI.BufferSize.Width) {
        $BoxWidth = $Host.UI.RawUI.BufferSize.Width
    }
    if ($BoxWidth -lt 35) {
        $BoxWidth = 35
    }
    if ($SidePadding -lt 5) {
        $SidePadding = 5
    }
    $Prompt = Wrap-Text $Prompt $($BoxWidth - $SidePadding)
    [bool]$PromptWritten = $false

    $LongestLength = 0
    $Prompt | ForEach-Object {
        if ($_.Length -gt $LongestLength) {
            $LongestLength = $_.Length
        }
    }
    $BoxHeight = $($Prompt.Count + 4)
    
    $PromptStart = ([math]::round($BoxWidth / 2) - [math]::round((($LongestLength) / 2) - 1))
    $PromptEnd = $PromptStart + $LongestLength - 1
    
    1..$BoxHeight | ForEach-Object {
        if ($_ -eq 1 -or $_ -eq $BoxHeight) {
            Write-Host ('#' * $BoxWidth -join '')
        }
        elseif ($_ -eq 2 -or $_ -eq ($BoxHeight - 1)) {
            1..$BoxWidth | ForEach-Object {
                if ($_ -eq 1) {
                    Write-Host -NoNewline "#"
                } elseif ($_ -ne 1 -and $_ -ne $BoxWidth) {
                    Write-Host -NoNewline " "
                } else {
                    Write-Host "#"
                }
            }
        }
        elseif (!$PromptWritten) {
            $Prompt | ForEach-Object {
                $LeftPadding = 0
                [bool]$break = $false
                Write-Host -NoNewline "#"
                1..$($PromptStart - 1) | ForEach-Object {
                    $LeftPadding++
                    Write-Host -NoNewline " "
                }
                Write-Host -NoNewline $_
                if ($BoxWidth -eq ($_.Length + ([math]::round($SidePadding/2)+3))) {
                    Write-Host "#"
                    $break = $true
                }
                if(!$break){
                    1..($BoxWidth - (($_.Length + $LeftPadding)+2)) | ForEach-Object {
                        Write-Host -NoNewline " "
                    }
                    Write-Host "#"
                }
                $PromptWritten = $true
            }
        }
    }
}