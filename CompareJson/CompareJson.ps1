###### Dependencies #########
. .\ConvertToHashtable.ps1
. .\WriteLine.ps1
###############################

Function Compare-Json() {
<# 
.SYNOPSIS
Compare two JSON files and return a difference file.

.DESCRIPTION
Given a reference and comparison file, this function will recursively compare the objects
within two JSON files by a specified ID. ConvertToHashtable.ps1 is required to ensure that
the incoming objects during recursion are in the correct format. WriteLine.ps1 is used
to improve readability during debugging.

.NOTES
Author:     Lucas McGlamery

Version:    v1.0 -- 18 Jan 2023
                - Initial release
                
            v1.1 -- 23 Jun 2023
                - Added key exclusion
                - Added WriteLine.ps1
.PARAMETER Table1
Reference object derived from the reference file used for recursion.

.PARAMETER Table2
Comparison object derived from the comparison file used for recursion.

.PARAMETER ReferenceFile
File to be used as reference. Must by a valid JSON file.

.PARAMETER ComparisonFile
File to be compared against the reference. Must by a valid JSON file.

.PARAMETER ID
Specified object ID. Default is 'Name'.

.PARAMETER DifferenceFound
Boolean placeholder for future implementation.

.PARAMETER ParentTable
Table used to assign reference root objects with key/value of Parent: true.

.PARAMETER KeyExclusions
A string array of keys to exclude should they need to be omitted during comparison.

.EXAMPLE
Compare-Json -ReferenceFile .\Reference.json -ComparisonFile .\Deployment.json
#>
    Param(
    [Parameter()]
    [Object[]]$Table1,
    [Parameter()]
    [Object[]]$Table2,
    [Parameter()] 
    [string]$ReferenceFile, 
    [Parameter()] 
    [string]$ComparisonFile,
    [Parameter()]
    [string]$ID = 'Name',
    [Parameter()]
    [bool]$DifferenceFound = $false,
    [Parameter()]
    [array]$ParentTable = @(),
    [Parameter()]
    [string[]]$KeyExclusions
)

if ($ReferenceFile -and $ComparisonFile) {
    $Table1 = Get-Content $ReferenceFile | ConvertFrom-Json -AsHashtable -Depth 10
    $Table2 = Get-Content $ComparisonFile | ConvertFrom-Json -AsHashtable -Depth 10
    $Table1 | ForEach-Object {
        if ($_.Name -notcontains 'Parent') {
            $_.Add('Parent', $true)
        }
    }
    $Table2 | ForEach-Object {
        if ($_.Name -notcontains 'Parent') {
            $_.Add('Parent', $true)
        }
    }
}
if (!$Global:ParentTable) {
    $Global:ParentTable = @()
}
Write-Host $ParentTable.GetType()
Write-Host "Table1 keys are $($Table1.Keys)"
Write-Host "Table2 keys are $($Table2.Keys)"


    # set the current key name
    # if count is one, set the table key to be the only available key
    if ($Table1.Keys.Count -gt 1) {
        $Table1Key = $ID
    } 
    elseif ($Table1.Values.Count -gt 1) {
        $Table1Key = "$($Table1.Keys)"
    } 
    else {
        $Table1Key = $Table1.Keys
    }
    if ($Table2.Keys.Count -gt 1) {
        $Table2Key = $ID
    }
    elseif ($Table2.Values.Count -gt 1) {
        $Table2Key = "$($Table2.Keys)"
    }
    else {
        $Table2Key = $Table2.Keys
    }
    Write-Host "Table1Key is $($Table1Key)" -ForegroundColor DarkYellow
    Write-Host "Table2Key is $($Table2Key)" -ForegroundColor DarkYellow


    if ($Table1Key -notin $KeyExclusions) {
        foreach ($Item in $Table1.$Table1Key) {
            Write-Host "Current item in table is " $Item -ForegroundColor DarkGreen
            Write-Host "Current list of names: " $Item.$ID
    
            if ($Item.GetType() -ne [System.String]) {
                Write-Host "Type is not a System.String" -ForegroundColor Red
                $CurrentTable = $Table1.$Table1Key | Where-Object {
                    $_.$ID -eq $Item.$ID
                }
                $SecondTable = $Table2.$Table2Key | Where-Object {
                    $_.$ID -eq $Item.$ID
                }
            } else {
                $CurrentTable = $Table1 | Where-Object {
                    $_.$Table1Key -eq $Item
                $SecondTable = $Table2 | Where-Object {
                    $_.$Table2Key -eq $Item
                }
            }
            }
            if ($null -eq $CurrentTable) {
                Write-Host "Current table is null. Continuing with next object..." -BackgroundColor DarkYellow
                continue
            }
            if($CurrentTable.Parent){
                Write-Host "Adding table to ParentTable..."
                $Global:ParentTable += $CurrentTable
            }
            if ($null -eq $SecondTable) {
                Write-Host "Current second table is null. Adding last parent to difference table. Continuing..." -BackgroundColor DarkYellow
                if(!$Global:DifferenceTable) {
                    $Global:DifferenceTable = @()
                }
                if($Global:DifferenceTable.Name -notcontains $Global:ParentTable[-1].Name) {
                    $Global:DifferenceTable += $Global:ParentTable[-1]
                }
                continue
            }
            Write-Host "The current tables are as follows: `n" -BackgroundColor Green
            Write-Line
            Write-Host "Current table" 
            $CurrentTable
            Write-Host "Second table" 
            $SecondTable
    
            $CurrentTable.GetEnumerator() | Where-Object {
                $_.$ID -notin $KeyExclusions
            } | ForEach-Object {
                $CurrentKey = $_
                $CurrentKeyName = $_.$ID
                Write-Host "CurrentKeyName is $($CurrentKeyName)" -ForegroundColor DarkGreen
                $CurrentSecondTable = $SecondTable.GetEnumerator() | Where-Object {
                    $_.$ID -eq $CurrentKeyName
                }
                Write-Host "CurrentFirstTable is: $($CurrentKey)" -ForegroundColor DarkGreen
                Write-Host "CurrentSecondTable is: $($CurrentSecondTable)" -ForegroundColor DarkBlue

                if ($CurrentKey.Value.GetType() -ne [System.String]) {
                    Write-Host "CurrentKey is $($CurrentKey.GetType())"
                    Write-Host "SecondTable current key is $($CurrentSecondTable.GetType())"

                    if ($CurrentKey.GetType().Name -ne 'Hashtable') {
                        $CurrentKey = ConvertTo-Hashtable $CurrentKey
                        Write-Host "CurrentKey is now $($CurrentKey.GetType())"
                    }
                    if ($CurrentSecondTable.GetType().Name -ne 'Hashtable') {
                        $CurrentSecondTable = ConvertTo-Hashtable $CurrentSecondTable
                        Write-Host "SecondTable current key is now $($CurrentSecondTable.GetType())"
                    }
                    if ($_.Value.$ID) {
                        Write-Host "Value found containing key $ID. Recuring function...`n" -BackgroundColor DarkMagenta
                        Write-Line
                        Compare-Json $CurrentKey $CurrentSecondTable -ParentTable $Global:ParentTable
                    }
                } elseif ($CurrentKey.Count -eq 1) {
                    Write-Host "Current key: $CurrentKey" -ForegroundColor DarkGreen
                    Write-Host "Current second table: $CurrentSecondTable" -ForegroundColor DarkGreen
                    if (!$CurrentKey.Equals($CurrentSecondTable)) {
                        if(!$Global:DifferenceTable) {
                            $Global:DifferenceTable = @()
                        }
                        if($Global:DifferenceTable.Name -notcontains $($Global:ParentTable[-1].Name)) {
                            Write-host "Difference found. Adding $($Global:ParentTable[-1].Name) to difference table..." -BackgroundColor DarkYellow
                            $Global:DifferenceTable += $Global:ParentTable[-1]
                        }
                    } elseif ($CurrentKey.Equals($CurrentSecondTable)) {
                        Write-host "No difference found."
                    }
                }
            }
        }
    }
    $DifferenceTable | ConvertTo-Json -Depth 10 | Out-File .\DifferenceReport.json
}