<#
.SYNOPSIS
	Mock them!
.DESCRIPTION
    This function iterates through the characters of a string and performs
    mock casing for letters. The output is piped to the clipboard for ease
    of delivery and returned to the console.
.NOTES
    Version:    v1.0 -- 5 Jan 2023
	Author:     Lucas McGlamery
.EXAMPLE
	PS> Mock-Them "That's not very nice of you"
#>
function Mock-Them {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string]$string
    )
    
    begin {
        $i = 0
        $output = $null
    }
    
    process {
        foreach($character in $string.ToCharArray()) {
            if ($character -notmatch '^[a-zA-Z]') {
                $output += $character
                $i++
                continue
            }
            if (++$i % 2) {
                $output += $character.ToString().ToUpper()
            } else {
                $output += $character.ToString().ToLower()
            }
        }
    }
    
    end {
        $output | clip
        return $output
    }
}