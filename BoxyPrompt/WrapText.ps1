<# 
.SYNOPSIS
Wraps text within a given constraint.
.DESCRIPTION
Wraps text within a given constraint. If no constraint is given, default is the width of the terminal.
Since the WordBlock parameter is an array object, either a single string or an array of strings can be
passed in.
.NOTES
Author: Lucas McGlamery
Version:
1.0 1/12/23  Initial release
.PARAMETER WordBlock
An array object to hold text or multiple elements of text.
.PARAMETER Width
Specified width integer. Default is width of the terminal.
.EXAMPLE
Wrap-Text -WordBlock $string -Width 60
.EXAMPLE
$string | Wrap-Text
.EXAMPLE 
$string | Wrap-Text -Width 60
#>
function Wrap-Text {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [Object[]]$WordBlock,
        [Parameter()]
        [int]$Width = $Host.UI.RawUI.BufferSize.Width
    )
    if ($Width -gt $Host.UI.RawUI.BufferSize.Width) {
        $Width = $Host.UI.RawUI.BufferSize.Width
    }
    $WrappedText = @()
    foreach ($Line in $WordBlock) {
        $String = ''
        $Count = 0
        $Line -split '\s+' | ForEach-Object{
            $Count += $_.Length + 1
            if ($Count -gt $Width) {
                $WrappedText += $String
                $String = ''
                $Count = $_.Length + 1
            }
            $String = "$($String)$($_) "
        }
        $WrappedText += $String
    }
    return $WrappedText
}