function ConvertTo-Hashtable {
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Object]
        $InputObject
    )
    
    begin {
        $OutputHash = @{}
    }
    
    process {
        $OutputHash.Add($InputObject.Name, $InputObject.Value)
    }
    
    end {
        return $OutputHash
    }
}